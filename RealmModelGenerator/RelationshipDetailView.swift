//
//  RelationshipDetailView.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/29/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

protocol RelationshipDetailViewDelegate: AnyObject {
    func relationshipDetailView(relationshipDetailView:RelationshipDetailView, shouldChangeRelationshipTextField newValue:String, identifier:NSUserInterfaceItemIdentifier) -> Bool
    func relationshipDetailView(relationshipDetailView:RelationshipDetailView, shouldChangeRelationshipCheckBoxFor identifier:NSUserInterfaceItemIdentifier, state:Bool) -> Bool
    func relationshipDetailView(relationshipDetailView:RelationshipDetailView, selectedDestinationDidChange selectedIndex:Int) -> Bool
}

// --MARK-- assuming push buttons have two states
@IBDesignable
class RelationshipDetailView: NibDesignableView, NSTextFieldDelegate {
    static let TAG = NSStringFromClass(RelationshipDetailView.self)
    
    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var destinationPopupButton: NSPopUpButton!
    @IBOutlet weak var toManyCheckBox: NSButton!
    
    weak var delegate:RelationshipDetailViewDelegate?
    
    override func nibDidLoad() {
        super.nibDidLoad()
    }
    
    @IBInspectable var name:String {
        set { self.nameTextField.stringValue = newValue }
        
        get { return self.nameTextField.stringValue }
    }
    
    @IBInspectable var isMany:Bool {
        set { self.toManyCheckBox.state = newValue ? .on : .off }
        get { return self.toManyCheckBox.state == .on ? true : false }
    }
    
    @IBInspectable var destinationNames:[String] {
        set {
            self.destinationPopupButton.removeAllItems()
            self.destinationPopupButton.addItems(withTitles: newValue)
        }
        
        get {
            return self.destinationPopupButton.itemTitles
        }
    }

    
    @IBInspectable var selectedIndex:Int {
        set {
            self.destinationPopupButton.selectItem(at: newValue)
        }
        
        get {
            return self.destinationPopupButton.indexOfSelectedItem
        }
    }
    
    func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        if let shouldEnd = self.delegate?.relationshipDetailView(relationshipDetailView: self, shouldChangeRelationshipTextField: fieldEditor.string,
                                                                 identifier: control.identifier!) {
            return shouldEnd
        }
        
        return true
    }
    
    @IBAction func destinationChanged(_ sender: NSPopUpButton) {
        self.delegate?.relationshipDetailView(relationshipDetailView: self, selectedDestinationDidChange: selectedIndex)
    }
    
    @IBAction func toManyCheckBoxStateChanged(_ sender: NSButton) {
        if let shouldChangeState = self.delegate?.relationshipDetailView(relationshipDetailView: self,
                                                                         shouldChangeRelationshipCheckBoxFor: sender.identifier!,
                                                                         state: sender.state == .on) {
            if shouldChangeState == false {
                toManyCheckBox.state = .off
            }
        }
    }
}
