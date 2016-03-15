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
    
<<<<<<< 406def12c1cea3819c63122e3d374d0a3d444011
    func removeFromModel() {
        self.model.removeEntity(self)
=======
    init(dictionary:[String:AnyObject], model:Model) throws {
        self.name = ""
        self.model = model
        
        guard let name = dictionary["name"] as? String else {
            throw NSError(domain:Attribute.TAG, code: 0, userInfo: nil)
        }
        
        try self.setName(name)
        
        if let isBaseClass = dictionary["isBaseClass"] as? Bool {
            self.isBaseClass = isBaseClass
        }
        
        guard let attributes = dictionary["attributes"] as? [[String:AnyObject]] else {
            throw NSError(domain:Attribute.TAG, code: 0, userInfo: nil)
        }
        
        let primaryKey = dictionary["primaryKey"] as? String
        for attributeDict in attributes {
            let attribute = try Attribute(dictionary: attributeDict, entity: self)
            self.attributes.append(attribute)
            if primaryKey != nil && attribute.name == primaryKey {
                self.primaryKey = attribute
            }
        }
    }
    
    func setRelationships(dictionary:[String:Any]) throws {
        guard let superEntityName = dictionary["superEntity"] as? String,
            let superEntity = self.model.entitiesByName[superEntityName] else {
            throw NSError(domain: Entity.TAG, code: 0, userInfo: nil)
        }
        
        self.superEntity = superEntity;
        
        if let relationships = dictionary["relationships"] as? [[String:Any]] {
            for relationshipDict in relationships {
                let relationship = try Relationship(dictionary: relationshipDict, entity: self)
                self.relationships.append(relationship)
            }
        }
    }
    
    func toDictionary() -> [String:Any] {
        let superEntity:Any = self.superEntity?.name ?? NSNull()
        let primaryKey:Any = self.primaryKey?.name ?? NSNull()
        
        return [
            "name":name,
            "primaryKey":primaryKey,
            "superEntity":superEntity,
            "isBaseClass":self.isBaseClass,
            "attributes":self.attributes.map({$0.toDictionary()}),
            "relationships":self.relationships.map({$0.toDictionary()})
        ]
>>>>>>> Added a subclass of NSDocument and modified Info.plist to convert to document-based project
    }
    
    func toNSDictionary() -> NSDictionary {
        let superEntity:AnyObject = self.superEntity?.name ?? NSNull()
        let primaryKey:AnyObject = self.primaryKey?.name ?? NSNull()
        
        let dictionary = NSMutableDictionary()
        
        dictionary["name"] = name
        dictionary["primaryKey"] = primaryKey
        dictionary["superEntity"] = superEntity
        dictionary["isBaseClass"] = self.isBaseClass
        dictionary["attributes"] = self.attributes.map({$0.toNSDictionary()})
        dictionary["relationships"] = self.relationships.map({$0.toNSDictionary()})
        
        return dictionary

    }
}