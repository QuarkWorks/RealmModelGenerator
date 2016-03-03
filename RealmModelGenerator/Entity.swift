//
//  Entity.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/2/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation

class Entity {
    var model:Model? = nil
    
    var name:String
    var superEntity: Entity? = nil
    
    private(set) var attributes:[Attribute] = []
    private(set) var relationships:[Relationship] = []
    
    init(name:String) {
        self.name = name
    }
}