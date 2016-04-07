
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
    
    var attributesVC:AttributesVC! = nil {
        didSet {
            self.attributesVC.delegate = self
        }
    }
    
    var relationshipsVC:RelationshipsVC! = nil {
        didSet {
            self.relationshipsVC.delegate = self
        }
    }
    
    @IBOutlet weak var relationshipsContainerView: NSView!
    @IBOutlet weak var attributesContainerView: NSView!
    
    weak var delegate: AttributesRelationshipsVCDelegate?
    
    var entity: Entity? {
        didSet {
            self.invalidateViews()
        }
    }
    
    var attribute: Attribute? {
        didSet {
            attributesVC.updateSelectedAttribute(self.attribute!)
        }
    }
    
    var relationship: Relationship? {
        didSet {
            relationshipsVC.selectedRelationship = self.relationship
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func invalidateViews() {
        self.attributesVC.entity = self.entity
        self.relationshipsVC.entity = self.entity
    }
    
    //MARK: - AttributesVC delegate
    func attributesVC(attributesVC: AttributesVC, selectedAttributeDidChange attribute:Attribute?) {
        self.delegate?.attributesRelationshipsVC(self, selectedAttributeDidChange: attribute)
    }
    
    //MARK: - RelationshipsVC delegate
    func relationshipsVC(relationshipsVC: RelationshipsVC, selectedRelationshipDidChange relationship: Relationship?) {
        self.delegate?.attributesRelationshipsVC(self, selectedRelationshipDidChange: relationship)
    }
    
    func updateAttributeRelationship(detailObject: AnyObject?, detailType: DetailType) {
        switch detailType {
        case .Entity:
            self.entity = detailObject as? Entity
            break;
        case .Attribute:
            self.attribute = detailObject as? Attribute
            break
        case .Relationship:
            self.relationship = detailObject as? Relationship
        case .Empty:
            self.entity = nil
            break;
        }
    }
    
    //MARK: - PrepareForSegue
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if segue.destinationController is AttributesVC {
            self.attributesVC = segue.destinationController as! AttributesVC
        } else if segue.destinationController is RelationshipsVC {
            self.relationshipsVC = segue.destinationController as! RelationshipsVC
        }
    }
}
