//
//  Schema.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/3/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation

class Schema {
    static let TAG = NSStringFromClass(Schema)
    
    var name:String
    private(set) var models:[Model] = []
    
    init(name:String = "") {
        self.name = name
    }
    
    func createModel() -> Model {
        return createModel({_ in});
    }
    
    func createModel(@noescape build:(Model) throws -> Void) rethrows -> Model {
        var version = 1
        while self.models.contains({$0.version == "\(version)"}) {
            version++
        }
        
        if let currentModel = getCurrentModel() {
            currentModel.setCanBeModified(false)
        }
        
        let model = Model(version: "\(version)", schema:self)
        try build(model)
        models.append(model)
        
        return model
    }
    
    func setName(name:String) {
        self.name = name
    }
    
    func increaseVersion() throws -> Model {
        if let currentModel = getCurrentModel() {
            let currentModelDict = currentModel.toDictionary()
            
            let model = createModel()
            try model.map(currentModelDict, increaseVersion: true)
            
            return model
        } else {
            return createModel()
        }
    }
    
    func getCurrentModel() -> Model? {
        for model in models {
            if model.canBeModified {
                return model
            }
        }
        
        return nil
    }
}