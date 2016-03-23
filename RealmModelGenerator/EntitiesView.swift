//
//  EntitiesView.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/20/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

public protocol EntitiesViewDataSource : NSObjectProtocol {
    func numberOfRowsInEntitiesView(entitiesView:EntitiesView) -> Int
    func entitiesView(tableView:NSTableView, viewForTableColmn tableColumn: NSTableColumn?, row: Int) -> NSView?
}

public protocol EntitiesViewDelegate : NSObjectProtocol {
    func addEntityInEntitiesView(entitiesView:EntitiesView)
    func removeEntityInEntitiesView(entitiesView:EntitiesView)
    func entitiesViewSelectionDidChange(notification: NSNotification)
}

@IBDesignable
public class EntitiesView: NibDesignableView, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet var tableView:NSTableView!
    @IBOutlet var addButton:NSButton!
    @IBOutlet var removeButton:NSButton!
    
    var dataSource:EntitiesViewDataSource?
    var delegate:EntitiesViewDelegate?
    
    override public func nibDidLoad() {
        super.nibDidLoad()
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    //MARK: - NSTableViewDataSource
    public func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if self.isInterfaceBuilder {
            return 20
        }
        
        if let numberOfItems = self.dataSource?.numberOfRowsInEntitiesView(self) {
            return numberOfItems
        }
        
        return 0
    }
    
    //MARK: - NSTableViewDelegate
    public func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeViewWithIdentifier(TitleCell.IDENTIFIER, owner: nil) as! TitleCell
        if (self.isInterfaceBuilder) {
            cell.title = "Entity"
            return cell
        }
        return self.dataSource?.entitiesView(tableView, viewForTableColmn: tableColumn, row:row)
    }
    
    public func tableViewSelectionDidChange(notification: NSNotification) {
        self.delegate?.entitiesViewSelectionDidChange(notification)
    }
    
    @IBAction func addButton(_: AnyObject) {
        self.delegate!.addEntityInEntitiesView(self)
        tableView.reloadData()
    }
    
    @IBAction func removeButton(_: AnyObject) {
        self.delegate?.removeEntityInEntitiesView(self)
        tableView.reloadData()
    }
}