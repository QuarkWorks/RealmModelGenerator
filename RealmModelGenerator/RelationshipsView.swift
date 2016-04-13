//
//  RelationshipsView.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 4/12/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

protocol RelationshipsViewDataSource: class {
    func numberOfRowsInRelationshipsView(relationshipsView:RelationshipsView) -> Int
    func relationshipsView(relationshipsView:RelationshipsView, titleForRelationshipAtIndex index:Int) -> String
    func relationshipsView(relationshipsView:RelationshipsView, destinationForRelationshipAtIndex index:Int) -> String
}

protocol RelationshipsViewDelegate: class {
    func addRelationshipInRelationshipsView(relationshipsView:RelationshipsView)
    func relationshipsView(relationshipsView:RelationshipsView, removeRelationshipAtIndex index:Int)
    func relationshipsView(relationshipsView:RelationshipsView, selectedIndexDidChange index:Int?)
    func relationshipsView(relationshipsView:RelationshipsView, shouldChangeRelationshipName name:String,
        atIndex index:Int) -> Bool
    func relationshipsView(relationshipsView:RelationshipsView, atIndex index:Int, changeDestination destinationName:String)
}

@IBDesignable
class RelationshipsView: NibDesignableView, NSTableViewDelegate, NSTableViewDataSource, TitleCellDelegate, PopupCellDelegate  {
    static let TAG = NSStringFromClass(RelationshipsView)
    
    let REALATIONSHIP_COLUMN = "relationship"
    let DESTINATION_COLUMN = "destination"
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var addButton: NSButton!
    @IBOutlet weak var removeButton: NSButton!
    @IBOutlet weak var destinationPopupButton: PopUpCell!
    
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
                self.tableView.selectRowIndexes(NSIndexSet(index: newValue), byExtendingSelection: false)
            } else {
                self.tableView.deselectAll(nil)
            }
        }
    }
    
    var destinationNames:[String] = []
    
    //MARK: - Lifecycle
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
        
        if let numberOfItems = self.dataSource?.numberOfRowsInRelationshipsView(self) {
            return numberOfItems
        }
        
        return 0
    }
    
    //MARK: - NSTableViewDelegate
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableColumn?.identifier == REALATIONSHIP_COLUMN {
            
            let cell = tableView.makeViewWithIdentifier(TitleCell.IDENTIFIER, owner: nil) as! TitleCell
            if (self.isInterfaceBuilder) {
                cell.title = "Relationship"
                return cell
            }
            
            cell.delegate = self
            
            if let title = self.dataSource?.relationshipsView(self, titleForRelationshipAtIndex:row) {
                cell.title = title
            }
            
            return cell
            
        } else {
            let cell = tableView.makeViewWithIdentifier(PopUpCell.IDENTIFIER, owner: nil) as! PopUpCell
            
            cell.itemTitles = destinationNames
            cell.row = row
            
            if (self.isInterfaceBuilder) {
                return cell
            }
            
            cell.delegate = self
            
            if let destination = self.dataSource?.relationshipsView(self, destinationForRelationshipAtIndex: row) {
                cell.selectedItemIndex = destinationNames.indexOf(destination)!
            }
            
            return cell
        }
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        self.delegate?.relationshipsView(self, selectedIndexDidChange: self.selectedIndex)
        self.reloadRemoveButtonState()
    }
    
    //MARK: - Events
    @IBAction func addRelationshipOnClick(sender: AnyObject) {
        self.window!.makeFirstResponder(self.tableView)
        self.delegate?.addRelationshipInRelationshipsView(self)
    }
    
    @IBAction func removeRelationshipOnClick(sender: AnyObject) {
        if let index = selectedIndex {
            self.window!.makeFirstResponder(self.tableView)
            self.delegate?.relationshipsView(self, removeRelationshipAtIndex:index)
        }
    }
    
    //MARK: - TitleCellDelegate
    func titleCell(titleCell: TitleCell, shouldChangeTitle title: String) -> Bool {
        let index = self.tableView.rowForView(titleCell)
        
        if index != -1 {
            if let shouldChange = self.delegate?.relationshipsView(self, shouldChangeRelationshipName: title, atIndex: index) {
                return shouldChange
            }
        }
        
        return true
    }
    
    //MARK: - PopUpCellDelegate
    func popUpCell(popUpCell: PopUpCell, selectedItemDidChangeIndex index: Int) {
        let cellIndex = self.tableView.rowForView(popUpCell)
        self.delegate?.relationshipsView(self, atIndex:cellIndex, changeDestination: destinationNames[index])
    }
}