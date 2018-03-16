//
//  MainVCExtension.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/31/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

extension MainVC {
    // MARK: - generateFileContent
    func generateFileContent(entity:Entity, language:Language) -> [String] {
        
        switch language {
        case .Swift:
            return SwiftContentGenerator(entity: entity).getContent()
        case .Objc:
            return ObjectCContentGenerator(entity: entity).getContent()
        case .Java:
            return JavaContentGenerator(entity: entity).getContent()
        }
    }
    
    // MARK: - Called from menu bar, Version
    @IBAction func versonMenuOnClick(sender: Any!) {
        let versionVC: VersionVC = {
            return self.storyboard!.instantiateController(withIdentifier: "VersionVC")
                as! VersionVC
        }()
        versionVC.schema = self.schema!
        versionVC.delegate = self
        self.presentViewControllerAsSheet(versionVC)
        
    }
    
    
    // MARK: - Called from menu bar, exportToJava
    @IBAction func exportToJava(sender: Any!) {
        generateFileModels(language: .Java)
    }
    
    // MARK: - Called from menu bar, exportToObjectC
    @IBAction func exportToObjectC(sender: Any!) {
        generateFileModels(language: .Objc)
    }
    
    // MARK: - Called from menu bar, exportToSwift
    @IBAction func exportToSwift(sender: Any!) {
        generateFileModels(language: .Swift)
    }
    
    // MARK: - generate FileModels
    func generateFileModels(language: Language) {
        var files: [FileModel] = []
        var validEnties = true
        for entity in self.schema!.currentModel.entities {
            let content = generateFileContent(entity: entity, language: language)
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
            choosePathAndSaveFile(files: files)
        }
    }
    
    // MARK: - Show a panel to choose path and save files
    func choosePathAndSaveFile(files: [FileModel])
    {
        let openPanel = NSOpenPanel()
        openPanel.allowsOtherFileTypes = false
        openPanel.treatsFilePackagesAsDirectories = false
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.prompt = "Choose"
        openPanel.beginSheetModal(for: view.window!, completionHandler: { (button : Int) -> Void in
            if button == NSFileHandlingPanelOKButton{
                self.saveFile(files: files, toPath:openPanel.url!.path)
            }
        })
    }
    
    // MARK: - Save files to a path
    func saveFile(files: [FileModel], toPath path: String)
    {
        var error : NSError?
        
        for file in files {
            let filePath = "\(path)/\(file.name).\(file.fileExtension)"
            
            do {
                try file.content.write(toFile: filePath, atomically: false, encoding: String.Encoding.utf8)
            } catch let nSError as NSError {
                error = nSError
            }
            
            if error == nil{
                self.showSuccess()
            } else {
                Tools.popupAllert(messageText: "Error", buttonTitile: "OK", informativeText: "We an error when save file.")
            }
        }
    }
    
    // MARK: - Show success notification
    func showSuccess()
    {
        let notification = NSUserNotification()
        notification.title = "Success!"
        notification.informativeText = "Your realm model files have been generated successfully."
        notification.deliveryDate = NSDate() as Date
        
        let center = NSUserNotificationCenter.default
        center.delegate = self
        center.deliver(notification)
    }
    
    //MARK: - NSUserNotificationCenterDelegate
    func userNotificationCenter(center: NSUserNotificationCenter,
        shouldPresentNotification notification: NSUserNotification) -> Bool
    {
        return true
    }
}
