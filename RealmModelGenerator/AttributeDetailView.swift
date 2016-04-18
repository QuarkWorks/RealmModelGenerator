//
//  AttributeDetailView.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/29/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

protocol AttributeDetailViewDelegate: class {
    func attributeDetailView(attributeDetailView:AttributeDetailView, shouldChangeAttributeTextField newValue:String, control:NSControl) -> Bool
    func attributeDetailView(attributeDetailView:AttributeDetailView, shouldChangeAttributeCheckBoxFor sender:NSButton, state:Bool) -> Bool
    func attributeDetailView(attributeDetailView:AttributeDetailView, selectedTypeDidChange selectedIndex:Int) -> Bool
}

@IBDesignable
class AttributeDetailView: NibDesignableView, NSTextFieldDelegate {
    static let TAG = NSStringFromClass(AttributeDetailView)
    
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
        self.attributeTypePopUpButton.addItemsWithTitles(AttributeType.values.flatMap({$0.rawValue}))
    }
    
    @IBInspectable var name:String {
        set { self.nameTextField.stringValue = newValue }
        
        get { return self.nameTextField.stringValue }
    }
    
    @IBInspectable var isIgnored:Bool {
        set { self.ignoredCheckBox.state = newValue ? 1 : 0 }
        get { return self.ignoredCheckBox.state == 1 ? true : false }
    }
    
    @IBInspectable var isIndexed:Bool {
        set { self.indexedCheckBox.state = newValue ? 1 : 0 }
        get { return self.indexedCheckBox.state == 1 ? true : false }
    }
    
    @IBInspectable var isPrimary:Bool {
        set { self.primaryCheckBox.state = newValue ? 1 : 0 }
        get { return self.primaryCheckBox.state == 1 ? true : false }
    }
    
    @IBInspectable var isRequired:Bool {
        set { self.requiredCheckBox.state = newValue ? 1 : 0 }
        get { return self.requiredCheckBox.state == 1 ? true : false }
    }
    
    @IBInspectable var hasDefault:Bool {
        set { self.defaultCheckBox.state = newValue ? 1 : 0 }
        get { return self.defaultCheckBox.state == 1 ? true : false }
    }
    
    @IBInspectable var attributeTypeNames:[String] {
        set {
            self.attributeTypePopUpButton.removeAllItems()
            self.attributeTypePopUpButton.addItemsWithTitles(newValue)
        }
        
        get {
            return self.attributeTypePopUpButton.itemTitles
        }
    }
    
    @IBInspectable var selectedIndex:Int {
        set {
            self.attributeTypePopUpButton.selectItemAtIndex(newValue)
            if self.previousSelectedIndex != newValue {
                self.previousSelectedIndex = newValue
            }
            
            if ((AttributeType.values[newValue] == AttributeType.Unknown) || (AttributeType.values[newValue] == AttributeType.Blob)) {
                self.defaultValueTextField.enabled = false
                self.defaultCheckBox.enabled = false
            } else {
                self.defaultValueTextField.enabled = true
                self.defaultCheckBox.enabled = true
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
    
    func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        if let shouldEnd = self.delegate?.attributeDetailView(self, shouldChangeAttributeTextField: fieldEditor.string!, control: control) {
            return shouldEnd
        }
        
        return true
    }
    
    @IBAction func checkBoxStateChanged(sender: NSButton) {
        if let shouldChangeState = self.delegate?.attributeDetailView(self, shouldChangeAttributeCheckBoxFor: sender, state: sender.state == 1) {
            if shouldChangeState == false {
                switch sender {
                case self.ignoredCheckBox:
                    ignoredCheckBox.state = 0
                    break;
                case self.indexedCheckBox:
                    indexedCheckBox.state = 0
                    break;
                case self.primaryCheckBox:
                    primaryCheckBox.state = 0
                    break;
                case self.requiredCheckBox:
                    requiredCheckBox.state = 0
                    break;
                case self.defaultCheckBox:
                    defaultCheckBox.state = 0
                    break;
                default:
                    break
                }
            }
        }
    }
    
    @IBAction func attributeTypeChanged(sender: NSPopUpButton) {
        if let shouldSelect = self.delegate?.attributeDetailView(self, selectedTypeDidChange: selectedIndex) {
            if !shouldSelect {
                self.selectedIndex = self.previousSelectedIndex
            }
        }
    }
}
