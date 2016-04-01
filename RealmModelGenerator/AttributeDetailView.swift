//
//  AttributeDetailView.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/29/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

@objc protocol AttributeDetailViewDelegate {
    optional func attributeDetailView(attributeDetailView:AttributeDetailView, shouldChangeAttributeName name:String) -> Bool
}

@IBDesignable
class AttributeDetailView: NibDesignableView, NSTextFieldDelegate {
    static let TAG = NSStringFromClass(AttributeDetailView)
    
    weak var delegate:AttributeDetailViewDelegate?
    
    @IBOutlet var nameTextField: NSTextField! {
        willSet {
            newValue!.delegate = self
        }
    }
    
    override func nibDidLoad() {
        super.nibDidLoad()
    }
    
    @IBInspectable var name:String {
        set {
            self.nameTextField.stringValue = newValue
        }
        
        get {
            return self.nameTextField.stringValue
        }
    }
    
    func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        if let shouldEnd = self.delegate?.attributeDetailView?(self, shouldChangeAttributeName: fieldEditor.string!) {
            return shouldEnd
        }
        return true
    }
}
