//
//  EntityDetailViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/28/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

class EntityDetailVC : NSViewController, EntityDetailViewDelegate, Observer {
    static let TAG = NSStringFromClass(EntityDetailVC)
    
    @IBOutlet weak var entityDetailView: EntityDetailView! {
        didSet { entityDetailView.delegate = self }
    }
    
    weak var entity:Entity? {
        didSet{
            if oldValue === self.entity { return }
            oldValue?.observable.removeObserver(self)
            self.entity?.observable.addObserver(self)
            self.invalidateViews()
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func invalidateViews() {
        if !self.viewLoaded || entity == nil { return }
        entityDetailView.name = entity!.name
        var entityNameList:[String] = ["None"]
        self.entity?.model.entities.forEach{ (e) in entityNameList.append(e.name) }
        entityDetailView.superClassNames = entityNameList
    }
    
    //MARK: - Observer
    func onChange(observable: Observable) {
        self.invalidateViews()
    }
    
    //MARK: - EntityDetailView delegate
    func entityDetailView(entityDetailView: EntityDetailView, shouldChangeEntityName name: String) -> Bool {
        do {
            try self.entity!.setName(name)
        } catch {
            Tools.popupAllert("Error", buttonTitile: "OK", informativeText: "Unable to rename entity: \(entity!.name) to: \(name). There is an entity with the same name.")
            return false
            
        }
        return true
    }
    
    func entityDetailView(entityDetailView: EntityDetailView, selectedSuperEnityDidChangeIndex index: Int) {
        if self.entity !== self.entity?.model.entities[index-1] {
            self.entity?.superEntity = self.entity?.model.entities[index]
        } else {
            entityDetailView.selectedItemIndex = 0
        }
    }
}
