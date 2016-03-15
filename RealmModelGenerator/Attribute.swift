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
        
    private(set) var name:String
    let entity:Entity
    var isIgnored = false
    private(set) var isIndexed = false
    var isRequired = false
    var hasDefault = false
    var defaultValue = ""
    
    var type = AttributeType.Unknown {
        willSet {
            if !newValue.canBeIndexed() {
                isIndexed = false
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
        if name.isEmpty {
            throw NSError(domain: Attribute.TAG, code: 0, userInfo: nil)
        }
        
        if self.entity.attributes.filter({$0.name == name && $0 !== self}).count > 0 {
            throw NSError(domain: Attribute.TAG, code: 0, userInfo: nil)
        }
        
        self.name = name
    }
    
    func setIndexed(isIndexed:Bool) throws {
        if isIndexed && !type.canBeIndexed() {
            throw NSError(domain: Attribute.TAG, code: 0, userInfo: nil);
        }
        self.isIndexed = isIndexed
    }
    
    func removeIndexed() {
        try! self.setIndexed(false)
    }
    
    init(dictionary:Dictionary<String,AnyObject>, entity:Entity) throws {
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
                self.isIndexed = false
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
    
    func removeFromEntity() {
        self.entity.removeAttribute(self)
    }
    
    func toDictionary() -> Dictionary<String,AnyObject> {
        return [
            Attribute.NAME:name,
            Attribute.IS_IGNORED:isIgnored,
            Attribute.IS_INDEXED:isIndexed,
            Attribute.IS_REQUIRED:isRequired,
            Attribute.HAS_DEFALUT:hasDefault,
            Attribute.DEFAULT_VALUE:defaultValue,
            Attribute.TYPE:type.rawValue
        ]
    }
}
