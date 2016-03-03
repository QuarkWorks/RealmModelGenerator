//
//  Relationship.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/2/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation

class Relationship {
    var name:String
    var entity:Entity
    var destination:Entity?
    var isMany = false
    
    internal init(name:String, entity:Entity) {
        self.name = name
        self.entity = entity
    }
}