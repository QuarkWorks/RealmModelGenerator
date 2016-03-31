//
//  AttributesViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/31/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

protocol AttributesViewControllerDelegate {
    func attributeSelected(attribute: Attribute?)
}

class AttributesViewController: NSViewController, AttributesViewDelegate, AttributesViewDataSource {

    @IBOutlet weak var attributesView: AttributesView!
    
    private var entity: Entity?
    
    var delegate:AttributesViewControllerDelegate?
    
    var defaultEntity:Entity? {
        willSet(defaultEntity) {
            entity = defaultEntity
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attributesView.delegate = self
        attributesView.dataSource = self
        
        //TODO: Remove test entity
        let schema = Schema()
        let model = schema.createModel()
        entity = model.createEntity()
    }
    
    //MARK: - AttributesViewDataSource
    func numberOfRowsInAttributesView(attributesView: AttributesView) -> Int {
        return entity!.attributes.count
    }
    
    func attributesView(attributesView: AttributesView, titleForAttributeAtIndex index: Int) -> String? {
        return entity!.attributes[index].name
    }
    
    //MAKR: - AttributesViewDelegate
    func addAttributeInAttributesView(attributesView: AttributesView) {
        entity!.createAttribute()
    }
    
    func attributesView(attributesView: AttributesView, removeAttributeAtIndex index: Int) {
        entity!.removeAttribute(entity!.attributes[index])
        self.delegate?.attributeSelected(nil)
    }
    
    func attributesView(attributesView: AttributesView, selectionChange index: Int) {
        self.delegate?.attributeSelected(entity!.attributes[index])
    }
    
    func attributesView(attributesView: AttributesView, shouldChangeAttributeName name: String, atIndex index: Int) -> Bool {
        let attribute = entity!.attributes[index]
        do {
            try attribute.setName(name)
            self.delegate?.attributeSelected(attribute)
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
