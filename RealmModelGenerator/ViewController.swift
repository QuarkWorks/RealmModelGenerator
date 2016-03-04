//
//  ViewController.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/2/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    enum Language: String {
        case Swift, Objc, Java
    }

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
        
        user.createRelationship({
            $0.name = "children"
            $0.destination = child
        })
        
        for entity in model.entities {
            generateFile(entity, language: .Java)
        }
    }
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    //ZHAO, Make new swift files. seperate it out :) do ya thing
    func generateFile(entity:Entity, language:Language) -> String {
        switch language {
        case .Swift:
            return language.rawValue
        case .Objc:
            return language.rawValue
        case .Java:
            return language.rawValue
        }
    }
}

