//
//  RelationshipsView.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 4/12/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

protocol RelationshipsViewDataSource: AnyObject {
    func numberOfRowsInRelationshipsView(relationshipsView:RelationshipsView) -> Int
    func relationshipsView(relationshipsView:RelationshipsView, titleForRelationshipAtIndex index:Int) -> String
    func relationshipsView(relationshipsView:RelationshipsView, destinationForRelationshipAtIndex index:Int) -> String
}

protocol RelationshipsViewDelegate: AnyObject {
    func addRelationshipInRelationshipsView(relationshipsView:RelationshipsView)
    func relationshipsView(relationshipsView:RelationshipsView, removeRelationshipAtIndex index:Int)
    func relationshipsView(relationshipsView:RelationshipsView, selectedIndexDidChange index:Int?)
    func relationshipsView(relationshipsView:RelationshipsView, shouldChangeRelationshipName name:String,
        atIndex index:Int) -> Bool
    func relationshipsView(relationshipsView:RelationshipsView, atIndex index:Int, changeDestination destinationName:String)
    func relationshipsView(relationshipsView:RelationshipsView, sortByColumnName name:String, ascending:Bool)
    func relationshipsView(relationshipsView:RelationshipsView, dragFromIndex:Int, dropToIndex:Int)
}

@IBDesignable
class RelationshipsView: NibDesignableView, NSTableViewDelegate, NSTableViewDataSource, TitleCellDelegate, PopupCellDelegate  {
    // -- MARK UNCERTAIN -- backwardsCompatibleFileURL
    static let backwardsCompatibleFileURL: NSPasteboard.PasteboardType = {
        
        if #available(OSX 10.13, *) {
            return NSPasteboard.PasteboardType.fileURL
        } else {
            return NSPasteboard.PasteboardType(kUTTypeFileURL as String)
        }
        
    } ()
    static let TAG = NSStringFromClass(RelationshipsView.self)
    
    static let REALATIONSHIP_COLUMN = NSUserInterfaceItemIdentifier("relationship")
    static let DESTINATION_COLUMN = "destination"
    
    let ROW_TYPE = NSPasteboard.PasteboardType("rowType")
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var addButton: NSButton!
    @IBOutlet weak var removeButton: NSButton!
    
    weak var dataSource:RelationshipsViewDataSource? {
        didSet { self.reloadData() }
    }
    weak var delegate:RelationshipsViewDelegate?
    
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
    
    var destinationNames:[String] = []
    
    // MARK: - Lifecycle
    override func nibDidLoad() {
        super.nibDidLoad()
        removeButton.isEnabled = false
        //-- MARK UNCERTAIN -- backwardsCompatibleFileURL
        tableView.registerForDraggedTypes([ROW_TYPE, RelationshipsView.backwardsCompatibleFileURL])
        setUpDefaultSortDescriptor()
    }
    
    func reloadData() {
        if !self.nibLoaded { return }
        self.tableView.reloadData()
        reloadRemoveButtonState()
    }
    
    func reloadRemoveButtonState() {
        self.removeButton.isEnabled = self.selectedIndex != nil
    }
    
    func setUpDefaultSortDescriptor() {
        let descriptorAttribute = NSSortDescriptor(key: RelationshipsView.REALATIONSHIP_COLUMN.rawValue, ascending: true)
        let descriptorType = NSSortDescriptor(key: RelationshipsView.DESTINATION_COLUMN, ascending: true)
        tableView.tableColumns[0].sortDescriptorPrototype = descriptorAttribute
        tableView.tableColumns[1].sortDescriptorPrototype = descriptorType
    }
    
    // MARK: - NSTableViewDataSource
    func numberOfRows(in tableView: NSTableView) -> Int {
        if self.isInterfaceBuilder {
            return 5
        }
        
        if let numberOfItems = self.dataSource?.numberOfRowsInRelationshipsView(relationshipsView: self) {
            return numberOfItems
        }
        
        return 0
    }
    
    // MARK: - NSTableViewDelegate
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableColumn?.identifier == RelationshipsView.REALATIONSHIP_COLUMN {
            
            let cell = tableView.makeView(withIdentifier: TitleCell.IDENTIFIER, owner: nil) as! TitleCell
            if (self.isInterfaceBuilder) {
                cell.title = "Relationship"
                return cell
            }
            
            cell.delegate = self
            
            if let title = self.dataSource?.relationshipsView(relationshipsView: self, titleForRelationshipAtIndex:row) {
                cell.title = title
            }
            
            return cell
            
        } else {
            let cell = tableView.makeView(withIdentifier: PopUpCell.IDENTIFIER, owner: nil) as! PopUpCell
            
            cell.itemTitles = destinationNames
            cell.row = row
            
            if (self.isInterfaceBuilder) {
                return cell
            }
            
            cell.delegate = self
            
            if let destination = self.dataSource?.relationshipsView(relationshipsView: self, destinationForRelationshipAtIndex: row) {
                cell.selectedItemIndex = destinationNames.index(of: destination)!
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        
        let sortDescriptor = tableView.sortDescriptors.first!
        self.delegate?.relationshipsView(relationshipsView: self, sortByColumnName: sortDescriptor.key!, ascending: sortDescriptor.ascending)
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        self.delegate?.relationshipsView(relationshipsView: self, selectedIndexDidChange: self.selectedIndex)
        self.reloadRemoveButtonState()
    }
    

    // MARK: - Events
    @IBAction func addRelationshipOnClick(_ sender: Any) {
        self.window!.makeFirstResponder(self.tableView)
        self.delegate?.addRelationshipInRelationshipsView(relationshipsView: self)
    }

    @IBAction func removeRelationshipOnClick(_ sender: Any) {
        if let index = selectedIndex {
            self.window!.makeFirstResponder(self.tableView)
            self.delegate?.relationshipsView(relationshipsView: self, removeRelationshipAtIndex:index)
        }
    }
    
    // MARK: - TitleCellDelegate
    func titleCell(titleCell: TitleCell, shouldChangeTitle title: String) -> Bool {
        let index = self.tableView.row(for: titleCell)
        
        if index != -1 {
            if let shouldChange = self.delegate?.relationshipsView(relationshipsView: self, shouldChangeRelationshipName: title, atIndex: index) {
                return shouldChange
            }
        }
        
        return true
    }
    
    // MARK: - PopUpCellDelegate
    func popUpCell(popUpCell: PopUpCell, selectedItemDidChangeIndex index: Int) {
        let cellIndex = self.tableView.row(for: popUpCell)
        self.delegate?.relationshipsView(relationshipsView: self, atIndex:cellIndex, changeDestination: destinationNames[index])
    }
    
    // MARK: - Copy the row to the pasteboard
    func tableView(_ tableView: NSTableView, writeRowsWith writeRowsWithIndexes: IndexSet, to toPasteboard: NSPasteboard) -> Bool {
        
        let data = NSKeyedArchiver.archivedData(withRootObject: [writeRowsWithIndexes])
        
        toPasteboard.declareTypes([ROW_TYPE], owner:self)
        toPasteboard.setData(data, forType:ROW_TYPE)
        
        return true
    }
    
    // MARK: - Validate the drop
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {
        
        tableView.setDropRow(row, dropOperation: NSTableView.DropOperation.above)
        return NSDragOperation.move
    }
    
    // MARK: - Handle the drop
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableView.DropOperation) -> Bool {
        let pasteboard = info.draggingPasteboard()
        let rowData = pasteboard.data(forType: ROW_TYPE)
        
        if(rowData != nil) {
            var dataArray = NSKeyedUnarchiver.unarchiveObject(with: rowData!) as! Array<NSIndexSet>,
            indexSet = dataArray[0]
            
            let movingFromIndex = indexSet.firstIndex
            self.delegate?.relationshipsView(relationshipsView: self, dragFromIndex: movingFromIndex, dropToIndex: row)
            
            return true
        }
        else {
            return false
        }
    }
}
