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
            version += 1
        }
        
        self.models.forEach({$0.setCanBeModified(false)})
        
        let model = Model(version: "\(version)", schema:self)
        try build(model)
        models.append(model)
        
        return model
    }
    
    func setName(name:String) {
        self.name = name
    }
    
    func increaseVersion() throws -> Model {
        let currentModelDict = currentModel.toDictionary()
        
        let model = createModel()
        try model.map(currentModelDict, increaseVersion: true)
        
        return model
    }
    
    var currentModel:Model {
        return self.models.filter({return $0.canBeModified}).first ?? createModel()
    }
}