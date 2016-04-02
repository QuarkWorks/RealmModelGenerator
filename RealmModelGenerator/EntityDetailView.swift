//
//  EntityDetailView.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/28/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

protocol EntityDetailViewDelegate: class {
    func entityDetailView(entityDetailView:EntityDetailView, shouldChangeEntityName name:String) -> Bool
}

@IBDesignable
class EntityDetailView: NibDesignableView, NSTextFieldDelegate {
    static let TAG = NSStringFromClass(EntityDetailView)
    
    @IBOutlet var nameTextField:NSTextField!
    @IBOutlet var superClassTextField:NSTextField!
    
    weak var delegate:EntityDetailViewDelegate?
    
    override func nibDidLoad() {
        super.nibDidLoad()
    }
    
    @IBInspectable var name:String {
        set { self.nameTextField.stringValue = newValue }
        
        get { return self.nameTextField.stringValue }
    }
    
    @IBInspectable var superClassName:String {
        set { self.superClassTextField.stringValue = newValue }
        
        get { return self.superClassTextField.stringValue }
    }
    
    func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        //TODO: identify text end editin in which field
        if let shouldEnd = self.delegate?.entityDetailView(self, shouldChangeEntityName: fieldEditor.string!) {
            return shouldEnd
        }
        return true
    }
}
