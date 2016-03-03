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
    
    var name:String
    var superEntity: Entity? = nil
    var isBaseClass = false;

    private(set) var primaryKey:Attribute?
    
    private(set) var attributes:Array<Attribute> = []
    private(set) var relationships:Array<Relationship> = []
    
    internal init(name:String, model:Model) {
        self.name = name
        self.model = model
    }
    
    func createAttribute(build:(Attribute)->Void = {_ in}) -> Attribute {
        var name = "Attribute"
        var count = 0
        while attributes.contains({$0.name == name}) {
            count++
            name = "\(name)\(count)"
        }
        
        let attribute = Attribute(name:name, entity:self)
        attributes.append(attribute)
        build(attribute)
        return attribute;
    }
    
    func setPrimaryKey(primaryKey:Attribute?) throws {
        if primaryKey != nil && !primaryKey!.type.canBePrimaryKey() {
            throw NSError(domain: Entity.TAG, code: 0, userInfo:nil)
        }
        self.primaryKey = primaryKey
        try! self.primaryKey?.setIndexed(true)
    }
    
    func removeAttribute(attribute:Attribute) {
        if let index = attributes.indexOf({$0 === attribute}) {
            attributes.removeAtIndex(index)
        }
    }
    
    func createRelationship(build:(Relationship)->Void = {_ in}) -> Relationship {
        var name = "Relationship"
        var count = 0
        while relationships.contains({$0.name == name}) {
            count++
            name = "Relationship\(count)"
        }
        
        let relationship = Relationship(name: name, entity: self)
        relationships.append(relationship)
        return relationship
    }
    
    func removeRelationship(relationship:Relationship) {
        if let index = relationships.indexOf({$0 === relationship}) {
            relationships.removeAtIndex(index)
        }
    }
}