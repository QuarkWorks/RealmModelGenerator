//
//  ViewController.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/2/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

class MainVC: NSViewController, EntitiesVCDelegate, AttributesRelationshipsVCDelegate, NSUserNotificationCenterDelegate {
    static let TAG = NSStringFromClass(MainVC)
    
    @IBOutlet weak var leftDivider: NSView!
    @IBOutlet weak var rightDivider: NSView!
    @IBOutlet weak var entitiesContainerView: NSView!
    @IBOutlet weak var attributesRelationshipsContainerView: NSView!
    @IBOutlet weak var detailsContainerView: NSView!
    
    private weak var entitiesVC:EntitiesVC! {
        didSet {
            self.entitiesVC.delegate = self
        }
    }
    
    private weak var attributesRelationshipsMainVC:AttributesRelationshipsMainVC! {
        didSet {
            self.attributesRelationshipsMainVC.delegate = self
        }
    }
    
    private weak var detailsVC:DetailsMainVC!

    var schema = Schema() {
        didSet {
            model = schema.currentModel
            entitiesVC.schema = self.schema
        }
    }
    
    private weak var model: Model?
    
    weak var selectedEntity:Entity? {
        didSet {
            if self.selectedEntity === oldValue { return }
            self.selectedAttribute = nil
            self.selectedRelationship = nil
            self.invalidateViews()
        }
    }
    
    weak var selectedAttribute: Attribute? {
        didSet {
            if self.selectedAttribute === oldValue { return }
            self.invalidateViews()
        }
    }
    
    weak var selectedRelationship: Relationship? {
        didSet {
            if self.selectedRelationship === oldValue { return }
            self.invalidateViews()
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        // Because of loading schema happens after viewDidLoad so we need to update schema in entities view
        self.invalidateViews()
    }
    
    
    //MARK: - Validation
    func invalidateViews() {
        if !self.viewLoaded { return }
        self.entitiesVC.selectedEntity = self.selectedEntity
        
        self.detailsVC.selectedEntity = self.selectedEntity
        self.detailsVC.selectedAttribute = self.selectedAttribute
        self.detailsVC.selectedRelationship = self.selectedRelationship
        
        self.attributesRelationshipsMainVC.selectedEntity = self.selectedEntity
        self.attributesRelationshipsMainVC.selectedAttribute = self.selectedAttribute
        self.attributesRelationshipsMainVC.selectedRelationship = self.selectedRelationship
    }
    
    //MARK: - EntitiesVC delegate
    func entitiesVC(entitiesVC: EntitiesVC, selectedEntityDidChange entity: Entity?) {
        self.selectedEntity = entity
    }
    
    //MARK: - AttributesRelationshipsViewController delegate - attribute
    func attributesRelationshipsVC(attributesRelationshipsVC: AttributesRelationshipsMainVC, selectedAttributeDidChange attribute: Attribute?) {
        self.selectedAttribute = attribute
    }
    
    //MARK: - AttributesRelationshipsViewController delegate - relationship
    func attributesRelationshipsVC(attributesRelationshipsVC: AttributesRelationshipsMainVC, selectedRelationshipDidChange relationship: Relationship?) {
        self.selectedRelationship = relationship
    }
    
    //MARK: - Segue
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if segue.destinationController is EntitiesVC {
            self.entitiesVC = segue.destinationController as! EntitiesVC
            self.entitiesVC.schema = self.schema
        } else if segue.destinationController is AttributesRelationshipsMainVC {
            self.attributesRelationshipsMainVC = segue.destinationController as! AttributesRelationshipsMainVC
        } else if segue.destinationController is DetailsMainVC {
            self.detailsVC = segue.destinationController as! DetailsMainVC
        }
    }
}