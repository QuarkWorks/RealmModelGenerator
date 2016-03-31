//
//  EntitieViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/21/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa


protocol EntitiesViewControllerDelegate {
    func entitySelected(entity: Entity)
}

class EntitiesViewController: NSViewController, EntitiesViewDelegate, EntitiesViewDataSource {
    static let TAG = NSStringFromClass(EntitiesViewController)
    
    @IBOutlet weak var entitiesView: EntitiesView!
    
    private var schema = Schema();
    private var model: Model?
    
    var delegate:EntitiesViewControllerDelegate?
    
    var defaultSchema: Schema?{
        willSet(defaultSchema) {
            schema = defaultSchema!;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        entitiesView.delegate = self
        entitiesView.dataSource = self
        
        if let currentModel = schema.getCurrentModel() {
            model = currentModel
        } else {
            model = schema.createModel()
        }
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
    }
    
    func entitiesView(entitiesView:EntitiesView, selectionChange index:Int) {
        self.delegate?.entitySelected(model!.entities[index])
    }
    
    func entitiesView(entitiesView: EntitiesView, titleDidChangeForEntityAtIndex index: Int, newTitle: String) {
        print(EntitiesViewController.TAG)
        do {
            try model!.entities[index].setName(newTitle)
            print(model!.entities[index].name)
            self.delegate?.entitySelected(model!.entities[index])
        } catch {
            print("Error in resetting entity name.")
            
            entitiesView.tableView.reloadData()
            
            let alert = NSAlert()
            alert.messageText = "Error"
            alert.addButtonWithTitle("OK")
            alert.informativeText = "There is an entity with the same name."
            alert.runModal()
        }
    }
}