//
//  AttributesRelationshipsViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/31/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

protocol AttributesRelationshipsVCDelegate: class {
    func attributesRelationshipsVC(attributesRelationshipsVC:AttributesRelationshipsVC, selectedAttributeDidChange attribute:Attribute?)
    func attributesRelationshipsVC(attributesRelationshipsVC:AttributesRelationshipsVC, selectedRelationshipDidChange relationship:Relationship?)
}

class AttributesRelationshipsVC: NSViewController, AttributesVCDelegate, RelationshipsVCDelegate {
    static let TAG = NSStringFromClass(AttributesRelationshipsVC)
    
    let attributesVC = NSStoryboard(name: "Main", bundle: nil).instantiateControllerWithIdentifier("AttributesViewController") as! AttributesViewController
    let relationshipsVC = NSStoryboard(name: "Main", bundle: nil).instantiateControllerWithIdentifier("RelationshipsViewController") as! RelationshipsViewController
    
    @IBOutlet weak var relationshipsContainerView: NSView!
    @IBOutlet weak var attributesContainerView: NSView!
    
    weak var delegate: AttributesRelationshipsVCDelegate?
    
    var entity: Entity? {
        didSet {
            if let entity = self.entity {
                updateEntity(entity)
            }
        }
    }
    
    var attribute: Attribute? {
        didSet {
            attributesVC.updateSelectedAttribute(self.attribute!)
            updateContainerView(attributesContainerView, newView: attributesVC.view)
        }
    }
    
    var relationship: Relationship? {
        didSet {
            relationshipsVC.selectedRelationship = self.relationship
            updateContainerView(relationshipsContainerView, newView: relationshipsVC.view)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        attributesVC.delegate = self
        relationshipsVC.delegate = self
    }
    
    override func viewWillAppear() {
        updateEntity(entity)
    }
    
    func updateEntity(entity: Entity?) {
        if attributesContainerView == nil || relationshipsContainerView == nil { return }
        attributesVC.entity = self.entity
        updateContainerView(attributesContainerView, newView: attributesVC.view)
        
        relationshipsVC.entity = self.entity
        updateContainerView(relationshipsContainerView, newView: relationshipsVC.view)

    }
    
    func updateContainerView(containerView: NSView, newView: NSView) {
        if containerView.subviews.count > 0 {
            containerView.subviews[0].removeFromSuperview()
        }
        
        containerView.addSubview(newView)
    }
    
    //MARK: - AttributesViewController delegate
    func attributesVC(attributesVC: AttributesViewController, selectedAttributeDidChange attribute:Attribute?) {
        self.delegate?.attributesRelationshipsVC(self, selectedAttributeDidChange: attribute)
    }
    
    //MARK: - RelationshipsViewController delegate
    func relationshipsVC(relationshipsVC: RelationshipsViewController, selectedRelationshipDidChange relationship: Relationship?) {
        self.delegate?.attributesRelationshipsVC(self, selectedRelationshipDidChange: relationship)
    }
    
    func updateAttributeRelationship(detailObject: AnyObject?, detailType: DetailType) {
        switch detailType {
        case .Entity:
            let entity = detailObject as! Entity
            self.entity = entity
            break;
        case .Attribute:
            let attribute = detailObject as! Attribute
            self.attribute = attribute
            break
        case .Relationship:
            let relationship = detailObject as! Relationship
            self.relationship = relationship
        case .Empty:
            self.entity = nil
            break;
        }
    }
}
