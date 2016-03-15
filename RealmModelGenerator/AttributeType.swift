//
//  Attribute.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/2/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation

enum AttributeType : String {
    case Unknown, Bool, Short, Int, Long, Float, Double, String, Date, Blob
    
    static let values = [Unknown, Bool, Short, Int, Long, Float, Double, String, Date, Blob]
    
    func canBePrimaryKey() -> Swift.Bool {
        return self == Short || self == Int || self == Long || self == String
    }
    
    func canBeIndexed() -> Swift.Bool {
        return self == Bool || canBePrimaryKey() || self == Date
    }
    
    init(rawValueSafe:Swift.String) {
        self = Unknown
        if let type = AttributeType.init(rawValue: rawValueSafe) {
            self = type
        }
    }
}