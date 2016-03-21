//
//  EntityCell.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/10/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

@IBDesignable
class TitleCell: NibDesignableView, NSTextFieldDelegate {
    static let IDENTIFIER = "TitleCell"

    @IBOutlet var titleTextField:NSTextField! {
        willSet {
            newValue!.delegate = self
        }
    }
    
    @IBOutlet var letterTextField:NSTextField!
    
    override func nibDidLoad() {
        super.nibDidLoad()
    }
    
    @IBInspectable var letterColor:NSColor? {
        set {
            self.letterTextField.backgroundColor = newValue
        }

        get {
            return self.letterTextField.backgroundColor
        }
    }
    
    @IBInspectable var title:String {
        set {
            self.titleTextField.stringValue = newValue
        }
        
        get {
            return self.titleTextField.stringValue
        }
    }
    
    @IBInspectable var letter:String {
        set {
            self.letterTextField.stringValue = newValue
        }

        get {
            return self.letterTextField.stringValue
        }
    }
    
    func control(control: NSControl, textShouldBeginEditing fieldEditor: NSText) -> Bool {
        return true
    }
    
    func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        return true
    }
}