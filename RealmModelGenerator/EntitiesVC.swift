//
//  EntitieViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/21/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

protocol EntitiesVCDelegate: class {
    func entitiesVC(entitiesVC:EntitiesVC, selectedEntityDidChange entity:Entity?)
}

class EntitiesVC: NSViewController, EntitiesViewDelegate, EntitiesViewDataSource, Observer {
    static let TAG = NSStringFromClass(EntitiesVC)
    
    @IBOutlet weak var entitiesView: EntitiesView! {
        didSet {
            self.entitiesView.delegate = self
            self.entitiesView.dataSource = self
        }
    }
    
    var schema = Schema() {
        didSet {
            self.schema.observable.removeAllObservers()
            self.model = self.schema.currentModel
            invalidateViews()
            selectedEntity = nil
        }
    }
    
    private var model: Model! = nil {
        didSet{
            self.model.observable.addObserver(self)
        }
    }
    
    weak var selectedEntity: Entity? {
        didSet {
            if oldValue === self.selectedEntity { return }
            invalidateSelectedIndex()
            self.delegate?.entitiesVC(self, selectedEntityDidChange: self.selectedEntity)
        }
    }
    
    weak var delegate:EntitiesVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Observer
    func onChange(observable: Observable) {
        self.invalidateViews()
    }
    
    func invalidateViews() {
        if !self.viewLoaded { return }
        self.entitiesView.reloadData()
        invalidateSelectedIndex()
    }
    
    func invalidateSelectedIndex() {
        self.entitiesView.selectedIndex = self.model.entities.indexOf({$0 === self.selectedEntity})
    }

    //MARK: - EntitiesViewDataSource
    func numberOfRowsInEntitiesView(entitiesView: EntitiesView) -> Int {
        return self.model != nil ? self.model.entities.count : 0
    }
    
    func entitiesView(entitiesView:EntitiesView, titleForEntityAtIndex index:Int) -> String {
        return self.model.entities[index].name
    }
    
    //MARK: - EntitiesViewDelegate
    func addEntityInEntitiesView(entitiesView: EntitiesView) {
        let entity = self.model.createEntity()
        self.selectedEntity = entity
//        self.invalidateViews()
    }
    
    func entitiesView(entitiesView: EntitiesView, removeEntityAtIndex index: Int) {
        let entity = self.model.entities[index]
        let isSelectedEntity = entity === self.selectedEntity
        self.model.removeEntity(model.entities[index])
//        self.invalidateViews()
        
        if isSelectedEntity {
            if self.model.entities.count == 0 {
                self.selectedEntity = nil
            } else if index < self.model.entities.count {
                self.selectedEntity = self.model.entities[index]
            } else {
                self.selectedEntity = self.model.entities[self.model.entities.count - 1]
            }
        }
    }
    
    func entitiesView(entitiesView: EntitiesView, selectedIndexDidChange index: Int?) {
        if let index = index {
            self.selectedEntity = self.model.entities[index]
        } else {
            self.selectedEntity = nil
        }
    }
    
    func entitiesView(entitiesView: EntitiesView, shouldChangeEntityName name: String, atIndex index: Int) -> Bool {
        let entity = model.entities[index]
        do {
            try entity.setName(name)
        } catch {
            Tools.popupAllert("Error", buttonTitile: "OK", informativeText: "Unable to rename entity: \(entity.name) to: \(name). There is an entity with the same name.")
            return false
        }
        return true
    }
}