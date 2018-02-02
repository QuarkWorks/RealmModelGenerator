//
//  RealmSchemaDocument.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/14/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

class RealmSchemaDocument: NSDocument {
    static let TAG = String(describing: RealmSchemaDocument.self)
    
    private var mainVC: MainVC!
    private var schema = Schema()
    
    private var windowController:NSWindowController?
    
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }
    
    override func windowControllerDidLoadNib(_ aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        // Add any code here that needs to be executed once the windowController has loaded the document's window.
    }
    
    override class func autosavesInPlace() -> Bool {
        return true
    }
    
    override func makeWindowControllers() {
        
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "Document Window Controller") as! NSWindowController
        
        if let v = windowController.contentViewController as? MainVC {
            mainVC = v
            mainVC.schema = schema
        }
        
        self.addWindowController(windowController)
    }
    
    override func data(ofType: String) throws -> Data {
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
        
        var arrayOfDictionaries = [[String:Any]]()
        
        let schemaDict = mainVC.schema!.toDictionary()
        arrayOfDictionaries.append(schemaDict)
        
        let data: Data? = try JSONSerialization.data(withJSONObject: arrayOfDictionaries, options: [])
        
        if let value = data {
            return value
        }
        
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }
    
    override func read(from data: Data, ofType typeName: String) throws {
        // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
        // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
        // If you override either of these, you should also override -isEntireFileLoaded to return false if the contents are lazily loaded.
        do {
            try parseSchemaJson(data: data)
            return
        } catch GeneratorError.InvalidFileContent(let errorMsg) {
            //MARK: correct print function?
            Swift.print("Invalid JSON format: \(errorMsg)")
        }
        
        Tools.popupAllert(messageText: "Error", buttonTitile: "OK", informativeText: "Invalid content")
    }
    
    func parseSchemaJson(data: Data) throws {
        if let arrayOfDictionaries = try! JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]]{
            
            guard let dictionary = arrayOfDictionaries.first else {
                throw GeneratorError.InvalidFileContent(errorMsg: RealmSchemaDocument.TAG + ": No schema in this file")
            }
            
            try schema.map(dictionary: dictionary )
            
            return
        }
    }
}
