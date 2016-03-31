//
//  AttributesView.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/31/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

@objc protocol AttributesViewDataSource {
    optional func numberOfRowsInAttributesView(attributesView:AttributesView) -> Int
    optional func attributesView(attributesView:AttributesView, titleForAttributeAtIndex index:Int) -> String?
}

@objc protocol AttributesViewDelegate {
    optional func addAttributeInAttributesView(attributesView:AttributesView)
    optional func attributesView(attributesView:AttributesView, removeAttributeAtIndex index:Int)
    optional func attributesView(attributesView:AttributesView, selectionChange index:Int)
    optional func attributesView(attributesView:AttributesView, shouldChangeAttributeName name:String,
        atIndex index:Int) -> Bool
}

@IBDesignable
class AttributesView: NibDesignableView, NSTableViewDelegate, NSTableViewDataSource, TitleCellDelegate {
    static let TAG = NSStringFromClass(AttributesView)
    
    @IBOutlet var tableView:NSTableView!
    @IBOutlet weak var addButton: NSButton!
    @IBOutlet weak var removeButton: NSButton!
    
    weak var dataSource:AttributesViewDataSource?
    weak var delegate:AttributesViewDelegate?
    
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
        
        if let numberOfItems = self.dataSource?.numberOfRowsInAttributesView?(self) {
            return numberOfItems
        }
        
        return 0
    }
    
    //MARK: - NSTableViewDelegate
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeViewWithIdentifier(TitleCell.IDENTIFIER, owner: nil) as! TitleCell
        if (self.isInterfaceBuilder) {
            cell.title = "Attribute"
            return cell
        }
        
        if let title = self.dataSource?.attributesView?(self, titleForAttributeAtIndex:row) {
            cell.title = title
            cell.delegate = self
        }
        
        return cell
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        let tableView = notification.object as! NSTableView
        selectedIndex = tableView.selectedRow
        
        if let index = selectedIndex {
            self.delegate?.attributesView?(self, selectionChange: index)
        }
        
        removeButton.enabled = self.selectedIndex != nil
    }
    
    //MARK: - TitleCellDelegate
    func titleCell(titleCell: TitleCell, shouldChangeTitle title: String) -> Bool {
        let index = self.tableView.rowForView(titleCell)
        if index != -1 {
            if let shouldChange = self.delegate?.attributesView?(self, shouldChangeAttributeName: title, atIndex: index) {
                return shouldChange
            }
        }
        return true
    }
    
    @IBAction func addAttributeButton(sender: AnyObject) {
        self.delegate?.addAttributeInAttributesView?(self)
        reloadData()
    }

    @IBAction func removeAttributeButton(sender: AnyObject) {
        if let index = selectedIndex {
            self.delegate?.attributesView?(self, removeAttributeAtIndex:index)
            tableView.reloadData()
        }
    }
    
    func reloadData() {
        tableView.reloadData()
        self.removeButton.enabled = self.selectedIndex != nil
    }
}