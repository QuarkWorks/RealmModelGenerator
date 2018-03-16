//
//  EntitiesView.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/20/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

protocol EntitiesViewDataSource: AnyObject {
    func numberOfRowsInEntitiesView(entitiesView:EntitiesView) -> Int
    func entitiesView(entitiesView:EntitiesView, titleForEntityAtIndex index:Int) -> String
}

protocol EntitiesViewDelegate: AnyObject {
    func addEntityInEntitiesView(entitiesView:EntitiesView)
    func entitiesView(entitiesView:EntitiesView, removeEntityAtIndex index:Int)
    func entitiesView(entitiesView:EntitiesView, selectedIndexDidChange index:Int?)
    func entitiesView(entitiesView:EntitiesView, shouldChangeEntityName name:String,
        atIndex index:Int) -> Bool
    func entitiesView(entitiesView:EntitiesView, dragFromIndex:Int, dropToIndex:Int)
}

@IBDesignable
class EntitiesView: NibDesignableView, NSTableViewDelegate, NSTableViewDataSource, TitleCellDelegate {
    
    let ROW_TYPE = "rowType"
    
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
                self.tableView.selectRowIndexes(IndexSet(integer: newValue), byExtendingSelection: false)
            } else {
                self.tableView.deselectAll(nil)
            }
        }
    }

    // MARK: - Lifecycle
    override func nibDidLoad() {
        super.nibDidLoad()
        removeButton.isEnabled = false
        tableView.register(forDraggedTypes: [ROW_TYPE, NSFilenamesPboardType])
    }
    
    func reloadData() {
        if !self.nibLoaded { return }
        self.tableView.reloadData()
        reloadRemoveButtonState()
    }
    
    func reloadRemoveButtonState() {
        self.removeButton.isEnabled = self.selectedIndex != nil
    }
    
    // MARK: - NSTableViewDataSource
     func numberOfRows(in tableView: NSTableView) -> Int {
        if self.isInterfaceBuilder {
            return 5
        }
        
        if let numberOfItems = self.dataSource?.numberOfRowsInEntitiesView(entitiesView: self) {
            return numberOfItems
        }
        
        return 0
    }
    
    // MARK: - NSTableViewDelegate
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.make(withIdentifier: TitleCell.IDENTIFIER, owner: nil) as! TitleCell
        if (self.isInterfaceBuilder) {
            cell.title = "Entity"
            return cell
        }
        
        cell.delegate = self // also set in interface builder as files owner
        
        if let title = self.dataSource?.entitiesView(entitiesView: self, titleForEntityAtIndex:row) {
            cell.title = title
        }
        
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        self.delegate?.entitiesView(entitiesView: self, selectedIndexDidChange: self.selectedIndex)
        self.reloadRemoveButtonState()
    }
    
    // MARK: - Events
    @IBAction func addButtonOnClick(_: Any) {
        self.window!.makeFirstResponder(self.tableView)
        self.delegate?.addEntityInEntitiesView(entitiesView: self)
    }
    
    @IBAction func removeButtonOnClick(_: Any) {
        if let index = selectedIndex {
            self.window!.makeFirstResponder(self.tableView)
            self.delegate?.entitiesView(entitiesView: self, removeEntityAtIndex:index)
        }
    }
    
    // MARK: - TitleCellDelegate
    func titleCell(titleCell: TitleCell, shouldChangeTitle title: String) -> Bool {
        let index = self.tableView.row(for: titleCell)
        if index != -1 {
            if let shouldChange = self.delegate?.entitiesView(entitiesView: self, shouldChangeEntityName: title, atIndex: index) {
                return shouldChange
            }
        }
        
        return true
    }
    
    // MARK: - Copy the row to the pasteboard
    func tableView(_ tableView: NSTableView, writeRowsWith writeRowsWithIndexes: IndexSet, to toPasteboard: NSPasteboard) -> Bool {
        
        let data = NSKeyedArchiver.archivedData(withRootObject: [writeRowsWithIndexes])
        
        toPasteboard.declareTypes([ROW_TYPE], owner:self)
        toPasteboard.setData(data, forType:ROW_TYPE)
        
        return true
    }
    
    // MARK: - Validate the drop
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableViewDropOperation) -> NSDragOperation {
        
        tableView.setDropRow(row, dropOperation: NSTableViewDropOperation.above)
        return NSDragOperation.move
    }
    
    // MARK: - Handle the drop
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableViewDropOperation) -> Bool {
        let pasteboard = info.draggingPasteboard()
        let rowData = pasteboard.data(forType: ROW_TYPE)
        
        if(rowData != nil) {
            var dataArray = NSKeyedUnarchiver.unarchiveObject(with: rowData!) as! Array<NSIndexSet>,
            indexSet = dataArray[0]
            
            let movingFromIndex = indexSet.firstIndex
            self.delegate?.entitiesView(entitiesView: self, dragFromIndex: movingFromIndex, dropToIndex: row)
            
            return true
        }
        else {
            return false
        }
    }
}
