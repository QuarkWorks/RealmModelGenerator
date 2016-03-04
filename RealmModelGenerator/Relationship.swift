//
//  Relationship.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/2/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation

class Relationship {
    static let TAG = NSStringFromClass(Relationship)
    
    static let NAME = "name"
    static let DESTINATION = "DESTINATION"
    static let IS_MANY = "isMany"
    
    private(set) var name:String
    let entity:Entity
    var destination:Entity?
    var isMany = false
    
    internal init(name:String, entity:Entity) {
        self.name = name
        self.entity = entity
    }
    
    func setName(name:String) throws {
        if self.entity.relationships.filter({$0.name == name && $0 !== self}).count > 0 {
            throw NSError(domain: Relationship.TAG, code: 0, userInfo: nil)
        }
    }
    
    init(dictionary:Dictionary<String,Any>, entity:Entity) throws {
        self.name = ""
        self.entity = entity
        guard let name = dictionary["name"] as? String else {
            throw NSError(domain: Relationship.TAG, code: 0, userInfo: nil)
        }
        self.name = name
        
        if let isMany = dictionary["isMany"] as? Bool {
            self.isMany = isMany
        }
        
        if let destinationName = dictionary["destination"] as? String,
            destination = self.entity.model.entitiesByName[destinationName] {
            self.destination = destination
        }
    }
    
    func toDictionary() -> Dictionary<String,Any> {
        let destinationName:Any = (self.destination != nil ? self.destination!.name : NSNull())
        return [
            Relationship.NAME:self.name,
            Relationship.DESTINATION:destinationName,
            Relationship.IS_MANY:self.isMany
        ]
    }
}