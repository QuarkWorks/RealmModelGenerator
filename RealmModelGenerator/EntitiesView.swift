//
//  EntitiesView.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/20/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

@IBDesignable
class EntitiesView: NibDesignableView, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet var tableView:NSTableView!
    
    @IBOutlet var addButton:NSButton!
    @IBOutlet var removeButton:NSButton!
    
    private var entities:[Entity] = []
    
    override func nibDidLoad() {
        super.nibDidLoad()
    }
    
    //MARK: - NSTableViewDataSource
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if self.isInterfaceBuilder {
            return 20
        }
        return entities.count
    }
    
    //MARK: - NSTableViewDelegate
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeViewWithIdentifier(TitleCell.IDENTIFIER, owner: nil) as! TitleCell
        if (self.isInterfaceBuilder) {
            cell.title = "Entity"
            return cell
        }
        cell.title = entities[row].name
        return cell
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    func setEntities(entities: [Entity]) {
        self.entities = entities
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        let tableView = notification.object as! NSTableView
        let index = tableView.selectedRow
        let selectedEntity = entities[index]
        Swift.print(selectedEntity.name)
        Swift.print(index)
    }
}