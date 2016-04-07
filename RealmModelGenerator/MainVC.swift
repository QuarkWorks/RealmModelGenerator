//
//  ViewController.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/2/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

class MainVC: NSViewController, EntitiesVCDelegate, AttributesRelationshipsVCDelegate {
    static let TAG = NSStringFromClass(MainVC)
    
    private weak var model: Model?
    private weak var selectedEnity: Entity?
    
    @IBOutlet weak var leftDivider: NSView!
    @IBOutlet weak var rightDivider: NSView!
    @IBOutlet weak var entitiesContainerView: NSView!
    @IBOutlet weak var attributesRelationshipsContainerView: NSView!
    @IBOutlet weak var detailsContainerView: NSView!
    
    private weak var entitiesVC:EntitiesVC! = nil {
        didSet {
            self.entitiesVC.delegate = self
        }
    }
    
    private weak var attributesRelationshipsMainVC:AttributesRelationshipsMainVC! = nil {
        didSet {
            self.attributesRelationshipsMainVC.delegate = self
        }
    }
    
    private weak var detailsVC:DetailsMainVC! = nil

    var schema = Schema() {
        didSet {
            model = schema.currentModel
            entitiesVC.schema = self.schema
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        leftDivider.layer?.backgroundColor = NSColor.grayColor().CGColor
        rightDivider.layer?.backgroundColor = NSColor.grayColor().CGColor
    }
    
    override func viewWillAppear() {
        // Because of loading schema happens after viewDidLoad so we need to update schema in entities view
        entitiesVC.schema = self.schema
    }
    
    //MARK: - EntitiesVC delegate
    func entitiesVC(entitiesVC: EntitiesVC, selectedEntityDidChange entity: Entity?) {
        self.selectedEnity = entity
        
        if let entity = entity {
            detailsVC.updateDetailView(entity, detailType: DetailType.Entity)
            attributesRelationshipsMainVC.updateAttributeRelationship(entity, detailType: DetailType.Entity)
        } else {
            detailsVC.updateDetailView(nil, detailType: DetailType.Entity)
            attributesRelationshipsMainVC.updateAttributeRelationship(nil, detailType: DetailType.Empty)
        }
    }
    
    //MARK: - AttributesRelationshipsViewController delegate - attribute
    func attributesRelationshipsVC(attributesRelationshipsVC: AttributesRelationshipsMainVC, selectedAttributeDidChange attribute: Attribute?) {
        if let index = self.selectedEnity?.attributes.indexOf({$0 === attribute}) {
            if let attribute = selectedEnity?.attributes[index] {
                detailsVC.updateDetailView(attribute, detailType: DetailType.Attribute)
            }
        } else {
            detailsVC.updateDetailView(nil, detailType: DetailType.Empty)
        }
    }
    
    //MARK: - AttributesRelationshipsViewController delegate - relationship
    func attributesRelationshipsVC(attributesRelationshipsVC: AttributesRelationshipsMainVC, selectedRelationshipDidChange relationship: Relationship?) {
        if let index = self.selectedEnity?.relationships.indexOf({$0 === relationship}) {
            if let relationship = selectedEnity?.relationships[index] {
                detailsVC.updateDetailView(relationship, detailType: DetailType.Relationship)
            }
        } else {
            detailsVC.updateDetailView(nil, detailType: DetailType.Empty)
        }
    }
    
    //MARK: - PrepareForSegue
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if segue.destinationController is EntitiesVC {
            self.entitiesVC = segue.destinationController as! EntitiesVC
        } else if segue.destinationController is AttributesRelationshipsMainVC {
            self.attributesRelationshipsMainVC = segue.destinationController as! AttributesRelationshipsMainVC
        } else if segue.destinationController is DetailsMainVC {
            self.detailsVC = segue.destinationController as! DetailsMainVC
        }
    }
}