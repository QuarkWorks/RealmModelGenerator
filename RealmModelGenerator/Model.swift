//
//  Schema.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/2/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation


class Model {
    
    private(set) var version:Int = 0
    private(set) var entities:[Entity] = []
    
    init () {
        
    }
    
    func newEntity(name:String) -> Entity {
        var entityName = name
        var count = 0;
        while !entities.contains({$0.name == entityName}) {
            count++
            entityName = "\(name)\(count)"
        }
        
        let entity = Entity(name: entityName)
        addEntity(entity)
        return entity
    }
    
    func addEntity(entity:Entity) {
        entities.append(entity)
        entity.model = self
    }
    
    func removeEntity(entity:Entity) {
        if let index = entities.indexOf({$0 === entity}) {
            entities.removeAtIndex(index)
            entity.model = nil;
        }
    }
}