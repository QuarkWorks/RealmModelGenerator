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
        model.createEntity { (entity) -> Void in
            entity.name = "User"
            let pk = entity.createAttribute({ (attribute) -> Void in
                attribute.name = "id"
                attribute.type = AttributeType.String
            })
            try! entity.setPrimaryKey(pk)
        }
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

