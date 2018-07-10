//
//  AttributeDetailView.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/29/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

protocol AttributeDetailViewDelegate: AnyObject {
    func attributeDetailView(attributeDetailView:AttributeDetailView, shouldChangeAttributeTextField newValue:String, control:NSControl) -> Bool
    func attributeDetailView(attributeDetailView:AttributeDetailView, shouldChangeAttributeCheckBoxFor sender:NSButton, state:Bool) -> Bool
    func attributeDetailView(attributeDetailView:AttributeDetailView, selectedTypeDidChange selectedIndex:Int) -> Bool
}

// --MARK-- assuming push buttons have two states
@IBDesignable
class AttributeDetailView: NibDesignableView, NSTextFieldDelegate {
    static let TAG = NSStringFromClass(AttributeDetailView.self)
    
    private var previousSelectedIndex = 0;
    
    @IBOutlet var nameTextField:NSTextField!
    @IBOutlet weak var defaultValueTextField: NSTextField!
    
    @IBOutlet weak var attributeTypePopUpButton: NSPopUpButton!
    @IBOutlet weak var ignoredCheckBox: NSButton!
    @IBOutlet weak var indexedCheckBox: NSButton!
    @IBOutlet weak var primaryCheckBox: NSButton!
    @IBOutlet weak var requiredCheckBox: NSButton!
    @IBOutlet weak var defaultCheckBox: NSButton!
    
    weak var delegate:AttributeDetailViewDelegate?
    
    override func nibDidLoad() {
        super.nibDidLoad()
        self.attributeTypePopUpButton.removeAllItems()
        self.attributeTypePopUpButton.addItems(withTitles: AttributeType.values.compactMap({$0.rawValue}))
    }
    
    @IBInspectable var name:String {
        set { self.nameTextField.stringValue = newValue }
        
        get { return self.nameTextField.stringValue }
    }
    
    @IBInspectable var isIgnored:Bool {
        set { self.ignoredCheckBox.state = newValue ? .on : .off }
        get { return self.ignoredCheckBox.state == .on ? true : false }
    }
    
    @IBInspectable var isIndexed:Bool {
        set { self.indexedCheckBox.state = newValue ? .on : .off }
        get { return self.indexedCheckBox.state == .on ? true : false }
    }
    
    @IBInspectable var isPrimary:Bool {
        set { self.primaryCheckBox.state = newValue ? .on : .off }
        get { return self.primaryCheckBox.state == .on ? true : false }
    }
    
    @IBInspectable var isRequired:Bool {
        set { self.requiredCheckBox.state = newValue ? .on : .off }
        get { return self.requiredCheckBox.state == .on ? true : false }
    }
    
    @IBInspectable var hasDefault:Bool {
        set { self.defaultCheckBox.state = newValue ? .on : .off }
        get { return self.defaultCheckBox.state == .on ? true : false }
    }
    
    @IBInspectable var attributeTypeNames:[String] {
        set {
            self.attributeTypePopUpButton.removeAllItems()
            self.attributeTypePopUpButton.addItems(withTitles: newValue)
        }
        
        get {
            return self.attributeTypePopUpButton.itemTitles
        }
    }
    
    @IBInspectable var selectedIndex:Int {
        set {
            self.attributeTypePopUpButton.selectItem(at: newValue)
            if self.previousSelectedIndex != newValue {
                self.previousSelectedIndex = newValue
            }
            
            if ((AttributeType.values[newValue] == .Unknown) || (AttributeType.values[newValue] == .Blob)) {
                self.defaultValueTextField.isEnabled = false
                self.defaultCheckBox.isEnabled = false
            } else {
                self.defaultValueTextField.isEnabled = true
                self.defaultCheckBox.isEnabled = true
            }
        }
        
        get {
            return self.attributeTypePopUpButton.indexOfSelectedItem
        }
    }
    
    @IBInspectable var defaultValue:String {
        set { self.defaultValueTextField.stringValue = newValue }
        
        get { return self.defaultValueTextField.stringValue }
    }
    
    func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        if let shouldEnd = self.delegate?.attributeDetailView(attributeDetailView: self, shouldChangeAttributeTextField: fieldEditor.string, control: control) {
            return shouldEnd
        }
        
        return true
    }
    
    @IBAction func checkBoxStateChanged(_ sender: NSButton) {
        if let shouldChangeState = self.delegate?.attributeDetailView(attributeDetailView: self, shouldChangeAttributeCheckBoxFor: sender, state: sender.state == .on) {
            if shouldChangeState == false {
                switch sender {
                case self.ignoredCheckBox:
                    ignoredCheckBox.state = .off
                    break;
                case self.indexedCheckBox:
                    indexedCheckBox.state = .off
                    break;
                case self.primaryCheckBox:
                    primaryCheckBox.state = .off
                    break;
                case self.requiredCheckBox:
                    requiredCheckBox.state = .off
                    break;
                case self.defaultCheckBox:
                    defaultCheckBox.state = .off
                    break;
                default:
                    break
                }
            }
        }
    }
    
    @IBAction func attributeTypeChanged(_ sender: NSPopUpButton) {
        if let shouldSelect = self.delegate?.attributeDetailView(attributeDetailView: self, selectedTypeDidChange: selectedIndex) {
            if !shouldSelect {
                self.selectedIndex = self.previousSelectedIndex
            }
        }
    }
}
