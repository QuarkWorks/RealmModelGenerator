//
//  EntitieViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/21/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa


class EntitiesViewController: NSViewController, EntitiesViewDelegate, EntitiesViewDataSource {
    static let TAG = NSStringFromClass(EntitiesViewController)
    
    @IBOutlet weak var entitiesView: EntitiesView!
    
    private var schema = Schema();
    private var model: Model?
    private var entities:[Entity] = []
    
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
        
        entities = model!.entities
    }
    
    //MARK: EntitiesViewDelegate
    func entitiesView(entitiesView:EntitiesView, titleForEntityAtIndex index:Int) -> String? {
        return entities[index].name
    }
    
    func entitiesView(entitiesView:EntitiesView, didRemoveEntityAtIndex index:Int?) {
        //TODO: notify attribute, relationship, and entity detail data source change
    }
    
    func numberOfRowsInEntitiesView(entitiesView: EntitiesView) -> Int {
        return entities.count
        
    }
    
    func addEntityInEntitiesView(entitiesView: EntitiesView) {
        entities.append(model!.createEntity())
    }
    
    func removeEntityInEntitiesView(entitiesView: EntitiesView, index:Int?) {
        if let selectedIndex = index {
            if (selectedIndex >= 0 && selectedIndex < entities.count) {
                model!.removeEntity(entities[selectedIndex])
                entities.removeAtIndex(selectedIndex)
            }
        }
    }
}