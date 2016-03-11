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
    static let VERSION = "version"
    static let ENTITIES = "entities"
    
    private(set) var version:String
    private(set) var entities:Array<Entity> = []
    var entitiesByName:Dictionary<String, Entity> {
        get {
            var entitiesByName = Dictionary<String, Entity>(minimumCapacity:self.entities.count)
            for entity in self.entities {
                entitiesByName[entity.name] = entity
            }
            return entitiesByName
        }
    }
    
    init(version:String) {
        self.version = version
    }
    
    func createEntity(build:(Entity)->Void = {_ in}) -> Entity  {
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
    
    func fromDictionary(dictionary:[String:Any]) throws {
        guard let version = dictionary[Model.VERSION] as? String else {
            throw NSError(domain: Model.TAG, code: 0, userInfo: nil)
        }
        self.version = version;
        
        guard let entityDictionaryArray = dictionary[Model.ENTITIES] as? [[String:Any]] else {
            throw NSError(domain: Model.TAG, code: 0, userInfo: nil)
        }
        
        for entityDictionary in entityDictionaryArray {
            try entities.append(Entity(dictionary: entityDictionary, model: self))
        }
    }
    
    func toDictionary() -> [String:Any] {
        return [
            Model.VERSION:self.version,
            Model.ENTITIES:self.entities.map({$0.toDictionary()})
        ]
    }
}