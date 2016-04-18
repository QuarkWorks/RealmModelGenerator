//
//  AttributeDetailViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/29/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

class AttributeDetailVC: NSViewController, AttributeDetailViewDelegate, Observer {
    static let TAG = NSStringFromClass(AttributeDetailVC)

    @IBOutlet weak var attributeDetailView: AttributeDetailView! {
        didSet{ self.attributeDetailView.delegate = self }
    }
    
    weak var attribute:Attribute? {
        didSet{
            if oldValue === self.attribute { return }
            oldValue?.observable.removeObserver(self)
            self.attribute?.observable.addObserver(self)
            self.invalidateViews()
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func invalidateViews() {
        if !self.viewLoaded || attribute == nil { return }
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
        attributeDetailView.selectedIndex =  AttributeType.values.indexOf(attribute.type)!
    }
    
    func onChange(observable: Observable) {
        self.invalidateViews()
    }
    
    //MARK: - AttributeDetailView delegate
    func attributeDetailView(attributeDetailView: AttributeDetailView, shouldChangeAttributeTextField newValue: String, control:NSControl) -> Bool {
        if control === self.attributeDetailView.nameTextField {
            do {
                try self.attribute!.setName(newValue)
            } catch {
                Tools.popupAllert("Error", buttonTitile: "OK", informativeText: "Unable to rename attribute: \(attribute!.name) to: \(newValue). There is an attribute with the same name.")
                return false

            }
        } else {
            //TODO: Check if new value is valid based on properties
            attribute!.defaultValue = newValue
        }
        
        return true
    }
    
    func attributeDetailView(attributeDetailView: AttributeDetailView, shouldChangeAttributeCheckBoxFor sender: NSButton, state: Bool) -> Bool {
        switch sender {
        case self.attributeDetailView.ignoredCheckBox:
            self.attribute?.isIgnored = state
            break;
        case self.attributeDetailView.indexedCheckBox:
            do {
                try self.attribute?.setIndexed(state)
            } catch {
                Tools.popupAllert("Error", buttonTitile: "OK", informativeText: "Unable to set index for attribute \(self.attribute!.name) with type \(self.attribute!.type.rawValue) ")
                return false
            }
            break;
        case self.attributeDetailView.primaryCheckBox:
            if state {
                do {
                    try self.attribute?.entity.setPrimaryKey(self.attribute)
                } catch {
                    Tools.popupAllert("Error", buttonTitile: "OK", informativeText: "Unable to set primary key for attribute \(self.attribute!.name) with type \(self.attribute!.type.rawValue) ")
                    return false
                }
            } else {
                if self.attribute?.entity.primaryKey === self.attribute {
                    try! self.attribute?.entity.setPrimaryKey(nil)
                }
            }
            break;
        case self.attributeDetailView.requiredCheckBox:
            self.attribute?.isRequired = state
            break;
        case self.attributeDetailView.defaultCheckBox:
            self.attribute?.hasDefault = state
            break;
        default:
            break
        }
        
        return true
    }
    
    func attributeDetailView(attributeDetailView: AttributeDetailView, selectedTypeDidChange selectedIndex: Int) -> Bool {
        //TODO check if the selected type is allowed or not based on properties
        self.attribute!.type = AttributeType.values[selectedIndex]
        return true
    }
}
