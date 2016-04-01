//
//  EntitieViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/21/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

@objc protocol EntitiesViewControllerDelegate {
    optional func entiesViewController(entitiesViewController:EntitiesViewController, selectionChange index: Int)
}

class EntitiesViewController: NSViewController, EntitiesViewDelegate, EntitiesViewDataSource {
    static let TAG = NSStringFromClass(EntitiesViewController)
    
    static let SELECTED_NONE_INDEX = -1;
    
    @IBOutlet weak var entitiesView: EntitiesView!
    weak var delegate:EntitiesViewControllerDelegate?
    
    private var model: Model?
    var defaultModel: Model? {
        willSet(defaultModel) {
            model = defaultModel
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        entitiesView.delegate = self
        entitiesView.dataSource = self
    }
    
    override func viewWillAppear() {
        entitiesView.reloadData()
    }

    //MARK: - EntitiesViewDataSource
    func numberOfRowsInEntitiesView(entitiesView: EntitiesView) -> Int {
        return model!.entities.count
    }
    
    func entitiesView(entitiesView:EntitiesView, titleForEntityAtIndex index:Int) -> String? {
        return model!.entities[index].name
    }
    
    //MARK: - EntitiesViewDelegate
    func addEntityInEntitiesView(entitiesView: EntitiesView) {
        model!.createEntity()
    }
    
    func entitiesView(entitiesView: EntitiesView, removeEntityAtIndex index: Int) {
        model!.removeEntity(model!.entities[index])
        self.delegate?.entiesViewController?(self, selectionChange: EntitiesViewController.SELECTED_NONE_INDEX)
    }
    
    func entitiesView(entitiesView:EntitiesView, selectionChange index:Int) {
        self.delegate?.entiesViewController?(self, selectionChange: index)
    }
    
    func entitiesView(entitiesView: EntitiesView, shouldChangeEntityName name: String, atIndex index: Int) -> Bool {
        let entity = model!.entities[index]
        do {
            try entity.setName(name)
            self.delegate?.entiesViewController?(self, selectionChange: index)
        } catch {
            let alert = NSAlert()
            alert.messageText = "Error"
            alert.addButtonWithTitle("OK")
            alert.informativeText = "Unable to rename entity: \(entity.name) to: \(name). There is an entity with the same name."
            alert.runModal()
            return false
        }
        return true
    }
}