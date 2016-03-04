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
        let user = model.createEntity({ (entity) -> Void in
            try! entity.setName("User")
            let pk = entity.createAttribute({ (attribute) -> Void in
                try! attribute.setName("id")
                attribute.type = AttributeType.String
            })
            try! entity.setPrimaryKey(pk)
            
            entity.createAttribute({ (attribute) -> Void in
                try! attribute.setName("id2")
                attribute.type = AttributeType.String
                try! attribute.setIndexed(true)
            })
        })
        
        let child = model.createEntity { (entity) -> Void in
            try! entity.setName("Child")
            let pk = entity.createAttribute({
                try! $0.setName("id")
                $0.type = .Long
            })
            
            try! entity.setPrimaryKey(pk)
            
            entity.createAttribute({
                try! $0.setName("childeName")
                $0.defaultValue = "Bob"
                $0.hasDefault = true
            })
        }
        
        user.createRelationship({
            try! $0.setName("children")
            $0.destination = child
        })
        
        for entity in model.entities {
            print(generateFile(entity, language: .Java))
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

