//
//  EntitiesView.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/20/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

@IBDesignable
class EntitiesView: NibDesignableView, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet var tableView:NSTableView!
    
    @IBOutlet var addButton:NSButton!
    @IBOutlet var removeButton:NSButton!
    
    override func nibDidLoad() {
        super.nibDidLoad()
    }
    
    //MARK: - NSTableViewDataSource
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if self.isInterfaceBuilder {
            return 1
        }
        return 1000
    }
    
    //MARK: - NSTableViewDelegate
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeViewWithIdentifier(TitleCell.IDENTIFIER, owner: nil) as! TitleCell
        if (self.isInterfaceBuilder) {
            cell.title = "Entity"
            return cell
        }
        cell.title = "\(row)"
        return cell
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
}