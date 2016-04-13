//
//  AttributeDetailView.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/29/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

protocol AttributeDetailViewDelegate: class {
    func attributeDetailView(attributeDetailView:AttributeDetailView, shouldChangeAttributeTextField newValue:String, identifier:String) -> Bool
    func attributeDetailView(attributeDetailView:AttributeDetailView, shouldChangeAttributeCheckBoxFor identifier:String, state:Bool) -> Bool
    func attributeDetailView(attributeDetailView:AttributeDetailView, selectedTypeDidChange selectedIndex:Int) -> Bool
}

@IBDesignable
class AttributeDetailView: NibDesignableView, NSTextFieldDelegate {
    static let TAG = NSStringFromClass(AttributeDetailView)
    
    static let NAME_TEXTFEILD = "nameTextField"
    static let DEFAULT_TEXTFIELD = "defaultTextField"
    static let INGORED_CHECKBOX = "ignoredCheckBox"
    static let INDEXED_CHECKBOX = "indexedCheckBox"
    static let REQUIRED_CHECKBOX = "requiredCheckBox"
    static let PRIMARY_CHECKBOX = "primaryCheckBox"
    static let DEFAULT_CHECKBOX = "defaultCheckBox"
    
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
        if let shouldEnd = self.delegate?.attributeDetailView(self, shouldChangeAttributeTextField: fieldEditor.string!, identifier: control.identifier!) {
            return shouldEnd
        }
        
        return true
    }
    
    @IBAction func checkBoxStateChanged(sender: NSButton) {
        if let shouldChangeState = self.delegate?.attributeDetailView(self, shouldChangeAttributeCheckBoxFor: sender.identifier!, state: sender.state == 1) {
            if shouldChangeState == false {
                switch sender.identifier! {
                case AttributeDetailView.INGORED_CHECKBOX:
                    ignoredCheckBox.state = 0
                    break;
                case AttributeDetailView.INDEXED_CHECKBOX:
                    indexedCheckBox.state = 0
                    break;
                case AttributeDetailView.PRIMARY_CHECKBOX:
                    primaryCheckBox.state = 0
                    break;
                case AttributeDetailView.REQUIRED_CHECKBOX:
                    requiredCheckBox.state = 0
                    break;
                case AttributeDetailView.DEFAULT_CHECKBOX:
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
