//
//  EntitiesView.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/20/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

protocol EntitiesViewDataSource : NSObjectProtocol {
    func numberOfRowsInEntitiesView(entitiesView:EntitiesView) -> Int
    func entitiesView(entitiesView:EntitiesView, titleForEntityAtIndex index:Int) -> String?
}

protocol EntitiesViewDelegate : NSObjectProtocol {
    func addEntityInEntitiesView(entitiesView:EntitiesView)
    func removeEntityInEntitiesView(entitiesView:EntitiesView, index:Int?)
    func entitiesView(entitiesView:EntitiesView, didRemoveEntityAtIndex index:Int?)
}

@IBDesignable
class EntitiesView: NibDesignableView, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet var tableView:NSTableView!
    @IBOutlet var addButton:NSButton!
    @IBOutlet var removeButton:NSButton!
    
    weak var dataSource:EntitiesViewDataSource?
    weak var delegate:EntitiesViewDelegate?
    
    var selectedIndex:Int?
    
    override func nibDidLoad() {
        super.nibDidLoad()
        removeButton.enabled = false
    }
    
    //MARK: - NSTableViewDataSource
     func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if self.isInterfaceBuilder {
            return 20
        }
        
        if let numberOfItems = self.dataSource?.numberOfRowsInEntitiesView(self) {
            return numberOfItems
        }
        
        return 0
    }
    
    //MARK: - NSTableViewDelegate
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeViewWithIdentifier(TitleCell.IDENTIFIER, owner: nil) as! TitleCell
        if (self.isInterfaceBuilder) {
            cell.title = "Entity"
            return cell
        }
        
        if let title = self.dataSource?.entitiesView(self, titleForEntityAtIndex:row) {
            cell.title = title
        }
        
        return cell
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        let tableView = notification.object as! NSTableView
        selectedIndex = tableView.selectedRow
        self.delegate?.entitiesView(self, didRemoveEntityAtIndex:selectedIndex)
        
        removeButton.enabled = selectedIndex >= 0
    }
    
    @IBAction func addButton(_: AnyObject) {
        self.delegate?.addEntityInEntitiesView(self)
        reloadData()
    }
    
    @IBAction func removeButton(_: AnyObject) {
        self.delegate?.removeEntityInEntitiesView(self, index:selectedIndex)
        reloadData()
    }
    
    func reloadData() {
        tableView.reloadData()
        resetSelectedIndexState()
    }
    
    func resetSelectedIndexState() {
        selectedIndex = nil
        removeButton.enabled = false
    }
}