//
//  Document.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/14/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

class RealmSchemaDocument: NSDocument {
<<<<<<< e9af64e619e870c839dcc4de1a3537f6705d6343
    static let TAG = String(RealmSchemaDocument)
    
    var vc: ViewController!
    var schema = Schema()
=======
>>>>>>> Added a subclass of NSDocument and modified Info.plist to convert to document-based project
    
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
<<<<<<< e9af64e619e870c839dcc4de1a3537f6705d6343
        
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
        
=======
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateControllerWithIdentifier("Document Window Controller") as! NSWindowController
>>>>>>> Added a subclass of NSDocument and modified Info.plist to convert to document-based project
        self.addWindowController(windowController)
    }
    
    override func dataOfType(typeName: String) throws -> NSData {
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
<<<<<<< e9af64e619e870c839dcc4de1a3537f6705d6343
        
        var arrayOfDictionaries = [NSDictionary]()
        
        let schemaDict = vc.schema.toDictionary()
        arrayOfDictionaries.append(schemaDict)
=======
        var arrayOfDictionaries = [NSDictionary]()
        
        let newDictionary: NSDictionary = [
            "model 0.0" : ["entity name": "entity a"],
            "model 0.1" : ["entity name": "entity b"]
        ]
        
        arrayOfDictionaries.append(newDictionary)
>>>>>>> Added a subclass of NSDocument and modified Info.plist to convert to document-based project
    
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
<<<<<<< e9af64e619e870c839dcc4de1a3537f6705d6343
        
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
            
            try schema.map(dictionary as! [String : AnyObject])
            
            return
        }
    }
}
=======
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }
    
    
}

>>>>>>> Added a subclass of NSDocument and modified Info.plist to convert to document-based project
