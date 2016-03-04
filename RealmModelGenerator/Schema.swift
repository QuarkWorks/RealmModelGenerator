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
    private(set) var models:Array<Model> = []
    
    init(name:String) {
        self.name = name
    }
    
    func createModel(build:(Model)->Void = {_ in}) -> Model {
        let model = Model(version: "\(models.count+1)")
        models.append(model)
        return model
    }
}