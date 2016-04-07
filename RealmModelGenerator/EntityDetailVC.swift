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
            self.view.hidden = entity == nil
            if oldValue === self.entity { return }
            self.entity?.observable.addObserver(self)
            self.invalidateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func invalidateViews() {
        if !self.viewLoaded || entity == nil { return }
        entityDetailView.name = entity!.name
        //TODO: Add super class
    }
    
    //MARK: Observer
    func onChange(observable: Observable) {
        self.invalidateViews()
    }
    
    //MARK - EntityDetailView delegate
    func entityDetailView(entityDetailView: EntityDetailView, shouldChangeEntityName name: String) -> Bool {
        do {
            try self.entity!.setName(name)
        } catch {
            Tools.popupAllert("Error", buttonTitile: "OK", informativeText: "Unable to rename entity: \(entity!.name) to: \(name). There is an entity with the same name.")
            return false
            
        }
        return true
    }
}
