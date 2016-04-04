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

class EntityDetailVC : NSViewController, EntityDetailViewDelegate {
    static let TAG = NSStringFromClass(EntityDetailVC)
    
    @IBOutlet weak var entityDetailView: EntityDetailView! {
        didSet { entityDetailView.delegate = self }
    }
    
    weak var entity: Entity? {
        didSet{
            entityDetailView.name = entity!.name
        }
    }
    weak var delegate:EntityDetailVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            self.delegate?.entityDetailVC(self, detailDidChangeFor: self.entity!)
        } catch {
            Tools.popupAllert("Error", buttonTitile: "OK", informativeText: "Unable to rename entity: \(entity!.name) to: \(name). There is an entity with the same name.")
            return false
            
        }
        return true
    }
}
