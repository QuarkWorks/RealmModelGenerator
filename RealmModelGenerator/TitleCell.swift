//
//  TitleCell.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/10/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

protocol TitleCellDelegate: AnyObject {
    func titleCell(titleCell:TitleCell, shouldChangeTitle title:String) -> Bool
}

@IBDesignable
class TitleCell: NibDesignableView, NSTextFieldDelegate {
    static let IDENTIFIER = "TitleCell"
    
    @IBOutlet var titleTextField:NSTextField!
    @IBOutlet var letterTextField:NSTextField!
    
    weak var delegate:TitleCellDelegate?
    
    // Workaround for Xcode bug that prevents you from connecting the delegate in the storyboard.
    // Remove this extra property once Xcode gets fixed.
    @IBOutlet var ibDelegate:Any? {
        set { self.delegate = newValue as? TitleCellDelegate }
        get { return self.delegate }
    }
    
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
    
    func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        if let shouldEnd = self.delegate?.titleCell(titleCell: self, shouldChangeTitle: fieldEditor.string) {
            return shouldEnd
        }
        
        return true
    }
}
