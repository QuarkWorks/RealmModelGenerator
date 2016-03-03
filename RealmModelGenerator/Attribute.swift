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
    var entity:Entity?
    var isIgnored = false
    var isIndexd = false
    var isRequired = false
    var isPrimaryKey = false {
        didSet {
            if isPrimaryKey {
                self.isIgnored = false;
                self.isIndexd = true;
                self.isRequired = true;
            }
        }
    }
    var hasDefault = false
    var defautValue = ""
    
    var type = AttributeType.Unknown
    
    init(name:String) {
        self.name = name
    }
}
