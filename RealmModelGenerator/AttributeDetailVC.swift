//
//  AttributeDetailViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/29/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

class AttributeDetailVC: NSViewController, AttributeDetailViewDelegate, Observer {
    static let TAG = NSStringFromClass(AttributeDetailVC)

    @IBOutlet weak var attributeDetailView: AttributeDetailView! {
        didSet{ self.attributeDetailView.delegate = self }
    }
    
    weak var attribute:Attribute? {
        didSet{
            self.view.hidden = attribute == nil
            if oldValue === self.attribute { return }
            self.attribute?.observable.addObserver(self)
            self.invalidateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func invalidateViews() {
        if !self.viewLoaded || attribute == nil { return }
        attributeDetailView.name = attribute!.name
        //TODO: Add other details
    }
    
    func onChange(observable: Observable) {
        self.invalidateViews()
    }
    
    func attributeDetailView(attributeDetailView: AttributeDetailView, shouldChangeAttributeName name: String) -> Bool {
        do {
            try self.attribute!.setName(name)
        } catch {
            Tools.popupAllert("Error", buttonTitile: "OK", informativeText: "Unable to rename attribute: \(attribute!.name) to: \(name). There is an attribute with the same name.")
            return false

        }
        return true
    }
}
