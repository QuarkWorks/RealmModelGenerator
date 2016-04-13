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
}

@IBDesignable
class AttributesView: NibDesignableView, NSTableViewDelegate, NSTableViewDataSource, TitleCellDelegate, PopupCellDelegate {
    static let TAG = NSStringFromClass(AttributesView)
    
    static let ATTRIBUTE_COLUMN = "attribute"
    static let TYPE_COLUMN = "type"
    let ATTRIBUTE_TYPES = AttributeType.values.flatMap({$0.rawValue})
    
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
                self.tableView.selectRowIndexes(NSIndexSet(index: newValue), byExtendingSelection: false)
            } else {
                self.tableView.deselectAll(nil)
            }
        }
    }
    
    //MARK: - Lifecycle
    override func nibDidLoad() {
        super.nibDidLoad()
        removeButton.enabled = false
        
        let descriptorAttribute = NSSortDescriptor(key: AttributesView.ATTRIBUTE_COLUMN, ascending: true)
        let descriptorType = NSSortDescriptor(key: AttributesView.TYPE_COLUMN, ascending: true)
        tableView.tableColumns[0].sortDescriptorPrototype = descriptorAttribute
        tableView.tableColumns[1].sortDescriptorPrototype = descriptorType
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
        
        if let numberOfItems = self.dataSource?.numberOfRowsInAttributesView(self) {
            return numberOfItems
        }
        
        return 0
    }
    
    func tableView(tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {

        let sortDescriptor = tableView.sortDescriptors.first!
        self.delegate?.attributesView(self, sortByColumnName: sortDescriptor.key!, ascending: sortDescriptor.ascending)
    }
    
    //MARK: - NSTableViewDelegate
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if tableColumn?.identifier == AttributesView.ATTRIBUTE_COLUMN {
        
            let cell = tableView.makeViewWithIdentifier(TitleCell.IDENTIFIER, owner: nil) as! TitleCell
            if (self.isInterfaceBuilder) {
                cell.title = "Attribute"
                return cell
            }
            
            cell.delegate = self
            
            if let title = self.dataSource?.attributesView(self, titleForAttributeAtIndex:row) {
                cell.title = title
            }
            
            return cell
            
        } else {
            let cell = tableView.makeViewWithIdentifier(PopUpCell.IDENTIFIER, owner: nil) as! PopUpCell
            
            cell.itemTitles = ATTRIBUTE_TYPES
            cell.row = row
            
            if (self.isInterfaceBuilder) {
                return cell
            }
            
            cell.delegate = self
    
            if let attributeType = self.dataSource?.attributesView(self, typeForAttributeAtIndex: row) {
                cell.selectedItemIndex = AttributeType.values.indexOf(attributeType)!
            }
            
            return cell
        }
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        self.delegate?.attributesView(self, selectedIndexDidChange: self.selectedIndex)
        self.reloadRemoveButtonState()
    }
    
    //MARK: - Events
    @IBAction func addAttributeButtonOnClick(sender: AnyObject) {
        self.window!.makeFirstResponder(self.tableView)
        self.delegate?.addAttributeInAttributesView(self)
    }
    
    @IBAction func removeAttributeOnClick(sender: AnyObject) {
        if let index = selectedIndex {
            self.window!.makeFirstResponder(self.tableView)
            self.delegate?.attributesView(self, removeAttributeAtIndex:index)
        }
    }
    
    //MARK: - TitleCellDelegate
    func titleCell(titleCell: TitleCell, shouldChangeTitle title: String) -> Bool {
        let index = self.tableView.rowForView(titleCell)
        if index != -1 {
            if let shouldChange = self.delegate?.attributesView(self, shouldChangeAttributeName: title, atIndex: index) {
                return shouldChange
            }
        }
        
        return true
    }
    
    //MARK: - PopUpCellDelegate
    func popUpCell(popUpCell: PopUpCell, selectedItemDidChangeIndex index: Int) {
        
        let cellIndex = self.tableView.rowForView(popUpCell)
        self.delegate?.attributesView(self, atIndex:cellIndex, changeAttributeType: AttributeType.values[index])
    }
}