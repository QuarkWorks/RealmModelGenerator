//
//  Relationship.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/2/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation

class Relationship {
    static let TAG = NSStringFromClass(Relationship.self)
    
    private(set) var name:String
    internal(set) weak var entity:Entity!
    weak var destination:Entity? {
        didSet { self.observable.notifyObservers() }
    }
    var isMany = false {
        didSet { self.observable.notifyObservers() }
    }
    
    let observable: Observable
    internal init(name:String, entity:Entity) {
        self.name = name
        self.entity = entity
        self.observable = DeferredObservable(observable: entity.observable)
    }
    
    func setName(name:String) throws {
        if name.isEmpty {
            throw NSError(domain: Attribute.TAG, code: 0, userInfo: nil)
        }
        
        if self.entity.relationships.filter({$0.name == name && $0 !== self}).count > 0 {
            throw NSError(domain: Relationship.TAG, code: 0, userInfo: nil)
        }
        self.name = name
        self.observable.notifyObservers()
    }
    
    func removeFromEntity() {
        self.entity.removeRelationship(relationship: self)
    }
    
    func isDeleted() -> Bool {
        return self.entity == nil
    }
}
