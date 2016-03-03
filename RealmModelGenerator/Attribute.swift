//
//  Attribute.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/2/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation

class Attribute {
    var name:String
    let entity:Entity
    var isIgnored = false
    private(set) var isIndexd = false
    var isRequired = false
    var hasDefault = false
    var defautValue = ""
    
    var type = AttributeType.Unknown {
        willSet {
            if !newValue.canBeIndexed() {
                isIndexd = false
                if entity.primaryKey === self {
                    try! entity.setPrimaryKey(nil)
                }
            }
        }
    }
    
    internal init(name:String, entity:Entity) {
        self.name = name
        self.entity = entity
    }
    
    func setIndexed(isIndexed:Bool) throws {
        if !type.canBeIndexed() {
            NSException(name: "IllegalState", reason: "Attribute Can't Be Indexed For Current Type", userInfo: nil).raise()
        }
        self.isIndexd = isIndexed
    }
}
