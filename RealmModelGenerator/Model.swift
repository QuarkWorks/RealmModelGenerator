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
    
    weak var schema:Schema!
    private(set) var version:String
    internal(set) var isModifiable:Bool = true
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
    
    let observable:Observable
    
    internal init(version:String, schema: Schema) {
        self.version = version
        self.schema = schema
        self.observable = DeferedObservable(observable: schema.observable)
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
        entity.model = nil
        entities.forEach{ (e) in
            e.relationships.forEach({ (r) in
                if r.destination === entity {
                    r.destination = nil
                }
            })
            
            if e.superEntity === entity {
                e.superEntity = nil
            }
            
        }
        
        if let index = entities.indexOf({$0 === entity}) {
            entities.removeAtIndex(index)
        }
        
        self.observable.notifyObservers()
    }
    
    func setVersion(version:String) {
        self.version = version;
    }
    
    func isDeleted() -> Bool {
        return self.schema == nil
    }
}
