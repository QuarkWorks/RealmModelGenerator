
//  AttributesRelationshipsViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/31/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

protocol AttributesRelationshipsVCDelegate: class {
    func attributesRelationshipsVC(attributesRelationshipsVC:AttributesRelationshipsMainVC, selectedAttributeDidChange attribute:Attribute?)
    func attributesRelationshipsVC(attributesRelationshipsVC:AttributesRelationshipsMainVC, selectedRelationshipDidChange relationship:Relationship?)
}

class AttributesRelationshipsMainVC: NSViewController, AttributesVCDelegate, RelationshipsVCDelegate {
    static let TAG = NSStringFromClass(AttributesRelationshipsMainVC)
    
    var attributesVC:AttributesVC! {
        didSet {
            self.attributesVC.delegate = self
        }
    }
    
    var relationshipsVC:RelationshipsVC! {
        didSet {
            self.relationshipsVC.delegate = self
        }
    }
    
    @IBOutlet weak var relationshipsContainerView: NSView!
    @IBOutlet weak var attributesContainerView: NSView!
    
    weak var delegate: AttributesRelationshipsVCDelegate?
    
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
            self.delegate?.attributesRelationshipsVC(self, selectedAttributeDidChange: self.selectedAttribute)
            self.invalidateViews()
        }
    }
    
    weak var selectedRelationship: Relationship? {
        didSet {
            if self.selectedRelationship === oldValue { return }
            self.delegate?.attributesRelationshipsVC(self, selectedRelationshipDidChange: self.selectedRelationship)
            self.invalidateViews()
        }
    }

    //MARK - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.invalidateViews()
    }
    
    
    //MARK - Invalidation
    func invalidateViews() {
        if !viewLoaded { return }
        self.attributesVC.selectedEntity = self.selectedEntity
        self.relationshipsVC.entity = self.selectedEntity
    }
    
    //MARK: - AttributesVC delegate
    func attributesVC(attributesVC: AttributesVC, selectedAttributeDidChange attribute:Attribute?) {
        self.selectedAttribute = attribute
    }
    
    //MARK: - RelationshipsVC delegate
    func relationshipsVC(relationshipsVC: RelationshipsVC, selectedRelationshipDidChange relationship: Relationship?) {
        self.selectedRelationship = relationship
    }
    
    
    //MARK: - Segue
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if segue.destinationController is AttributesVC {
            self.attributesVC = segue.destinationController as! AttributesVC
        } else if segue.destinationController is RelationshipsVC {
            self.relationshipsVC = segue.destinationController as! RelationshipsVC
        }
    }
}
