//
//  MainVC.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/2/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

class MainVC: NSViewController, EntitiesVCDelegate, AttributesRelationshipsVCDelegate, NSUserNotificationCenterDelegate, VersionVCDelegate {
    static let TAG = NSStringFromClass(MainVC.self)
    
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

    private var isFirstTimeSetSchema = true
    var schema:Schema?{
        didSet {
            if self.schema == nil { return }
            self.model = self.schema!.currentModel
            self.entitiesVC.schema = self.schema!
            isFirstTimeSetSchema = false
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        // Because of loading schema happens after viewDidLoad so we need to update schema in entities view
        self.invalidateViews()
    }
    
    
    // MARK: - Validation
    func invalidateViews() {
        if !self.isViewLoaded { return }
        self.entitiesVC.selectedEntity = self.selectedEntity
        
        self.detailsVC.selectedEntity = self.selectedEntity
        self.detailsVC.selectedAttribute = self.selectedAttribute
        self.detailsVC.selectedRelationship = self.selectedRelationship
        
        self.attributesRelationshipsMainVC.selectedEntity = self.selectedEntity
        self.attributesRelationshipsMainVC.selectedAttribute = self.selectedAttribute
        self.attributesRelationshipsMainVC.selectedRelationship = self.selectedRelationship
    }
    
    // MARK: - VersionVC delegate
    func versionVC(versionVC: VersionVC, selectedModelDidChange currentModel: Model?) {
        self.selectedEntity = nil
        self.selectedAttribute = nil
        self.selectedRelationship = nil
        invalidateViews()
    }
    
    // MARK: - EntitiesVC delegate
    func entitiesVC(entitiesVC: EntitiesVC, selectedEntityDidChange entity: Entity?) {
        self.selectedEntity = entity
    }
    
    // MARK: - AttributesRelationshipsViewController delegate - attribute
    func attributesRelationshipsVC(attributesRelationshipsVC: AttributesRelationshipsMainVC, selectedAttributeDidChange attribute: Attribute?) {
        self.selectedAttribute = attribute
    }
    
    // MARK: - AttributesRelationshipsViewController delegate - relationship
    func attributesRelationshipsVC(attributesRelationshipsVC: AttributesRelationshipsMainVC, selectedRelationshipDidChange relationship: Relationship?) {
        self.selectedRelationship = relationship
    }
    
    // MARK: - Segue
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.destinationController is EntitiesVC {
            self.entitiesVC = segue.destinationController as! EntitiesVC
        } else if segue.destinationController is AttributesRelationshipsMainVC {
            self.attributesRelationshipsMainVC = segue.destinationController as! AttributesRelationshipsMainVC
        } else if segue.destinationController is DetailsMainVC {
            self.detailsVC = segue.destinationController as! DetailsMainVC
        }
    }
}
