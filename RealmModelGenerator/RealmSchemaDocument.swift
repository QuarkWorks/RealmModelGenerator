//
//  Document.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/14/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

class RealmSchemaDocument: NSDocument {
    
    var vc: ViewController!
    var models = [Model]()
    
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
            vc.models = models
        }
        
        self.addWindowController(windowController)
    }
    
    override func dataOfType(typeName: String) throws -> NSData {
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
        var arrayOfDictionaries = [NSDictionary]()
        
        for modelObject in vc.models {
            let model = modelObject as Model

            arrayOfDictionaries.append(model.toDictionary())
            arrayOfDictionaries.append(model.toDictionary())
        }
    
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
        
        if let arrayOfDictionaries = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as? [NSDictionary]{
            
            for dictionary: NSDictionary in arrayOfDictionaries{
            
                let model = Model(version: dictionary[Model.VERSION] as! String)
                let entities = dictionary[Model.ENTITIES] as? [NSDictionary]
                for entityDict in entities! {
                    let entityObject = entityDict as! [String:AnyObject]
                    _ = try Entity.init(dictionary: entityObject, model: model)
                }
 
                models.append(model)
            }
            
            print(models.count)
            
            return
        }
        
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }
}