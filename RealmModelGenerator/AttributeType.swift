//
//  AttributeType.swift
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
        return self == AttributeType.Short || self == AttributeType.Int || self == AttributeType.Long || self == AttributeType.String
    }
    
    func canBeIndexed() -> Swift.Bool {
        return self == AttributeType.Bool || canBePrimaryKey() || self == AttributeType.Date
    }
    
    init(rawValueSafe:Swift.String) {
        self = .Unknown
        if let type = AttributeType.init(rawValue: rawValueSafe) {
            self = type
        }
    }
}
