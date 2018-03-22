//
//  EntityDetailVC.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/28/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

class EntityDetailVC : NSViewController, EntityDetailViewDelegate, Observer {
    static let TAG = NSStringFromClass(EntityDetailVC.self)
    
    @IBOutlet weak var entityDetailView: EntityDetailView! {
        didSet { entityDetailView.delegate = self }
    }
    
    weak var entity:Entity? {
        didSet{
            if oldValue === self.entity { return }
            oldValue?.observable.removeObserver(observer: self)
            self.entity?.observable.addObserver(observer: self)
            self.invalidateViews()
        }
    }
    
    var entityNameList:[String] = ["None"]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func invalidateViews() {
        if !self.isViewLoaded || entity == nil { return }
        entityDetailView.name = entity!.name
        entityNameList = ["None"]
        self.entity?.model.entities.forEach{ (e) in entityNameList.append(e.name) }
        entityNameList.remove(at: entityNameList.index(of: self.entity!.name)!)
        entityDetailView.superClassNames = entityNameList
        if let superEntity = self.entity?.superEntity {
            entityDetailView.selectedItemIndex = entityNameList.index(of: superEntity.name)!
        }
    }
    
    // MARK: - Observer
    func onChange(observable: Observable) {
        self.invalidateViews()
    }
    
    // MARK: - EntityDetailView delegate
    func entityDetailView(entityDetailView: EntityDetailView, shouldChangeEntityName name: String) -> Bool {
        do {
            try self.entity!.setName(name: name)
        } catch {
            Tools.popupAlert(messageText: "Error", buttonTitle: "OK", informativeText: "Unable to rename entity: \(entity!.name) to: \(name). There is an entity with the same name.")
            return false
            
        }
        return true
    }
    
    func entityDetailView(entityDetailView: EntityDetailView, selectedSuperClassDidChange superEntity: String) {
        self.entity?.superEntity = self.entity?.model.entities.filter({$0.name == superEntity}).first
    }
}
