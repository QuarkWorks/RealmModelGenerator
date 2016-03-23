//
//  EntitieViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/21/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa


class EntitiesViewController: NSViewController, EntitiesViewDelegate, EntitiesViewDataSource {
    static let TAG = NSStringFromClass(EntitiesViewController)
    
    @IBOutlet weak var entitiesView: EntitiesView!
    
    private var schema:Schema = Schema()
    private var model: Model = Schema.init().createModel()
    private var entities:[Entity] = []
    private var selectedIndex = -1
    
    override func viewWillAppear() {
        entitiesView.delegate = self
        entitiesView.dataSource = self
        
        if let currentModel = schema.getCurrentModel() {
            model = currentModel
        } else {
            model = schema.createModel()
        }

        entities = model.entities
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
    
    //MARK: - EntitiesViewDelegate
    func entitiesView(entitiesView: NSTableView, viewForTableColmn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = entitiesView.makeViewWithIdentifier(TitleCell.IDENTIFIER, owner: nil) as! TitleCell
        cell.title = entities[row].name
        return cell
    }
    
    func entitiesViewSelectionDidChange(notification: NSNotification) {
        let tableView = notification.object as! NSTableView
        selectedIndex = tableView.selectedRow
    }
    
    func numberOfRowsInEntitiesView(entitiesView: EntitiesView) -> Int {
        return entities.count
        
    }
    
    func addEntityInEntitiesView(entitiesView: EntitiesView) {
        entities.append(model.createEntity())
        selectedIndex = -1
    }
    
    func removeEntityInEntitiesView(entitiesView: EntitiesView) {
        if (selectedIndex >= 0 && selectedIndex < entities.count) {
            model.removeEntity(entities[selectedIndex])
            entities.removeAtIndex(selectedIndex)
        }
    }
    
    func setSchema(schema: Schema) {
        self.schema = schema
    }
}