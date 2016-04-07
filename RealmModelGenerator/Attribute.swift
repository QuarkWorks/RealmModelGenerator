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
    internal(set) weak var entity:Entity!
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
    
    let observable:Observable
    
    internal init(name:String, entity:Entity) {
        self.name = name
        self.entity = entity
        self.observable = DeferedObservable(observable: entity.observable)
    }
    
    func setName(name:String) throws {
        if name.isEmpty {
            throw NSError(domain: Attribute.TAG, code: 0, userInfo: nil)
        }
        
        if self.entity.attributes.filter({$0.name == name && $0 !== self}).count > 0 {
            throw NSError(domain: Attribute.TAG, code: 0, userInfo: nil)
        }
        
        self.name = name
        self.observable.notifyObservers()
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
    
    func removeFromEntity() {
        self.entity.removeAttribute(self)
    }
    
    func isDeleted() -> Bool {
        return self.entity == nil
    }
}