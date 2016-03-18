//
//  Document.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/14/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

class RealmSchemaDocument: NSDocument {
    static let TAG = String(RealmSchemaDocument)
    
    var vc: ViewController!
    var schema = Schema()
    
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }
    
    override func windowControllerDidLoadNib(aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        // Add any code here that needs to be executed once the windowController has loaded the document's window.
    }
    
    override class func autosavesInPlace() -> Bool {
        return true
    }
    
    override func makeWindowControllers() {
        
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateControllerWithIdentifier("Document Window Controller") as! NSWindowController
        
        if let v = windowController.contentViewController as? ViewController {
            vc = v
            
            if schema.models.count == 0 {
                schema.createModel()
            }
            
            vc.schema = schema
        }
        
        self.addWindowController(windowController)
    }
    
    override func dataOfType(typeName: String) throws -> NSData {
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
        
        var arrayOfDictionaries = [NSDictionary]()
        
        let schemaDict = vc.schema.toDictionary()
        arrayOfDictionaries.append(schemaDict)
    
        let data: NSData? = try NSJSONSerialization.dataWithJSONObject(arrayOfDictionaries, options: [])
        
        if let value = data {
            return value
        }
        
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }
    
    override func readFromData(data: NSData, ofType typeName: String) throws {
        // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
        // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
        // If you override either of these, you should also override -isEntireFileLoaded to return false if the contents are lazily loaded.
        
        do {
            try parseSchemaJson(data)
        } catch GeneratorError.InvalidFileContent(let errorMsg) {
            print("Invalid JSON format: \(errorMsg)")
        }
        
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }
    
    func parseSchemaJson(data: NSData) throws {
        if let arrayOfDictionaries = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as? [NSDictionary]{
            
            guard let dictionary = arrayOfDictionaries.first else {
                throw GeneratorError.InvalidFileContent(errorMsg: RealmSchemaDocument.TAG + ": No schema in this file")
            }
            
            guard let schemaName = dictionary[Schema.SCHEMA] as? String else {
                throw GeneratorError.InvalidFileContent(errorMsg: RealmSchemaDocument.TAG + ": Invalid schema name")
            }
            
            schema = Schema(name: schemaName)
            
            guard let models = dictionary[Schema.MODELS] as? [NSDictionary] else {
                throw GeneratorError.InvalidFileContent(errorMsg: RealmSchemaDocument.TAG + ": Invalid models")
            }
            
            for modelDict in models {
                
                guard let version = modelDict[Model.VERSION] as? String else {
                    throw GeneratorError.InvalidFileContent(errorMsg: RealmSchemaDocument.TAG + ": Invalid model version")
                }
                
                let model = Model(version: version)
                
                guard let entities = modelDict[Model.ENTITIES] as? [NSDictionary] else {
                    throw GeneratorError.InvalidFileContent(errorMsg: RealmSchemaDocument.TAG + ": Invalid entities")
                }
                
                for entityDict in entities {
                    guard let entityObject = entityDict as? [String:AnyObject] else {
                        throw GeneratorError.InvalidFileContent(errorMsg: RealmSchemaDocument.TAG + ": Invalid entity JSON")
                    }
                    
                    _ = try! Entity.init(dictionary: entityObject, model: model)
                }
                
                model.canBeModified = modelDict[Model.CAN_BE_MODIFIED] as! Bool
                schema.appendModel(model)
            }
            
            return
        }
    }
}