//
//  EntityCell.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/10/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa
import Quartz

@IBDesignable
class TitleCell: NibDesignableView, NSTextFieldDelegate {
    static let IDENTIFIER = "TitleCell"

    @IBOutlet var titleTextField:NSTextField! {
        willSet {
            newValue!.delegate = self
        }
    }
    
    @IBOutlet var letterTextField:NSTextField!
    
    override func nibDidInitialize() {
//        Swift.print("\(__FUNCTION__)")
//        self.wantsLayer = true
        //self.identifier = TitleCell.IDENTIFIER
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
//        Swift.print("\(__FUNCTION__)")
//        self.layer!.backgroundColor = NSColor.blueColor().CGColor
        return true
    }
    
    func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
//        Swift.print("\(__FUNCTION__)")
//        self.layer!.backgroundColor = NSColor.redColor().CGColor
        return true
    }
}