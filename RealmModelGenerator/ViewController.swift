//
//  ViewController.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/2/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, EntitiesVCDelegate, AttributesRelationshipsVCDelegate, DetailsVCDelegate {
    static let TAG = NSStringFromClass(ViewController)
    
    let entitiesVC = NSStoryboard(name: "Main", bundle: nil).instantiateControllerWithIdentifier("EntitiesViewController") as! EntitiesViewController
    let attributesRelationshipsVC = NSStoryboard(name: "Main", bundle: nil).instantiateControllerWithIdentifier("AttributesRelationshipsVC") as! AttributesRelationshipsVC
    let detailsVC = NSStoryboard(name: "Main", bundle: nil).instantiateControllerWithIdentifier("DetailsViewController") as! DetailsViewController
    
    var schema = Schema() {
        didSet {
            model = schema.currentModel
            entitiesVC.schema = self.schema
        }
    }
    
    private weak var model: Model?
    private weak var selectedEnity: Entity?
    
    @IBOutlet weak var leftDivider: NSView!
    @IBOutlet weak var rightDivider: NSView!
    
    @IBOutlet weak var entitiesContainerView: NSView!
    @IBOutlet weak var attributesRelationshipsContainerView: NSView!
    @IBOutlet weak var detailsContainerView: NSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        leftDivider.layer?.backgroundColor = NSColor.grayColor().CGColor
        rightDivider.layer?.backgroundColor = NSColor.grayColor().CGColor
        
        entitiesVC.delegate = self
        attributesRelationshipsVC.delegate = self
        detailsVC.delegate = self
    }
    
    override func viewWillAppear() {
        // Because of loading schema after viewDidLoad so we need to update entities view
        // TODO: Figure out a better way to handle it
        entitiesVC.schema = self.schema
        updateContainerView(entitiesContainerView, newView: entitiesVC.view)
    }
    
    //MARK: - EntitiesViewController delegate
    func entitiesVC(entitiesVC: EntitiesViewController, selectedEntityDidChange entity: Entity?) {
        
        self.selectedEnity = entity
        if let entity = entity {
            notifyDetailViewDataSourceChange(entity, detailType: DetailType.Entity)
            notifyAttributesRelationshipsDataChange(entity, detailType: DetailType.Entity)
        } else {
            notifyDetailViewDataSourceChange(nil, detailType: DetailType.Empty)
            notifyAttributesRelationshipsDataChange(nil, detailType: DetailType.Empty)
        }
    }
    
    //MARK: - AttributesRelationshipsViewController delegate - attribute
    func attributesRelationshipsVC(attributesRelationshipsVC: AttributesRelationshipsVC, selectedAttributeDidChange attribute: Attribute?) {
        if let index = self.selectedEnity?.attributes.indexOf({$0 === attribute}) {
            if let attribute = selectedEnity?.attributes[index] {
                notifyDetailViewDataSourceChange(attribute, detailType: DetailType.Attribute)
            }
        } else {
            notifyDetailViewDataSourceChange(nil, detailType: DetailType.Empty)
        }
    }
    
    //MARK: - AttributesRelationshipsViewController delegate - relationship
    func attributesRelationshipsVC(attributesRelationshipsVC: AttributesRelationshipsVC, selectedRelationshipDidChange relationship: Relationship?) {
        if let index = self.selectedEnity?.relationships.indexOf({$0 === relationship}) {
            if let relationship = selectedEnity?.relationships[index] {
                notifyDetailViewDataSourceChange(relationship, detailType: DetailType.Relationship)
            }
        } else {
            notifyDetailViewDataSourceChange(nil, detailType: DetailType.Empty)
        }
    }
    
    
    //MARK: - DetailsViewController delegate
    func detailsVC(detailsVC: DetailsViewController, detailObject: AnyObject, detailType: DetailType) {
        switch detailType {
        case .Entity:
            notifyEntitiesViewDataSourceChange()
            break;
        case .Attribute:
            notifyAttributesRelationshipsDataChange(detailObject, detailType: detailType)
            break;
        case .Relationship:
            break;
        default:
            break;
        }
    }
    
    //MARK: - Notify entities view data change
    func notifyEntitiesViewDataSourceChange() {
        entitiesVC.invalidateViews()
        updateContainerView(entitiesContainerView, newView: entitiesVC.view)
    }
    
    //MARK: - Notify attributes and relationships view data change
    func notifyAttributesRelationshipsDataChange(detailObject: AnyObject?, detailType: DetailType) {
        attributesRelationshipsVC.updateAttributeRelationship(detailObject, detailType: detailType)
        updateContainerView(attributesRelationshipsContainerView, newView: attributesRelationshipsVC.view)
    }
    
    //MARK: - Notify detail view data source change
    func notifyDetailViewDataSourceChange(anyObject: AnyObject?, detailType: DetailType) {
        detailsVC.updateDetailView(anyObject, detailType: detailType)
        updateContainerView(detailsContainerView, newView: detailsVC.view)
    }
    
    //MARK: - Update container view
    func updateContainerView(containerView: NSView, newView: NSView) {
        if containerView.subviews.count > 0 {
            containerView.subviews[0].removeFromSuperview()
        }
        
        containerView.addSubview(newView)
    }
}