//
//  EntityDetailViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/28/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

class EntityDetailViewController : NSViewController {
    static let TAG = NSStringFromClass(EntityDetailViewController)
    
    var entity: Entity?
    
    @IBOutlet weak var entityName: NSTextField!
    @IBOutlet weak var superClass: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        if entity != nil {
            entityName.stringValue = entity!.name
            //TODO: Complete super class
        }
    }
    
    func setEntity(entity:Entity) {
        self.entity = entity
    }
    
    @IBAction func entityNameDidChange(sender: AnyObject) {
        print("new entity name:\(entityName.stringValue)")
        //TODO: notify entity table view data change
    }
    
    @IBAction func superClassDidChange(sender: AnyObject) {
        print("new super class:\(superClass.stringValue)")
    }
    
    @IBAction func refreshButton(sender: AnyObject) {
        entityName.stringValue = "haha"
    }
}
