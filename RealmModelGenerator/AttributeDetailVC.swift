//
//  AttributeDetailVC.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/29/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

class AttributeDetailVC: NSViewController, AttributeDetailViewDelegate, Observer {
    static let TAG = NSStringFromClass(AttributeDetailVC.self)

    @IBOutlet weak var attributeDetailView: AttributeDetailView! {
        didSet{ self.attributeDetailView.delegate = self }
    }
    
    weak var attribute:Attribute? {
        didSet{
            if oldValue === self.attribute { return }
            oldValue?.observable.removeObserver(observer: self)
            self.attribute?.observable.addObserver(observer: self)
            self.invalidateViews()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func invalidateViews() {
        if !self.isViewLoaded || attribute == nil { return }
        guard let attribute = self.attribute else {
            return
        }
        attributeDetailView.name = attribute.name
        attributeDetailView.isIgnored = attribute.isIgnored
        attributeDetailView.isIndexed = attribute.isIndexed
        attributeDetailView.isPrimary = attribute.entity.primaryKey === attribute
        attributeDetailView.isRequired = attribute.isRequired
        attributeDetailView.hasDefault = attribute.hasDefault
        attributeDetailView.defaultValue = attribute.defaultValue
        attributeDetailView.selectedIndex =  AttributeType.values.index(of: attribute.type)!
    }
    
    func onChange(observable: Observable) {
        self.invalidateViews()
    }
    
    // MARK: - AttributeDetailView delegate
    func attributeDetailView(attributeDetailView: AttributeDetailView, shouldChangeAttributeTextField newValue: String, control:NSControl) -> Bool {
        guard let attribute = self.attribute else {
            return false
        }
        if control === self.attributeDetailView.nameTextField {
            do {
                try attribute.setName(name: newValue)
            } catch {
                Tools.popupAllert(messageText: "Error", buttonTitile: "OK", informativeText: "Unable to rename attribute: \(attribute.name) to: \(newValue). There is an attribute with the same name.")
                return false

            }
        } else {
            attribute.defaultValue = newValue
        }
        
        return true
    }
    
    func attributeDetailView(attributeDetailView: AttributeDetailView, shouldChangeAttributeCheckBoxFor sender: NSButton, state: Bool) -> Bool {
        guard let attribute = self.attribute else {
            return false
        }
        switch sender {
        case self.attributeDetailView.ignoredCheckBox:
            attribute.isIgnored = state
            break;
        case self.attributeDetailView.indexedCheckBox:
            do {
                try attribute.setIndexed(isIndexed: state)
            } catch {
                Tools.popupAllert(messageText: "Error", buttonTitile: "OK", informativeText: "Unable to set index for attribute \(attribute.name) with type \(attribute.type.rawValue) ")
                return false
            }
            break;
        case self.attributeDetailView.primaryCheckBox:
            if state {
                do {
                    try attribute.entity.setPrimaryKey(primaryKey: attribute)
                } catch {
                    Tools.popupAllert(messageText: "Error", buttonTitile: "OK", informativeText: "Unable to set primary key for attribute \(attribute.name) with type \(attribute.type.rawValue) ")
                    return false
                }
            } else {
                if attribute.entity.primaryKey === attribute {
                    try! attribute.entity.setPrimaryKey(primaryKey: nil)
                }
            }
            break;
        case self.attributeDetailView.requiredCheckBox:
            attribute.isRequired = state
            break;
        case self.attributeDetailView.defaultCheckBox:
            attribute.hasDefault = state
            break;
        default:
            break
        }
        
        return true
    }
    
    func attributeDetailView(attributeDetailView: AttributeDetailView, selectedTypeDidChange selectedIndex: Int) -> Bool {
        self.attribute!.type = AttributeType.values[selectedIndex]
        return true
    }
}
