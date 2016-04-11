//
//  AttributesViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/31/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

protocol AttributesVCDelegate: class {
    func attributesVC(attributesVC: AttributesVC, selectedAttributeDidChange attribute:Attribute?)
}

class AttributesVC: NSViewController, AttributesViewDelegate, AttributesViewDataSource, Observer {
    static let TAG = NSStringFromClass(AttributesVC)
    
    @IBOutlet weak var attributesView: AttributesView! {
        didSet {
            self.attributesView.delegate = self
            self.attributesView.dataSource = self
        }
    }
    
    weak var selectedEntity: Entity? {
        didSet {
            if oldValue === self.selectedEntity { return }
            oldValue?.observable.removeObserver(self)
            self.selectedEntity?.observable.addObserver(self)
            selectedAttribute = nil
            self.invalidateViews()
        }
    }
    
    private weak var selectedAttribute: Attribute? {
        didSet {
            if oldValue === self.selectedAttribute { return }
            invalidateSelectedIndex()
            self.delegate?.attributesVC(self, selectedAttributeDidChange: self.selectedAttribute)
        }
    }

    weak var delegate:AttributesVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func onChange(observable: Observable) {
        self.invalidateViews()
    }
    
    func invalidateViews() {
        if !self.viewLoaded { return }
        self.attributesView.reloadData()
        invalidateSelectedIndex()
    }
    
    func invalidateSelectedIndex() {
        self.attributesView.selectedIndex = self.selectedEntity?.attributes.indexOf({$0 === self.selectedAttribute})
    }
    
    //MARK: - Update selected attribute after its detail changed
    func updateSelectedAttribute(selectedAttribute: Attribute) {
        self.selectedAttribute = selectedAttribute
        invalidateViews()
    }
    
    //MARK: - AttributesViewDataSource
    func numberOfRowsInAttributesView(attributesView: AttributesView) -> Int {
        return self.selectedEntity == nil ? 0 : self.selectedEntity!.attributes.count
    }
    
    func attributesView(attributesView: AttributesView, titleForAttributeAtIndex index: Int) -> String {
        return self.selectedEntity!.attributes[index].name
    }
    
    func attributesView(attributesView: AttributesView, typeForAttributeAtIndex index: Int) -> AttributeType {
        return self.selectedEntity!.attributes[index].type
    }
    
    //MAKR: - AttributesViewDelegate
    func addAttributeInAttributesView(attributesView: AttributesView) {
        if self.selectedEntity != nil {
            let attribute = self.selectedEntity!.createAttribute()
            self.selectedAttribute = attribute
        }
    }
    
    func attributesView(attributesView: AttributesView, removeAttributeAtIndex index: Int) {
        let attribute = self.selectedEntity!.attributes[index]
        if attribute === self.selectedAttribute {
            if self.selectedEntity!.attributes.count <= 1 {
                self.selectedAttribute = nil
            } else if index == self.selectedEntity!.attributes.count - 1 {
                self.selectedAttribute = self.selectedEntity!.attributes[index - 1]
            } else {
                self.selectedAttribute = self.selectedEntity!.attributes[index + 1]
            }
        }
        
        self.selectedEntity!.removeAttribute(attribute)
    }
    
    func attributesView(attributesView: AttributesView, selectedIndexDidChange index: Int?) {
        if let index = index {
            self.selectedAttribute = self.selectedEntity!.attributes[index]
        } else {
            self.selectedAttribute = nil
        }
    }
    
    func attributesView(attributesView: AttributesView, shouldChangeAttributeName name: String, atIndex index: Int) -> Bool {
        let attribute = selectedEntity!.attributes[index]
        do {
            try attribute.setName(name)
        } catch {
            Tools.popupAllert("Error", buttonTitile: "OK", informativeText: "Unable to rename attribute: \(attribute.name) to: \(name). There is an attribute with the same name.")
            return false
        }
        return true
    }
    
    func attributesView(attributesView: AttributesView, atIndex index: Int, changeAttributeType attributeType: AttributeType) {
        self.selectedEntity!.attributes[index].setType(attributeType)
    }
}
