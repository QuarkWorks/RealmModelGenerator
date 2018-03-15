//
//  EntityDetailView.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/28/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

protocol EntityDetailViewDelegate: AnyObject {
    func entityDetailView(entityDetailView:EntityDetailView, shouldChangeEntityName name:String) -> Bool
    func entityDetailView(entityDetailView:EntityDetailView, selectedSuperClassDidChange superEntity:String)
}

@IBDesignable
class EntityDetailView: NibDesignableView, NSTextFieldDelegate, NSMenuDelegate {
    static let TAG = NSStringFromClass(EntityDetailView.self)
    
    @IBOutlet var nameTextField:NSTextField!
    
    @IBOutlet weak var superClassPopUpButton: NSPopUpButton!
    weak var delegate:EntityDetailViewDelegate?
    
    override func nibDidLoad() {
        super.nibDidLoad()
    }
    
    @IBInspectable var name:String {
        set { self.nameTextField.stringValue = newValue }
        
        get { return self.nameTextField.stringValue }
    }
    
    @IBInspectable var superClassNames:[String] {
        set {
            self.superClassPopUpButton.removeAllItems()
            self.superClassPopUpButton.addItems(withTitles: newValue)
        }
        
        get {
            return self.superClassPopUpButton.itemTitles
        }
    }
    
    @IBInspectable var selectedItemIndex:Int {
        set {
            self.superClassPopUpButton.selectItem(at: newValue)
        }
        
        get {
            return self.superClassPopUpButton.indexOfSelectedItem
        }
    }
    
    func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        if let shouldEnd = self.delegate?.entityDetailView(entityDetailView: self, shouldChangeEntityName: fieldEditor.string!) {
            return shouldEnd
        }
        return true
    }
    
    @IBAction func superClassChanged(sender: NSPopUpButton) {
        self.delegate?.entityDetailView(entityDetailView: self, selectedSuperClassDidChange: superClassNames[selectedItemIndex])
    }
}
