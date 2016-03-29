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
    @IBOutlet weak var attributeDetailView: NSTabViewItem!
    @IBOutlet weak var entityDetailView: NSTabViewItem!
    @IBOutlet weak var relationshipDetailView: NSTabViewItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Remove items in tab bar
        emptyView.tabView?.tabViewType = .NoTabsNoBorder
        entityDetailView.tabView?.tabViewType = .NoTabsNoBorder
        relationshipDetailView.tabView?.tabViewType = .NoTabsNoBorder
        
        // Show entity detailif reliationship is not null
        if let entity = self.entity {
            if let entityDetailViewController:EntityDetailViewController = entityDetailView.viewController as! EntityDetailViewController? {
                entityDetailViewController.setEntity(entity)
                addView(entityDetailView)
            }
        } else {
            self.removeTabViewItem(entityDetailView)
        }
        
        // Show attribute detail if attribute is not null
        if let attribute = self.attribute {
            if let attributeDetailViewController:AttributeDetailViewController = attributeDetailView.viewController as! AttributeDetailViewController? {
                attributeDetailViewController.setAttribute(attribute)
                addView(attributeDetailView)
            }
        } else {
            self.removeTabViewItem(attributeDetailView)
        }
        
        // Show relationship detail if reliationship is not null
        if let relationship = self.relationship {
            if let relationshipViewController:RelationshipViewController = relationshipDetailView.viewController as! RelationshipViewController? {
                relationshipViewController.setRelationship(relationship)
                addView(relationshipDetailView)
            }
        } else {
            self.removeTabViewItem(relationshipDetailView)
        }
        
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
        self.addTabViewItem(tabViewItem)
        removeTabViewItem(emptyView)
    }
}
