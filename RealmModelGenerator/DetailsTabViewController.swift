//
//  DetailViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/28/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

class DetailsTabViewController: NSTabViewController {
    static let TAG = NSStringFromClass(DetailsTabViewController)
    
    private var entity: Entity?
    private var attribute: Attribute?
    private var relationship: Relationship?
    
    private var currentView: NSTabViewItem?

    @IBOutlet weak var emptyView: NSTabViewItem!
    @IBOutlet weak var entityDetailView: NSTabViewItem!
    @IBOutlet weak var attributeDetailView: NSTabViewItem!
    @IBOutlet weak var relationshipDetailView: NSTabViewItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Remove items in tab bar
        self.tabView.tabViewType = .NoTabsNoBorder
    }
    
    func setEntity(entity: Entity?) {
        self.entity = entity
    }
    
    func setAttribute(attribute: Attribute?) {
        self.attribute = attribute
    }
    
    func setRelationshi(relationship: Relationship?){
        self.relationship = relationship
    }
    
    //MARK: - Add new tab view item and remove previous one
    func addView(tabViewItem: NSTabViewItem) {
        
    }
    
    //MARK: - Remove from parent view

}
