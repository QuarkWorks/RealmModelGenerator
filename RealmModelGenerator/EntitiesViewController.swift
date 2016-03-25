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
        //TODO: notify attribute, relationship, and entity detail data source change
    }
}