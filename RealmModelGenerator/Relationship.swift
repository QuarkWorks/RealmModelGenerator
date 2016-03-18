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
    
    private(set) var name:String
    let entity:Entity
    var destination:Entity?
    var isMany = false
    
    internal init(name:String, entity:Entity) {
        self.name = name
        self.entity = entity
    }
    
    func setName(name:String) throws {
        if name.isEmpty {
            throw NSError(domain: Attribute.TAG, code: 0, userInfo: nil)
        }
        
        if self.entity.relationships.filter({$0.name == name && $0 !== self}).count > 0 {
            throw NSError(domain: Relationship.TAG, code: 0, userInfo: nil)
        }
        self.name = name
    }    
}