//
//  EntityDetailView.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/28/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

@objc protocol EntityDetailViewDelegate {
    optional func entityDetailView(entityDetailView:EntityDetailView, shouldChangeEntityName name:String) -> Bool
}

@IBDesignable
class EntityDetailView: NibDesignableView, NSTextFieldDelegate {
    static let TAG = NSStringFromClass(EntityDetailView)
    
    weak var delegate:EntityDetailViewDelegate?
    
    @IBOutlet var nameTextField: NSTextField! {
        willSet {
            newValue!.delegate = self
        }
    }
    
    @IBOutlet var superClassTextField: NSTextField! {
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
    
    @IBInspectable var superClassName:String {
        set {
            self.superClassTextField.stringValue = newValue
        }
        
        get {
            return self.superClassTextField.stringValue
        }
    }
    
    func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        //TODO: identify text end editin in which field
        if let shouldEnd = self.delegate?.entityDetailView?(self, shouldChangeEntityName: fieldEditor.string!) {
            return shouldEnd
        }
        return true
    }
}
