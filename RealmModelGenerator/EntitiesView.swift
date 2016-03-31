//
//  EntitiesView.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/20/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

@objc protocol EntitiesViewDataSource {
    optional func numberOfRowsInEntitiesView(entitiesView:EntitiesView) -> Int
    optional func entitiesView(entitiesView:EntitiesView, titleForEntityAtIndex index:Int) -> String?
}

@objc protocol EntitiesViewDelegate {
    optional func addEntityInEntitiesView(entitiesView:EntitiesView)
    optional func entitiesView(entitiesView:EntitiesView, removeEntityAtIndex index:Int)
    optional func entitiesView(entitiesView:EntitiesView, selectionChange index:Int)
    optional func entitiesView(entitiesView:EntitiesView, titleDidChangeForEntityAtIndex index:Int, newTitle:String)
}

@IBDesignable
class EntitiesView: NibDesignableView, NSTableViewDelegate, NSTableViewDataSource, TitleCellDelegate {
    
    @IBOutlet var tableView:NSTableView!
    @IBOutlet var addButton:NSButton!
    @IBOutlet var removeButton:NSButton!
    
    weak var dataSource:EntitiesViewDataSource?
    weak var delegate:EntitiesViewDelegate?
    
    var selectedIndex:Int? {
        get {
            return self.tableView.selectedRow != -1 ? self.tableView.selectedRow : nil
        }
        
        set {
            if (newValue != nil) {
                self.tableView.selectRowIndexes(NSIndexSet(index: newValue!), byExtendingSelection: false)
            } else {
                self.tableView.deselectAll(nil)
            }
        }
    }
    
    override func nibDidLoad() {
        super.nibDidLoad()
        removeButton.enabled = false
    }
    
    //MARK: - NSTableViewDataSource
     func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if self.isInterfaceBuilder {
            return 20
        }
        
        if let numberOfItems = self.dataSource?.numberOfRowsInEntitiesView?(self) {
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
        
        if let title = self.dataSource?.entitiesView?(self, titleForEntityAtIndex:row) {
            cell.title = title
            cell.delegate = self
        }
        
        return cell
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        let tableView = notification.object as! NSTableView
        selectedIndex = tableView.selectedRow
        
        if let index = selectedIndex {
            self.delegate?.entitiesView?(self, selectionChange:index)
        }
        
        removeButton.enabled = self.selectedIndex != nil
    }
    
    @IBAction func addButton(_: AnyObject) {
        self.delegate?.addEntityInEntitiesView?(self)
        reloadData()
    }
    
    func titleDidChange(newTitle: String) {
        self.delegate?.entitiesView?(self, titleDidChangeForEntityAtIndex: tableView.selectedRow, newTitle: newTitle)
    }
    
    @IBAction func removeButton(_: AnyObject) {
        if let index = selectedIndex {
            self.delegate?.entitiesView?(self, removeEntityAtIndex:index)
            tableView.reloadData()
        }
    }
    
    func reloadData() {
        tableView.reloadData()
        self.removeButton.enabled = self.selectedIndex != nil
    }
}