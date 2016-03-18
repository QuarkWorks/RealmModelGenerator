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
    
    func generateFile(entity:Entity, language:Language) -> String {
        
        switch language {
        case .Swift:
            return language.rawValue
        case .Objc:
            return language.rawValue
        case .Java:
            return language.rawValue
//            var hContent: String
//            var mContent: String
//            (hContent, mContent) = ObjectCContentGenerator(entity: entity).getContent()
//            print(mContent)
//            return hContent
//            return SwiftContentGenerator(entity: entity).getContent()
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
    //TODO: refactor this part, show version choice
    @IBAction func increaseVersion(sender: AnyObject!) {
//        schema.increaseVersion()
//        if let currentModel = schema.getCurrentModel() {
//            print(TAG + " version after createNewVersionModel = \(currentModel.version)")
//        }
    }
    
    //Called from menu bar
    @IBAction func exportToJava(sender: AnyObject!)
    {
        print("export to java")
        let file = FileModel(name: "TestJava", content: "I'm java content", fileExtension: "java");
        choosePathAndSaveFile(file)
    }
    
    //Called from menu bar
    @IBAction func exportToObjectC(sender: AnyObject!)
    {
        print("export to object c")
        let file = FileModel(name: "TestObjectC", content: "I'm object c content", fileExtension: ".m");
        choosePathAndSaveFile(file)
    }
    
    //Called from menu bar
    @IBAction func exportToSwift(sender: AnyObject!)
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

