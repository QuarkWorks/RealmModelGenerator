//
//  EntityDetailViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/28/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

protocol EntityDetailVCDelegate: class {
    func entityDetailVC(entityDetailVC:EntityDetailVC, detailDidChangeFor entity:Entity)
}

class EntityDetailVC : NSViewController, EntityDetailViewDelegate, Observer {
    static let TAG = NSStringFromClass(EntityDetailVC)
    
    @IBOutlet weak var entityDetailView: EntityDetailView! {
        didSet { entityDetailView.delegate = self }
    }
    
    var token:ObserverToken? = nil

    weak var entity: Entity? {
        didSet{
            entityDetailView.name = entity!.name
            //TODO: Set super entity
            if self.entity !== oldValue {
//                self.token = self.entity?.observable.addObserveBlockBlock({_ in self.invalidateViews()}
//                oldValue?.observable.removeObserver(self)
                self.entity?.observable.addObserver(self)
            }
        }
    }
    
    weak var delegate:EntityDetailVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func invalidateViews() {
        if !self.viewLoaded { return }
        entityDetailView.name = entity!.name
    }
    
    //MARK: Observer
    func onChange(observable: Observable) {
        self.invalidateViews()
    }
    
    //MARK - EntityDetailView delegate
    func entityDetailView(entityDetailView: EntityDetailView, shouldChangeEntityName name: String) -> Bool {
        do {
            try self.entity!.setName(name)
//            self.delegate?.entityDetailVC(self, detailDidChangeFor: self.entity!)
            self.entity!.model.observable.notifyObservers()
//            self.entity?.observable.notifyObservers()
        } catch {
            Tools.popupAllert("Error", buttonTitile: "OK", informativeText: "Unable to rename entity: \(entity!.name) to: \(name). There is an entity with the same name.")
            return false
            
        }
        return true
    }
}
