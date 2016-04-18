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
            if let entity = self.selectedEntity {
                self.attributes = entity.attributes
            } else {
                self.attributes = []
            }
            self.invalidateViews()
        }
    }
    
    private weak var selectedAttribute: Attribute? {
        didSet {
             previousSelectedAttribute = oldValue
            if oldValue === self.selectedAttribute { return }
            invalidateSelectedIndex()
            self.delegate?.attributesVC(self, selectedAttributeDidChange: self.selectedAttribute)
        }
    }
    
    private var attributes: [Attribute] = []
    weak var previousSelectedAttribute: Attribute?

    private var acending:Bool = true {
        didSet{ self.invalidateViews() }
    }
    
    private var isSortByType = false {
        didSet{ self.invalidateViews() }
    }

    weak var delegate: AttributesVCDelegate?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func onChange(observable: Observable) {
        if self.selectedEntity?.attributes.count != self.attributes.count {
            self.attributes = (self.selectedEntity?.attributes)!
        }
        self.invalidateViews()
    }
    
    func invalidateViews() {
        if !self.viewLoaded { return }
        updateItemOrder()
        self.attributesView.reloadData()
        invalidateSelectedIndex()
    }
    
    func invalidateSelectedIndex() {
        self.attributesView.selectedIndex = self.attributes.indexOf({$0 === self.selectedAttribute})
    }
    
    //MARK: - Update selected attribute after its detail changed
    func updateSelectedAttribute(selectedAttribute: Attribute) {
        self.selectedAttribute = selectedAttribute
        invalidateViews()
    }
    
    func updateItemOrder() {
        if selectedEntity == nil { return }
        if acending {
            if isSortByType {
                self.attributes = self.selectedEntity!.attributes.sort{ return $0.type.rawValue < $1.type.rawValue }
            } else {
                self.attributes = self.selectedEntity!.attributes.sort{ return $0.name < $1.name }
            }
        } else {
            if isSortByType {
                self.attributes = self.selectedEntity!.attributes.sort{ return $0.type.rawValue > $1.type.rawValue }
            } else {
                self.attributes = self.selectedEntity!.attributes.sort{ return $0.name > $1.name }
            }
        }
        
        if let primaryKey = self.selectedEntity!.primaryKey {
            if let pk = self.attributes.filter({$0 === primaryKey}).first {
                self.attributes.removeAtIndex(attributes.indexOf{$0 === pk}!)
                self.attributes.insert(pk, atIndex: 0)
            }
        }
        
        self.selectedEntity?.attributes
    }
    
    //MARK: - AttributesViewDataSource
    func numberOfRowsInAttributesView(attributesView: AttributesView) -> Int {
        return self.attributes.count
    }
    
    func attributesView(attributesView: AttributesView, titleForAttributeAtIndex index: Int) -> String {
        return self.attributes[index].name
    }
    
    func attributesView(attributesView: AttributesView, typeForAttributeAtIndex index: Int) -> AttributeType {
        return self.attributes[index].type
    }
    
    //MAKR: - AttributesViewDelegate
    func addAttributeInAttributesView(attributesView: AttributesView) {
        if self.selectedEntity != nil {
            let attribute = self.selectedEntity!.createAttribute()
            // We don't need to reload attributes and we append new attriube to current list
            // and update the list
            self.attributes.append(attribute)
            self.selectedAttribute = attribute
        }
    }
    
    func attributesView(attributesView: AttributesView, removeAttributeAtIndex index: Int) {
        let attribute = self.attributes[index]
        if attribute === self.selectedAttribute {
            if self.attributes.count <= 1 {
                self.selectedAttribute = nil
            } else if index == self.attributes.count - 1 {
                self.selectedAttribute = self.attributes[index - 1]
            } else {
                self.selectedAttribute = self.attributes[index + 1]
            }
        }
        
        self.selectedEntity!.removeAttribute(attribute)
    }
    
    func attributesView(attributesView: AttributesView, selectedIndexDidChange index: Int?) {
        if let index = index {
            self.selectedAttribute = self.attributes[index]
        } else {
            self.selectedAttribute = nil
        }
    }
    
    func attributesView(attributesView: AttributesView, shouldChangeAttributeName name: String, atIndex index: Int) -> Bool {
        let attribute = self.attributes[index]
        do {
            try attribute.setName(name)
        } catch {
            Tools.popupAllert("Error", buttonTitile: "OK", informativeText: "Unable to rename attribute: \(attribute.name) to: \(name). There is an attribute with the same name.")
            return false
        }
        return true
    }
    
    func attributesView(attributesView: AttributesView, atIndex index: Int, changeAttributeType attributeType: AttributeType) {
        self.attributes[index].type = attributeType
    }
    
    func attributesView(attributesView: AttributesView, sortByColumnName name: String, ascending: Bool) {
        if previousSelectedAttribute != nil {
            self.selectedAttribute = previousSelectedAttribute
        }
        self.acending = ascending
        self.isSortByType = name == AttributesView.TYPE_COLUMN ? true : false
    }
}
