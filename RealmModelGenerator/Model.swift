//
//  Schema.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/2/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation

class Model {
    static let TAG = NSStringFromClass(Model)
    
    let schema:Schema
    private(set) var version:String
    private(set) var entities:[Entity] = []
    var entitiesByName:[String:Entity] {
        get {
            var entitiesByName = [String:Entity](minimumCapacity:self.entities.count)
            for entity in self.entities {
                entitiesByName[entity.name] = entity
            }
            return entitiesByName
        }
    }
    
    internal init(version:String, schema: Schema) {
        self.version = version
        self.schema = schema
    }
    
    func createEntity() -> Entity {
        return createEntity({_ in})
    }
    
    func createEntity(@noescape build:(Entity) throws -> Void) rethrows -> Entity  {
        var name = "Entity"
        var count = 0;
        while entities.contains({$0.name == name}) {
            count++
            name = "Entity\(count)"
        }
        
        let entity = Entity(name:name, model:self)
        try build(entity) //the entity is added to self.entities after it build successfully
        entities.append(entity)
        return entity
    }
    
    func removeEntity(entity:Entity) {
        if let index = entities.indexOf({$0 === entity}) {
            entities.removeAtIndex(index)
        }
    }
    
    func setVersion(version:String) throws {
        self.version = version;
    }
    
    func toNSDictionary() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary[Model.VERSION] = self.version
        dictionary[Model.ENTITIES] = self.entities.map({$0.toNSDictionary()})
        
        return dictionary
    }
}