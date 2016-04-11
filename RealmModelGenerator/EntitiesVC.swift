//
//  EntitieViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/21/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa
//MARK: - EntitiesVCDelegate
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
            if oldValue === self.schema { return }
            oldValue.observable.removeObserver(self)
            self.schema.observable.addObserver(self)
            selectedEntity = nil
        }
    }
    
    var model: Model {
        return self.schema.currentModel
    }
    
    weak var selectedEntity: Entity? {
        didSet {
            if oldValue === self.selectedEntity { return }
            invalidateSelectedIndex()
            self.delegate?.entitiesVC(self, selectedEntityDidChange: self.selectedEntity)
        }
    }
    
    weak var delegate:EntitiesVCDelegate?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.invalidateViews()
    }
    
    //MARK: - Invalidation
    func invalidateViews() {
        if !self.viewLoaded { return }
        self.entitiesView.reloadData()
        invalidateSelectedIndex()
    }
    
    func invalidateSelectedIndex() {
        self.entitiesView.selectedIndex = self.model.entities.indexOf({$0 === self.selectedEntity})
    }
    
    //MARK: - Observer
    func onChange(observable: Observable) {
        self.invalidateViews()
    }

    //MARK: - EntitiesViewDataSource
    func numberOfRowsInEntitiesView(entitiesView: EntitiesView) -> Int {
        return self.model.entities.count
    }
    
    func entitiesView(entitiesView:EntitiesView, titleForEntityAtIndex index:Int) -> String {
        return self.model.entities[index].name
    }
    
    //MARK: - EntitiesViewDelegate
    func addEntityInEntitiesView(entitiesView: EntitiesView) {
        let entity = self.model.createEntity()
        self.selectedEntity = entity
    }
    
    func entitiesView(entitiesView: EntitiesView, removeEntityAtIndex index: Int) {
        let entity = self.model.entities[index]
        if entity === self.selectedEntity {
            if self.model.entities.count <= 1 {
                self.selectedEntity = nil
            } else if index == self.model.entities.count - 1 {
                self.selectedEntity = self.model.entities[index - 1]
            } else {
                self.selectedEntity = self.model.entities[index + 1]
            }
        }
        
        self.model.removeEntity(entity)
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