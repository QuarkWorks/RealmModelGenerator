//
//  AttributesViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/31/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

@objc protocol AttributesViewControllerDelegate {
    optional func attributesViewController(attributesViewController: AttributesViewController, selectionChange index:Int)
}

class AttributesViewController: NSViewController, AttributesViewDelegate, AttributesViewDataSource {
    static let TAG = NSStringFromClass(AttributesViewController)
    
    static let SELECTED_NONE_INDEX = -1
    
    @IBOutlet weak var attributesView: AttributesView!
    
    private var entity: Entity?
    weak var delegate:AttributesViewControllerDelegate?
    
    var defaultEntity:Entity? {
        willSet(defaultEntity) {
            entity = defaultEntity
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attributesView.delegate = self
        attributesView.dataSource = self
    }
    
    override func viewWillAppear() {
        attributesView.reloadData()
    }
    
    //MARK: - AttributesViewDataSource
    func numberOfRowsInAttributesView(attributesView: AttributesView) -> Int {
        return (entity == nil) ? 0 : entity!.attributes.count
    }
    
    func attributesView(attributesView: AttributesView, titleForAttributeAtIndex index: Int) -> String? {
        return entity!.attributes[index].name
    }
    
    //MAKR: - AttributesViewDelegate
    func addAttributeInAttributesView(attributesView: AttributesView) {
        if entity != nil {
            entity!.createAttribute()
        }
    }
    
    func attributesView(attributesView: AttributesView, removeAttributeAtIndex index: Int) {
        entity!.removeAttribute(entity!.attributes[index])
        self.delegate?.attributesViewController?(self, selectionChange: AttributesViewController.SELECTED_NONE_INDEX)
    }
    
    func attributesView(attributesView: AttributesView, selectionChange index: Int) {
        self.delegate?.attributesViewController?(self, selectionChange: index)
    }
    
    func attributesView(attributesView: AttributesView, shouldChangeAttributeName name: String, atIndex index: Int) -> Bool {
        let attribute = entity!.attributes[index]
        do {
            try attribute.setName(name)
            self.delegate?.attributesViewController?(self, selectionChange: index)
        } catch {
            let alert = NSAlert()
            alert.messageText = "Error"
            alert.addButtonWithTitle("OK")
            alert.informativeText = "Unable to rename attribute: \(attribute.name) to: \(name). There is an attribute with the same name."
            alert.runModal()
            return false
        }
        return true
    }
}
