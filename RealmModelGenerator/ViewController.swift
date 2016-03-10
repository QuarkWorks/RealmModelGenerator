//
//  ViewController.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/2/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    enum Language: String {
        case Swift, Objc, Java
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let model = Model(version: "1")
        let user = model.createEntity({ (entity) -> Void in
            try! entity.setName("User")
            let pk = entity.createAttribute({ (attribute) -> Void in
                try! attribute.setName("id")
                attribute.type = AttributeType.String
            })
            try! entity.setPrimaryKey(pk)
            
            entity.createAttribute({ (attribute) -> Void in
                try! attribute.setName("phone")
                attribute.type = AttributeType.String
                attribute.isRequired = true
                try! attribute.setIndexed(true)
            })
        })
        
        let child = model.createEntity { (entity) -> Void in
            try! entity.setName("Child")
            let pk = entity.createAttribute({
                try! $0.setName("id")
                $0.type = .Long
            })
            
            try! entity.setPrimaryKey(pk)
            
            entity.createAttribute({
                try! $0.setName("childName")
                $0.defaultValue = "Bob"
                $0.type = .String
                $0.hasDefault = true
            })
            
            entity.createAttribute({
                try! $0.setName("age")
                $0.defaultValue = "10"
                $0.type = .Int
                $0.hasDefault = true
                $0.isIgnored = true
                try! $0.setIndexed(true)
            })
        }
        
        user.createRelationship({
            try! $0.setName("children")
            $0.destination = child
            $0.isMany = true
        })
        
        for entity in model.entities {
            print(generateFile(entity, language: .Java))
        }
    }
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    //ZHAO, Make new swift files. seperate it out :) do ya thing
    func generateFile(entity:Entity, language:Language) -> String {
        
        switch language {
        case .Swift:
            return language.rawValue
        case .Objc:
            return language.rawValue
        case .Java:
            var hContent: String
            var mContent: String
            (hContent, mContent) = ObjectCContentGenerator(entity: entity).getContent()
            print(mContent)
            return hContent
//            return SwiftContentGenerator(entity: entity).getContent()
        }
    }
    
    //Called from menu bar
    func exportToJava(sender: AnyObject!)
    {
        print("export to java")
        let file = FileModel(name: "TestJava", content: "I'm java content", fileExtension: "java");
        choosePathAndSaveFile(file)
    }
    
    //Called from menu bar
    func exportToObjectC(sender: AnyObject!)
    {
        print("export to object c")
        let file = FileModel(name: "TestObjectC", content: "I'm object c content", fileExtension: ".m");
        choosePathAndSaveFile(file)
    }
    
    //Called from menu bar
    func exportToSwift(sender: AnyObject!)
    {
        print("export to swift")
        let file = FileModel(name: "TestSwift", content: "I'm swift content", fileExtension: "swift");
        choosePathAndSaveFile(file)
    }
    
    //MARK: show a panel to choose path and save file
    func choosePathAndSaveFile(file: FileModel)
    {
        let openPanel = NSOpenPanel()
        openPanel.allowsOtherFileTypes = false
        openPanel.treatsFilePackagesAsDirectories = false
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.prompt = "Choose"
        openPanel.beginSheetModalForWindow(view.window!, completionHandler: { (button : Int) -> Void in
            if button == NSFileHandlingPanelOKButton{
                self.saveFile(file, toPath:openPanel.URL!.path!)
            }
        })
    }
    
    //MARK: Save a file to a path
    func saveFile(file: FileModel, toPath path: String)
    {
        var error : NSError?
        let filePath = "\(path)/\(file.name).\(file.fileExtension)"
        
        do {
            try file.content.writeToFile(filePath, atomically: false, encoding: NSUTF8StringEncoding)
        } catch let nSError as NSError {
            error = nSError
        }
        
        if error != nil{
            NSAlert(error: error!).runModal()
        }
        
        if error == nil{
            print("Success")
            //TODO: show success notification
        }
    }
}

