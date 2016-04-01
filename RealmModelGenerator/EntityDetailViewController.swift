//
//  EntityDetailViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/28/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

@objc protocol EntityDetailViewControllerDelegate {
    optional func entityDetailDidChange(entityDetailViewController:EntityDetailViewController)
}

class EntityDetailViewController : NSViewController, EntityDetailViewDelegate {
    static let TAG = NSStringFromClass(EntityDetailViewController)
    
    @IBOutlet weak var entityDetailView: EntityDetailView!
    weak var delegate:EntityDetailViewControllerDelegate?

    var entity: Entity?
    var defaultEntity: Entity? {
        willSet(defaultEntity) {
            entity = defaultEntity
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entityDetailView.delegate = self
    }
    
    override func viewWillAppear() {
        if entity != nil {
            entityDetailView.name = entity!.name
            //TODO: Complete super class
        }
    }
    
    //MARK - EntityDetailView delegate
    func entityDetailView(entityDetailView: EntityDetailView, shouldChangeEntityName name: String) -> Bool {
        do {
            try self.entity!.setName(name)
            self.delegate?.entityDetailDidChange?(self)
        } catch {
            let alert = NSAlert()
            alert.messageText = "Error"
            alert.addButtonWithTitle("OK")
            alert.informativeText = "Unable to rename entity: \(entity!.name) to: \(name). There is an entity with the same name."
            alert.runModal()
            return false
            
        }
        return true
    }
}
