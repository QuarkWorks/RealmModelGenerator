//
//  ViewController.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/2/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    //MARK: - NSTableViewDataSource
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return 1000
    }
    
    //MARK: - NSTableViewDelegate
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeViewWithIdentifier(TitleCell.IDENTIFIER, owner: nil) as! TitleCell
        cell.title = "\(row)"
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func generateFileContent(entity:Entity, language:Language) -> Array<String> {
        
        switch language {
            case .Swift:
                return SwiftContentGenerator(entity: entity).getContent()
            case .Objc:
                return ObjectCContentGenerator(entity: entity).getContent()
            case .Java:
                return JavaContentGenerator(entity: entity).getContent()
        }
    }
    
    //Called from menu bar
    //TODO: remove after adding ui to generate model
    @IBAction func generateModelExample(sender: AnyObject!) {
//        Tools.generateModelExample(schema)
//        if let currentModel = schema.getCurrentModel() {
//            print(TAG + " version after generateSchemaExample = \(currentModel.version)")
//        }
    }
    
    //Called from menu bar
    @IBAction func increaseVersion(sender: AnyObject!) {
//        schema.increaseVersion()
//        if let currentModel = schema.getCurrentModel() {
//            print(TAG + " version after createNewVersionModel = \(currentModel.version)")
//        }
    }
    
    //Called from menu bar
    @IBAction func exportToJava(sender: AnyObject!) {
        generateFileModels(.Java)
    }
    
    //Called from menu bar
    @IBAction func exportToObjectC(sender: AnyObject!) {
        generateFileModels(.Objc)
    }
    
    //Called from menu bar
    @IBAction func exportToSwift(sender: AnyObject!) {
        generateFileModels(.Swift)
    }
    
    //MARK: generate FileModels
    func generateFileModels(language: Language) {
        var files: [FileModel] = []
        var validEnties = true
        for entity in schema.getCurrentModel()!.entities {
            let content = generateFileContent(entity, language: language)
            if !content.first!.isEmpty {
                switch language {
                    case .Java:
                        let file = FileModel(name: entity.name, content: content.first!, fileExtension: "java");
                        files.append(file)
                        break
                    case .Swift:
                        let file = FileModel(name: entity.name, content: content.first!, fileExtension: "swift");
                        files.append(file)
                        break;
                    case .Objc:
                        let hFile = FileModel(name: entity.name, content: content.first!, fileExtension: "h");
                        let mFile = FileModel(name: entity.name, content: content.last!, fileExtension: "m");
                        files.append(hFile)
                        files.append(mFile)
                        break
                }
            } else {
                validEnties = false
            }
        }
        
        if files.count > 0 && validEnties {
            choosePathAndSaveFile(files)
        } else {
            print("There's no entity.")
        }
    }
    
    //MARK: show a panel to choose path and save files
    func choosePathAndSaveFile(files: [FileModel])
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
                self.saveFile(files, toPath:openPanel.URL!.path!)
            }
        })
    }
    
    //MARK: Save files to a path
    func saveFile(files: [FileModel], toPath path: String)
    {
        var error : NSError?
        
        for file in files {
            let filePath = "\(path)/\(file.name).\(file.fileExtension)"
            
            do {
                try file.content.writeToFile(filePath, atomically: false, encoding: NSUTF8StringEncoding)
            } catch let nSError as NSError {
                error = nSError
            }
            
            if error != nil{
                NSAlert(error: error!).runModal()
            }
        }
        
        if error == nil{
            //TODO: show success notification
            print("Success")
        }
    }
}