//
//  AttributesView.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/31/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

protocol AttributesViewDataSource: class {
    func numberOfRowsInAttributesView(attributesView:AttributesView) -> Int
    func attributesView(attributesView:AttributesView, titleForAttributeAtIndex index:Int) -> String
    func attributesView(attributesView:AttributesView, typeForAttributeAtIndex index:Int) -> AttributeType
}

protocol AttributesViewDelegate: class {
    func addAttributeInAttributesView(attributesView:AttributesView)
    func attributesView(attributesView:AttributesView, removeAttributeAtIndex index:Int)
    func attributesView(attributesView:AttributesView, selectedIndexDidChange index:Int?)
    func attributesView(attributesView:AttributesView, shouldChangeAttributeName name:String,
        atIndex index:Int) -> Bool
    func attributesView(attributesView:AttributesView, atIndex index:Int, changeAttributeType attributeType:AttributeType)
    func attributesView(attributesView:AttributesView, sortByColumnName name:String, ascending:Bool)
    func attributesView(attributesView:AttributesView, dragFromIndex:Int, dropToIndex:Int)
}

@IBDesignable
class AttributesView: NibDesignableView, NSTableViewDelegate, NSTableViewDataSource, TitleCellDelegate, PopupCellDelegate {
    static let TAG = NSStringFromClass(AttributesView.self)
    
    static let ATTRIBUTE_COLUMN = "attribute"
    static let TYPE_COLUMN = "type"
    let ATTRIBUTE_TYPES = AttributeType.values.flatMap({$0.rawValue})
    let ROW_TYPE = "rowType"
    
    @IBOutlet var tableView:NSTableView!
    @IBOutlet weak var addButton:NSButton!
    @IBOutlet weak var removeButton:NSButton!
    @IBOutlet weak var typesPopupButton: NSTableCellView!
    
    weak var dataSource:AttributesViewDataSource? {
        didSet { self.reloadData() }
    }
    weak var delegate:AttributesViewDelegate?
    
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
    
    //MARK: - Lifecycle
    override func nibDidLoad() {
        super.nibDidLoad()
        removeButton.isEnabled = false
        tableView.register(forDraggedTypes: [ROW_TYPE, NSFilenamesPboardType])
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
        let descriptorAttribute = NSSortDescriptor(key: AttributesView.ATTRIBUTE_COLUMN, ascending: true)
        let descriptorType = NSSortDescriptor(key: AttributesView.TYPE_COLUMN, ascending: true)
        tableView.tableColumns[0].sortDescriptorPrototype = descriptorAttribute
        tableView.tableColumns[1].sortDescriptorPrototype = descriptorType
    }
    
    //MARK: - NSTableViewDataSource
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if self.isInterfaceBuilder {
            return 5
        }
        
        if let numberOfItems = self.dataSource?.numberOfRowsInAttributesView(attributesView: self) {
            return numberOfItems
        }
        
        return 0
    }
    
    //MARK: - NSTableViewDelegate
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if tableColumn?.identifier == AttributesView.ATTRIBUTE_COLUMN {
        
            let cell = tableView.make(withIdentifier: TitleCell.IDENTIFIER, owner: nil) as! TitleCell
            if (self.isInterfaceBuilder) {
                cell.title = "Attribute"
                return cell
            }
            
            cell.delegate = self
            
            if let title = self.dataSource?.attributesView(attributesView: self, titleForAttributeAtIndex:row) {
                cell.title = title
            }
            
            return cell
            
        } else {
            let cell = tableView.make(withIdentifier: PopUpCell.IDENTIFIER, owner: nil) as! PopUpCell
            
            cell.itemTitles = ATTRIBUTE_TYPES
            cell.row = row
            
            if (self.isInterfaceBuilder) {
                return cell
            }
            
            cell.delegate = self
    
            if let attributeType = self.dataSource?.attributesView(attributesView: self, typeForAttributeAtIndex: row) {
                cell.selectedItemIndex = AttributeType.values.index(of: attributeType)!
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        
        let sortDescriptor = tableView.sortDescriptors.first!
        self.delegate?.attributesView(attributesView: self, sortByColumnName: sortDescriptor.key!, ascending: sortDescriptor.ascending)
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        self.delegate?.attributesView(attributesView: self, selectedIndexDidChange: self.selectedIndex)
        self.reloadRemoveButtonState()
    }
    
    //MARK: - Events
    @IBAction func addAttributeButtonOnClick(sender: AnyObject) {
        self.window!.makeFirstResponder(self.tableView)
        self.delegate?.addAttributeInAttributesView(attributesView: self)
    }
    
    @IBAction func removeAttributeOnClick(sender: AnyObject) {
        if let index = selectedIndex {
            self.window!.makeFirstResponder(self.tableView)
            self.delegate?.attributesView(attributesView: self, removeAttributeAtIndex:index)
        }
    }
    
    //MARK: - TitleCellDelegate
    func titleCell(titleCell: TitleCell, shouldChangeTitle title: String) -> Bool {
        let index = self.tableView.row(for: titleCell)
        if index != -1 {
            if let shouldChange = self.delegate?.attributesView(attributesView: self, shouldChangeAttributeName: title, atIndex: index) {
                return shouldChange
            }
        }
        
        return true
    }
    
    //MARK: - PopUpCellDelegate
    func popUpCell(popUpCell: PopUpCell, selectedItemDidChangeIndex index: Int) {
        
        let cellIndex = self.tableView.row(for: popUpCell)
        self.delegate?.attributesView(attributesView: self, atIndex:cellIndex, changeAttributeType: AttributeType.values[index])
    }
    
    //MARK: - Copy the row to the pasteboard
    func tableView(_ tableView: NSTableView, writeRowsWith writeRowsWithIndexes: IndexSet, to toPasteboard: NSPasteboard) -> Bool {
        
        let data = NSKeyedArchiver.archivedData(withRootObject: [writeRowsWithIndexes])
        
        toPasteboard.declareTypes([ROW_TYPE], owner:self)
        toPasteboard.setData(data, forType:ROW_TYPE)
        
        return true
    }
    
    //MARK: - Validate the drop
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableViewDropOperation) -> NSDragOperation {
        
        tableView.setDropRow(row, dropOperation: NSTableViewDropOperation.above)
        return NSDragOperation.move
    }
    
    //MARK: - Handle the drop
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableViewDropOperation) -> Bool {
        let pasteboard = info.draggingPasteboard()
        let rowData = pasteboard.data(forType: ROW_TYPE)
        
        if(rowData != nil) {
            var dataArray = NSKeyedUnarchiver.unarchiveObject(with: rowData!) as! Array<NSIndexSet>,
            indexSet = dataArray[0]
            
            let movingFromIndex = indexSet.firstIndex
            self.delegate?.attributesView(attributesView: self, dragFromIndex: movingFromIndex, dropToIndex: row)
            
            return true
        }
        else {
            return false
        }
    }
}
