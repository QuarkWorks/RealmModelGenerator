//
//  Attribute.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/2/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation

class Attribute {
    static let TAG = NSStringFromClass(Attribute)
    
    static let NAME = "name"
    static let IS_IGNORED = "isIgnored"
    static let IS_INDEXED = "isIndexed"
    static let IS_REQUIRED = "isRequired"
    static let HAS_DEFALUT = "hasDefault"
    static let DEFAULT_VALUE = "defaultValue"
    static let TYPE = "type"
    
    private(set) var name:String
    let entity:Entity
    var isIgnored = false
    private(set) var isIndexd = false
    var isRequired = false
    var hasDefault = false
    var defaultValue = ""
    
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
    
    func setName(name:String) throws {
        if self.entity.attributes.filter({$0.name == name && $0 !== self}).count > 0 {
            throw NSError(domain: Attribute.TAG, code: 0, userInfo: nil)
        }
        
        self.name = name
    }
    
    func setIndexed(isIndexed:Bool) throws {
        if !type.canBeIndexed() {
            NSException(name: "IllegalState", reason: "Attribute Can't Be Indexed For Current Type", userInfo: nil).raise()
        }
        self.isIndexd = isIndexed
    }
    
    init(dictionary:Dictionary<String,Any>, entity:Entity) throws {
        self.name = ""
        self.entity = entity
        
        guard let name = dictionary["name"] as? String else {
            throw NSError(domain:Attribute.TAG, code: 0, userInfo: nil)
        }
        self.name = name
        
        if let rawType = dictionary["type"] as? String {
            self.type = AttributeType(rawValueSafe: rawType)
        }
        
        if let isIgnored = dictionary["isIgnored"] as? Bool {
            self.isIgnored = isIgnored
        }
        
        if let isIndexed = dictionary["isIndexed"] as? Bool {
            do {
                try self.setIndexed(isIndexed)
            } catch {
                self.isIndexd = false
            }
        }
        
        if let isRequired = dictionary["isRequired"] as? Bool {
            self.isRequired = isRequired
        }
        
        if let hasDefault = dictionary["hasDefault"] as? Bool {
            self.hasDefault = hasDefault
        }
        
        if let defaultValue = dictionary["defaultValue"] as? String {
            self.defaultValue = defaultValue
        }
        
    }
    
    func toDictionary() -> Dictionary<String,Any> {
        return [
            Attribute.NAME:name,
            Attribute.IS_IGNORED:isIgnored,
            Attribute.IS_INDEXED:isIndexd,
            Attribute.IS_REQUIRED:isRequired,
            Attribute.HAS_DEFALUT:hasDefault,
            Attribute.DEFAULT_VALUE:defaultValue,
            Attribute.TYPE:type.rawValue
        ]
    }
}
