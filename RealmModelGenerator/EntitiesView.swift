//
//  EntitiesView.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/20/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

protocol EntitiesViewDataSource: class {
    func numberOfRowsInEntitiesView(entitiesView:EntitiesView) -> Int
    func entitiesView(entitiesView:EntitiesView, titleForEntityAtIndex index:Int) -> String
}

protocol EntitiesViewDelegate: class {
    func addEntityInEntitiesView(entitiesView:EntitiesView)
    func entitiesView(entitiesView:EntitiesView, removeEntityAtIndex index:Int)
    func entitiesView(entitiesView:EntitiesView, selectedIndexDidChange index:Int?)
    func entitiesView(entitiesView:EntitiesView, shouldChangeEntityName name:String,
        atIndex index:Int) -> Bool
}

@IBDesignable
class EntitiesView: NibDesignableView, NSTableViewDelegate, NSTableViewDataSource, TitleCellDelegate {
    
    @IBOutlet var tableView:NSTableView!
    @IBOutlet var addButton:NSButton!
    @IBOutlet var removeButton:NSButton!
    
    weak var dataSource:EntitiesViewDataSource? {
        didSet { self.reloadData() }
    }
    weak var delegate:EntitiesViewDelegate?
    
    var selectedIndex:Int? {
        get {
            return self.tableView.selectedRow != -1 ? self.tableView.selectedRow : nil
        }
        
        set {
            if self.selectedIndex == newValue || (newValue == nil && self.tableView.selectedRow == -1) {
                return
            }
            
            
            if let newValue = newValue {
                self.tableView.selectRowIndexes(NSIndexSet(index: newValue), byExtendingSelection: false)
            } else {
                self.tableView.deselectAll(nil)
            }
        }
    }

    //MARK: Lifecycle
    override func nibDidLoad() {
        super.nibDidLoad()
        removeButton.enabled = false
    }
    
    func reloadData() {
        if !self.nibLoaded { return }
        self.tableView.reloadData()
        reloadRemoveButtonState()
    }
    
    func reloadRemoveButtonState() {
        self.removeButton.enabled = self.selectedIndex != nil
    }
    
    //MARK: - NSTableViewDataSource
     func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if self.isInterfaceBuilder {
            return 5
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
        
        cell.delegate = self // also set in interface builder as files owner
        
        if let title = self.dataSource?.entitiesView(self, titleForEntityAtIndex:row) {
            cell.title = title
        }
        
        return cell
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        self.delegate?.entitiesView(self, selectedIndexDidChange: self.selectedIndex)
        self.reloadRemoveButtonState()
    }
    
    //MARK: - Events
    @IBAction func addButtonOnClick(_: AnyObject) {
        self.window!.makeFirstResponder(self.tableView)
        self.delegate?.addEntityInEntitiesView(self)
    }
    
    @IBAction func removeButtonOnClick(_: AnyObject) {
        if let index = selectedIndex {
            self.window!.makeFirstResponder(self.tableView)
            self.delegate?.entitiesView(self, removeEntityAtIndex:index)
        }
    }
    
    //MARK: - TitleCellDelegate
    func titleCell(titleCell: TitleCell, shouldChangeTitle title: String) -> Bool {
        let index = self.tableView.rowForView(titleCell)
        if index != -1 {
            if let shouldChange = self.delegate?.entitiesView(self, shouldChangeEntityName: title, atIndex: index) {
                return shouldChange
            }
        }
        
        return true
    }
}