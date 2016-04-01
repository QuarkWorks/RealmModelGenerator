//
//  AttributeDetailViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/29/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

@objc protocol AttributeDetailViewControllerDelegate {
    optional func attributeDetailDidChange(attributeDetailViewController:AttributeDetailViewController)
}

class AttributeDetailViewController: NSViewController, AttributeDetailViewDelegate {
    static let TAG = NSStringFromClass(AttributeDetailViewController)

    @IBOutlet weak var attributeDetailView: AttributeDetailView!
    weak var delegate: AttributeDetailViewControllerDelegate?
    
    var attribute: Attribute?
    var defaultAttribute: Attribute? {
        willSet(defaultAttribute) {
            attribute = defaultAttribute
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attributeDetailView.delegate = self
    }
    
    override func viewWillAppear() {
        if attribute != nil {
            attributeDetailView.name = attribute!.name
        }
    }
    
    func attributeDetailView(attributeDetailView: AttributeDetailView, shouldChangeAttributeName name: String) -> Bool {
        do {
            try self.attribute!.setName(name)
            self.delegate?.attributeDetailDidChange?(self)
        } catch {
            let alert = NSAlert()
            alert.messageText = "Error"
            alert.addButtonWithTitle("OK")
            alert.informativeText = "Unable to rename entity: \(attribute!.name) to: \(name). There is an entity with the same name."
            alert.runModal()
            return false

        }
        return true
    }
}
