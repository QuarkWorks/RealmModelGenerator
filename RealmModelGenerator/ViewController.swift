//
//  ViewController.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/2/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let model = Model(version: "1")
        let user = model.createEntity { (entity) -> Void in
            entity.name = "User"
            let pk = entity.createAttribute({ (attribute) -> Void in
                attribute.name = "id"
                attribute.type = AttributeType.String
            })
            try! entity.setPrimaryKey(pk)
            
            entity.createAttribute({ (attribute) -> Void in
                attribute.name = "name"
                attribute.type = AttributeType.String
                try! attribute.setIndexed(true)
            })
        }
        
        let child = model.createEntity { (entity) -> Void in
            entity.name = "Child"
            let pk = entity.createAttribute({
                $0.name = "id"
                $0.type = .Long
            })
            
            try! entity.setPrimaryKey(pk)
            
            entity.createAttribute({
                $0.name = "childName"
                $0.defautValue = "Bob"
                $0.hasDefault = true
            })
        }
        
        child.createRelationship({
            $0.name = "Children"
            $0.destination = user
        })
    }
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

