//
//  Schema.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/2/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation


class Model {
    
    let version:String
    private(set) var entities:Array<Entity> = []
    
    init(version:String) {
        self.version = version
    }
    
    func createEntity(build:(Entity)->Void = {_ in}) -> Entity {
        var name = "Entity"
        var count = 0;
        while entities.contains({$0.name == name}) {
            count++
            name = "Entity\(count)"
        }
        
        let entity = Entity(name:name, model:self)
        entities.append(entity)
        build(entity)
        return entity
    }
    
    func removeEntity(entity:Entity) {
        if let index = entities.indexOf({$0 === entity}) {
            entities.removeAtIndex(index)
        }
    }
}