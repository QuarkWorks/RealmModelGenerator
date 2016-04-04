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

class AttributesVC: NSViewController, AttributesViewDelegate, AttributesViewDataSource {
    static let TAG = NSStringFromClass(AttributesVC)
    
    @IBOutlet weak var attributesView: AttributesView! {
        didSet {
            self.attributesView.delegate = self
            self.attributesView.dataSource = self
        }
    }
    
    weak var entity: Entity? {
        didSet {
            invalidateViews()
            selectedAttribute = nil
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
    
    func invalidateViews() {
        if !self.viewLoaded { return }
        self.attributesView.reloadData()
        invalidateSelectedIndex()
    }
    
    func invalidateSelectedIndex() {
        self.attributesView.selectedIndex = self.entity?.attributes.indexOf({$0 === self.selectedAttribute})
    }
    
    //MARK: - Update selected attribute after its detail changed
    func updateSelectedAttribute(selectedAttribute: Attribute) {
        self.selectedAttribute = selectedAttribute
        invalidateViews()
    }
    
    //MARK: - AttributesViewDataSource
    func numberOfRowsInAttributesView(attributesView: AttributesView) -> Int {
        return (self.entity == nil) ? 0 : self.entity!.attributes.count
    }
    
    func attributesView(attributesView: AttributesView, titleForAttributeAtIndex index: Int) -> String {
        return self.entity!.attributes[index].name
    }
    
    //MAKR: - AttributesViewDelegate
    func addAttributeInAttributesView(attributesView: AttributesView) {
        if self.entity != nil {
            let attribute = self.entity!.createAttribute()
            self.selectedAttribute = attribute
            self.invalidateViews()
        }
    }
    
    func attributesView(attributesView: AttributesView, removeAttributeAtIndex index: Int) {
        let attribute = self.entity!.attributes[index]
        let isSelectedAttribute = attribute === self.selectedAttribute
        self.entity!.removeAttribute(self.entity!.attributes[index])
        self.invalidateViews()
        
        if isSelectedAttribute {
            if self.entity!.attributes.count == 0 {
                self.selectedAttribute = nil
            } else if index < self.entity!.attributes.count {
                self.selectedAttribute = self.entity!.attributes[index]
            } else {
                self.selectedAttribute = self.entity!.attributes[self.entity!.attributes.count - 1]
            }
        }
        
        self.delegate?.attributesVC(self, selectedAttributeDidChange:self.selectedAttribute)
    }
    
    func attributesView(attributesView: AttributesView, selectedIndexDidChange index: Int?) {
        if let index = index {
            self.selectedAttribute = self.entity!.attributes[index]
        } else {
            self.selectedAttribute = nil
        }
    }
    
    func attributesView(attributesView: AttributesView, shouldChangeAttributeName name: String, atIndex index: Int) -> Bool {
        let attribute = entity!.attributes[index]
        do {
            try attribute.setName(name)
            defer { self.invalidateViews() }
            self.delegate?.attributesVC(self, selectedAttributeDidChange: attribute)
        } catch {
            Tools.popupAllert("Error", buttonTitile: "OK", informativeText: "Unable to rename attribute: \(attribute.name) to: \(name). There is an attribute with the same name.")
            return false
        }
        return true
    }
}
