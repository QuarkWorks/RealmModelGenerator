//
//  Schema.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/3/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation

class Schema {
    static let TAG = NSStringFromClass(Schema.self)
    
    var name:String
    private(set) var models:[Model] = []
    
    let observable:Observable
    
    init(name:String = "") {
        self.name = name
        self.observable = BaseObservable()
    }
    
    func createModel() -> Model {
        return createModel(build: {_ in});
    }
    
    func createModel( build: (Model) throws -> Void) rethrows -> Model {
        var version = 1
        while self.models.contains(where: {$0.version == "\(version)"}) {
            version += 1
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
        let currentModelDict = currentModel.toDictionary()
        
        self.models.forEach({$0.isModifiable = false})
        
        let model = createModel()
        try model.map(dictionary: currentModelDict, increaseVersion: true)
        
        return model
    }
    
    var currentModel:Model {
        return self.models.filter({return $0.isModifiable}).first ?? createModel()
    }
}
