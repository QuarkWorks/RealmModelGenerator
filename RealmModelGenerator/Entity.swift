//
//  Entity.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/2/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation

class Entity {
    static let TAG = NSStringFromClass(Entity)
    let model:Model
    
    private(set) var name:String
    var superEntity: Entity? = nil
    var isBaseClass = false;

    private(set) var primaryKey:Attribute?
    
    private(set) var attributes:[Attribute] = []
    var attributesByName:[String:Attribute] {
        get {
            var attributesByName = [String:Attribute](minimumCapacity:self.attributes.count)
            for attribute in self.attributes {
                attributesByName[attribute.name] = attribute
            }
            return attributesByName
        }
    }
    
    private(set) var relationships:[Relationship] = []
    var relationshipsByName:[String:Relationship] {
        get {
            var relationshipsByName = Dictionary<String, Relationship>(minimumCapacity:self.relationships.count)
            for relationship in self.relationships {
                relationshipsByName[relationship.name] = relationship
            }
            return relationshipsByName
        }
    }
    
    internal init(name:String, model:Model) {
        self.name = name
        self.model = model
    }
    
    func createAttribute() -> Attribute {
        return createAttribute({_ in})
    }
    
    func createAttribute(@noescape build:(Attribute) throws -> Void) rethrows -> Attribute {
        var name = "Attribute"
        var count = 0
        while attributes.contains({$0.name == name}) {
            count++
            name = "\(name)\(count)"
        }
        
        let attribute = Attribute(name:name, entity:self)
        try build(attribute) //the attribute is added to self.attributes after it build successfully
        attributes.append(attribute)
        return attribute;
    }
    
    func setName(name:String) throws {
        if name.isEmpty {
            throw NSError(domain: Attribute.TAG, code: 0, userInfo: nil)
        }
        
        if model.entities.filter({$0.name == name && $0 !== self}).count > 0 {
            throw NSError(domain: Entity.TAG, code: 0, userInfo: nil)
        }
        
        self.name = name
    }
    
    func setPrimaryKey(primaryKey:Attribute?) throws {
        if primaryKey != nil {
            if !primaryKey!.type.canBePrimaryKey() || primaryKey!.entity !== self {
                throw NSError(domain: Entity.TAG, code: 0, userInfo:nil)
            }
        }
        
        self.primaryKey = primaryKey
        try! self.primaryKey?.setIndexed(true)
    }
    
    func removeAttribute(attribute:Attribute) {
        if let index = attributes.indexOf({$0 === attribute}) {
            attributes.removeAtIndex(index)
        }
    }
    
    func createRelationship() -> Relationship {
        return createRelationship({_ in})
    }
    
    func createRelationship(@noescape build:(Relationship) throws -> Void) rethrows -> Relationship {
        var name = "Relationship"
        var count = 0
        
        while relationships.contains({$0.name == name}) {
            count++
            name = "Relationship\(count)"
        }
        
        let relationship = Relationship(name: name, entity: self)
        relationships.append(relationship)
        try build(relationship) //the relationship is added to selfrelationships after it build successfully
        return relationship
    }
    
    func removeRelationship(relationship:Relationship) {
        if let index = relationships.indexOf({$0 === relationship}) {
            relationships.removeAtIndex(index)
        }
    }
    
    func removeFromModel() {
        self.model.removeEntity(self)
    }
}