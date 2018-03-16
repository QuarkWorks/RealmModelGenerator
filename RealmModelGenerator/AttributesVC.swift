//
//  AttributesVC.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/31/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

protocol AttributesVCDelegate: AnyObject {
    func attributesVC(attributesVC: AttributesVC, selectedAttributeDidChange attribute:Attribute?)
}

class AttributesVC: NSViewController, AttributesViewDelegate, AttributesViewDataSource, Observer {
    static let TAG = NSStringFromClass(AttributesVC.self)
    
    @IBOutlet weak var attributesView: AttributesView! {
        didSet {
            self.attributesView.delegate = self
            self.attributesView.dataSource = self
        }
    }
    
    weak var selectedEntity: Entity? {
        didSet {
            if oldValue === self.selectedEntity { return }
            oldValue?.observable.removeObserver(observer: self)
            self.selectedEntity?.observable.addObserver(observer: self)
            selectedAttribute = nil
            self.invalidateViews()
        }
    }
    
    private weak var selectedAttribute: Attribute? {
        didSet {
            if oldValue === self.selectedAttribute { return }
            invalidateSelectedIndex()
            self.delegate?.attributesVC(attributesVC: self, selectedAttributeDidChange: self.selectedAttribute)
        }
    }

    private var ascending:Bool = true {
        didSet{ self.invalidateViews() }
    }
    
    private var isSortByType = false {
        didSet{ self.invalidateViews() }
    }
    
    private var isSortedByColumnHeader = false

    weak var delegate: AttributesVCDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func onChange(observable: Observable) {
        self.invalidateViews()
    }
    
    func invalidateViews() {
        if !self.isViewLoaded { return }
        
        if isSortedByColumnHeader {
            sortAttributes()
        }
        self.attributesView.reloadData()
        invalidateSelectedIndex()
    }
    
    func invalidateSelectedIndex() {
        self.attributesView.selectedIndex = self.selectedEntity?.attributes.index(where: {$0 === self.selectedAttribute})
    }
    
    // MARK: - Update selected attribute after its detail changed
    func updateSelectedAttribute(selectedAttribute: Attribute) {
        self.selectedAttribute = selectedAttribute
        invalidateViews()
    }
    
    func sortAttributes() {
        guard let selectedEntity = self.selectedEntity else {
            return
        }
        
        if ascending {
            if isSortByType {
                selectedEntity.attributes.sort{ (e1, e2) -> Bool in
                    return e1.type.rawValue < e2.type.rawValue
                }
            } else {
                selectedEntity.attributes.sort{ (e1, e2) -> Bool in
                    return e1.name < e2.name
                }
            }
        } else {
            if isSortByType {
                selectedEntity.attributes.sort{ (e1, e2) -> Bool in
                    return e1.type.rawValue > e2.type.rawValue
                }
            } else {
                selectedEntity.attributes.sort{ (e1, e2) -> Bool in
                    return e1.name > e2.name
                }
            }
        }
        
        if let primaryKey = self.selectedEntity!.primaryKey {
            if let pk = selectedEntity.attributes.filter({$0 === primaryKey}).first {
                selectedEntity.attributes.remove(at: selectedEntity.attributes.index{$0 === pk}!)
                selectedEntity.attributes.insert(pk, at: 0)
            }
        }
    }
    
    // MARK: - AttributesViewDataSource
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
                if self.selectedEntity!.attributes.count <= 1 {
                    self.selectedAttribute = nil
                } else if index == self.selectedEntity!.attributes.count - 1 {
                    self.selectedAttribute = self.selectedEntity!.attributes[index - 1]
                } else {
                    self.selectedAttribute = self.selectedEntity!.attributes[index + 1]
                }
            }
        
            self.selectedEntity!.removeAttribute(attribute: attribute)
        }
    }
    
    func attributesView(attributesView: AttributesView, selectedIndexDidChange index: Int?) {
        self.selectedAttribute = index == nil ? nil : self.selectedEntity?.attributes[index!]
    }
    
    func attributesView(attributesView: AttributesView, shouldChangeAttributeName name: String, atIndex index: Int) -> Bool {
        let attribute = self.selectedEntity!.attributes[index]
        do {
            try attribute.setName(name: name)
        } catch {
            Tools.popupAllert(messageText: "Error", buttonTitile: "OK", informativeText: "Unable to rename attribute: \(attribute.name) to: \(name). There is an attribute with the same name.")
            return false
        }
        return true
    }
    
    func attributesView(attributesView: AttributesView, atIndex index: Int, changeAttributeType attributeType: AttributeType) {
        self.selectedEntity?.attributes[index].type = attributeType
    }
    
    func attributesView(attributesView: AttributesView, sortByColumnName name: String, ascending: Bool) {
        self.isSortedByColumnHeader = true
        self.ascending = ascending
        self.isSortByType = name == AttributesView.TYPE_COLUMN ? true : false
    }
    
    func attributesView(attributesView: AttributesView, dragFromIndex: Int, dropToIndex: Int) {
        guard let selectedEntity = self.selectedEntity else {
            return
        }
        
        self.isSortedByColumnHeader = false
        let draggedAttribute = selectedEntity.attributes[dragFromIndex]
        selectedEntity.attributes.remove(at: dragFromIndex)
        
        if dropToIndex >= selectedEntity.attributes.count {
            selectedEntity.attributes.insert(draggedAttribute, at: dropToIndex - 1)
        } else {
            selectedEntity.attributes.insert(draggedAttribute, at: dropToIndex)
        }
        
        invalidateViews()
    }
}
