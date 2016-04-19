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

    private var acending:Bool = true {
        didSet{ self.invalidateViews() }
    }
    
    private var isSortByType = false {
        didSet{ self.invalidateViews() }
    }
    
    private var isSortedByColumnHeader = false

    weak var delegate: AttributesVCDelegate?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func onChange(observable: Observable) {
        self.invalidateViews()
    }
    
    func invalidateViews() {
        if !self.viewLoaded { return }
        updateItemOrder()
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
    
    func updateItemOrder() {
        guard let selectedEntity = self.selectedEntity else {
            return
        }
        if !isSortedByColumnHeader { return }
        
        if acending {
            if isSortByType {
                selectedEntity.attributes.sortInPlace{ (e1, e2) -> Bool in
                    return e1.type.rawValue < e2.type.rawValue
                }
            } else {
                selectedEntity.attributes.sortInPlace{ (e1, e2) -> Bool in
                    return e1.name < e2.name
                }
            }
        } else {
            if isSortByType {
                selectedEntity.attributes.sortInPlace{ (e1, e2) -> Bool in
                    return e1.type.rawValue > e2.type.rawValue
                }
            } else {
                selectedEntity.attributes.sortInPlace{ (e1, e2) -> Bool in
                    return e1.name > e2.name
                }
            }
        }
        
        if let primaryKey = self.selectedEntity!.primaryKey {
            if let pk = selectedEntity.attributes.filter({$0 === primaryKey}).first {
                selectedEntity.attributes.removeAtIndex(selectedEntity.attributes.indexOf{$0 === pk}!)
                selectedEntity.attributes.insert(pk, atIndex: 0)
            }
        }
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
        if let attribute = self.selectedEntity?.attributes[index] {
            if attribute === self.selectedAttribute {
                if self.selectedEntity?.attributes.count <= 1 {
                    self.selectedAttribute = nil
                } else if index == self.selectedEntity!.attributes.count - 1 {
                    self.selectedAttribute = self.selectedEntity!.attributes[index - 1]
                } else {
                    self.selectedAttribute = self.selectedEntity!.attributes[index + 1]
                }
            }
        
            self.selectedEntity!.removeAttribute(attribute)
        }
    }
    
    func attributesView(attributesView: AttributesView, selectedIndexDidChange index: Int?) {
        if let index = index {
            self.selectedAttribute = self.selectedEntity?.attributes[index]
        } else {
            self.selectedAttribute = nil
        }
    }
    
    func attributesView(attributesView: AttributesView, shouldChangeAttributeName name: String, atIndex index: Int) -> Bool {
        let attribute = self.selectedEntity!.attributes[index]
        do {
            try attribute.setName(name)
        } catch {
            Tools.popupAllert("Error", buttonTitile: "OK", informativeText: "Unable to rename attribute: \(attribute.name) to: \(name). There is an attribute with the same name.")
            return false
        }
        return true
    }
    
    func attributesView(attributesView: AttributesView, atIndex index: Int, changeAttributeType attributeType: AttributeType) {
        self.selectedEntity?.attributes[index].type = attributeType
    }
    
    func attributesView(attributesView: AttributesView, sortByColumnName name: String, ascending: Bool) {
        self.isSortedByColumnHeader = true
        self.acending = ascending
        self.isSortByType = name == AttributesView.TYPE_COLUMN ? true : false
    }
    
    func attributesView(attributesView: AttributesView, dragFromIndex: Int, dropToIndex: Int) {
        self.isSortedByColumnHeader = false
        let draggedAttribute = self.selectedEntity!.attributes[dragFromIndex]
        self.selectedEntity!.attributes.removeAtIndex(dragFromIndex)
        
        if dropToIndex >= self.selectedEntity?.attributes.count {
            self.selectedEntity!.attributes.insert(draggedAttribute, atIndex: dropToIndex - 1)
        } else {
            self.selectedEntity!.attributes.insert(draggedAttribute, atIndex: dropToIndex)
        }
        
        invalidateViews()
    }
}
