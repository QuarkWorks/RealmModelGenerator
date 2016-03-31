//
//  EntityCell.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/10/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

@objc protocol TitleCellDelegate {
    optional func titleCell(titleCell:TitleCell, shouldChangeTitle title:String) -> Bool
}

@IBDesignable
class TitleCell: NibDesignableView, NSTextFieldDelegate {
    static let IDENTIFIER = "TitleCell"

    weak var delegate:TitleCellDelegate?
    
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
    
    func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        if let shouldEnd = self.delegate?.titleCell?(self, shouldChangeTitle: fieldEditor.string!) {
            return shouldEnd
        }
        return true
    }
}