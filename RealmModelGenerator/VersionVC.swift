//
//  VersionVC.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 4/20/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

protocol VersionVCDelegate: class {
    func versionVC(versionVC:VersionVC, selectedModelDidChange currentModel:Model?)
}

class VersionVC: NSViewController {
    static let TAG = NSStringFromClass(VersionVC)
    
    @IBOutlet weak var versionPopUpButton: NSPopUpButton!
    
    var schema = Schema() {
        didSet {
            schema.models.forEach({(e) in
                modelVersions.append(e.version)
            })
        }
    }
    private var currentModel: Model {
        return self.schema.currentModel
    }
    
    private var modelVersions:[String] = ["New version"]
    
    weak var delegate:VersionVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        versionPopUpButton.removeAllItems()
        versionPopUpButton.addItemsWithTitles(modelVersions)
        versionPopUpButton.selectItemWithTitle(currentModel.version)
    }
    
    @IBAction func cancelButtonOnClick(sender: AnyObject) {
        self.dismissController(self)
    }
    
    @IBAction func okButtonOnClick(sender: AnyObject) {
        self.dismissController(self)
        
        if versionPopUpButton.indexOfSelectedItem == modelVersions.indexOf(self.currentModel.version) {
            return
        } else if versionPopUpButton.indexOfSelectedItem == 0 {
            do {
                try schema.increaseVersion()
                
            } catch {
                Tools.popupAllert("Error", buttonTitile: "OK", informativeText: "Cannot increase version")
            }
        } else {
            if versionPopUpButton.indexOfSelectedItem != modelVersions.indexOf(self.currentModel.version) {
                self.currentModel.isModifiable = false
                self.schema.models.filter({$0.version == versionPopUpButton.titleOfSelectedItem}).first!.isModifiable = true
            }
        }
        self.schema.observable.notifyObservers()
        self.delegate?.versionVC(self, selectedModelDidChange: currentModel)
    }
}
