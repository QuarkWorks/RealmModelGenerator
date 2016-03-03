//
//  Relationship.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/2/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation

class Relationship {
    var name: String
    var entity: Entity?
    var isMany = false
    
    init(name:String) {
        self.name = name
    }
}