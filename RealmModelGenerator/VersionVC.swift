//
//  VersionVC.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 4/20/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

protocol VersionVCDelegate: AnyObject {
    func versionVC(versionVC:VersionVC, selectedModelDidChange currentModel:Model?)
}

class VersionVC: NSViewController {
    static let TAG = NSStringFromClass(VersionVC.self)
    
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
        versionPopUpButton.addItems(withTitles: modelVersions)
        versionPopUpButton.selectItem(withTitle: currentModel.version)
    }
    
    @IBAction func cancelButtonOnClick(sender: Any) {
        self.dismiss(self)
    }
    
    @IBAction func okButtonOnClick(sender: Any) {
        self.dismiss(self)
        
        if versionPopUpButton.indexOfSelectedItem == modelVersions.index(of: self.currentModel.version) {
            return
        } else if versionPopUpButton.indexOfSelectedItem == 0 {
            do {
                try schema.increaseVersion()
                
            } catch {
                Tools.popupAlert(messageText: "Error", buttonTitle: "OK", informativeText: "Cannot increase version")
            }
        } else {
            if versionPopUpButton.indexOfSelectedItem != modelVersions.index(of: self.currentModel.version) {
                self.currentModel.isModifiable = false
                self.schema.models.filter({$0.version == versionPopUpButton.titleOfSelectedItem}).first!.isModifiable = true
            }
        }
        self.schema.observable.notifyObservers()
        self.delegate?.versionVC(versionVC: self, selectedModelDidChange: currentModel)
    }
}
