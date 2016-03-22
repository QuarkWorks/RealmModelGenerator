//
//  EntitieViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/21/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa


class EntitiesViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    static let TAG = NSStringFromClass(EntitiesViewController)
    
    @IBOutlet weak var entitiesView: EntitiesView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let schema = Schema(name: "")
        let model = Model(version: "model", schema: schema)
        let entity = Entity(name: "abc", model: model)
        let entities = [entity, entity]
        entitiesView.setEntities(entities)
        
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        print("haha")
    }
    
    func tableView(tableView: EntitiesView, numberOfRowsInSection section: Int) -> Int {
        print("oh")
        return 0
    }
}