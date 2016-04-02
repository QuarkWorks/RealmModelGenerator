//
//  DetailsViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/28/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

protocol DetailsVCDelegate: class {
    func detailsVC(detailsVC:DetailsViewController, detailObject:AnyObject, detailType:DetailType)
}

class DetailsViewController: NSViewController, EntityDetailVCDelegate, AttributeDetailVCDelegate, RelationshipDetailVCDelegate {
    static let TAG = NSStringFromClass(DetailsViewController)
    
    let entityDetailVC = NSStoryboard(name: "Main", bundle: nil).instantiateControllerWithIdentifier("EntityDetailVC") as! EntityDetailVC
    let attributeDetailVC = NSStoryboard(name: "Main", bundle: nil).instantiateControllerWithIdentifier("AttributeDetailVC") as! AttributeDetailVC
    let relationshipDetailVC = NSStoryboard(name: "Main", bundle: nil).instantiateControllerWithIdentifier("RelationshipDetailVC") as! RelationshipDetailVC
    
    @IBOutlet weak var detailsContainerView: NSView!
    @IBOutlet weak var emptyTextField: NSTextField!
    
    weak var delegate: DetailsVCDelegate?
    
    private var detailType: DetailType?
    private var entity: Entity?
    private var attribute: Attribute?
    private var relationship: Relationship?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        entityDetailVC.delegate = self
        attributeDetailVC.delegate = self
        relationshipDetailVC.delegate = self
    }
    
    override func viewWillAppear() {
        if detailsContainerView != nil && detailsContainerView.subviews.count > 0 {
            detailsContainerView.subviews[0].removeFromSuperview()
        }
        
        if let detailType = self.detailType {
            emptyTextField.hidden = true
            switch detailType {
            case .Entity:
                entityDetailVC.entity = entity
                entityDetailVC.delegate = self
                detailsContainerView.addSubview(entityDetailVC.view)
                break
            case .Attribute:
                attributeDetailVC.attribute = attribute
                detailsContainerView.addSubview(attributeDetailVC.view)
                break
            case .Relationship:
                relationshipDetailVC.relationship = relationship
                detailsContainerView.addSubview(relationshipDetailVC.view)
                break
            default:
                emptyTextField.hidden = false
                break;
            }
        } else {
            emptyTextField.hidden = false
        }
    }
    
    func setEmpty() {
        detailType = nil
    }
    
    func setEntity(entity: Entity) {
        self.entity = entity
        detailType = DetailType.Entity
    }
    
    func setAttribute(attribute: Attribute) {
        self.attribute = attribute
        detailType = DetailType.Attribute
    }
    
    func setRelationship(relationship: Relationship) {
        self.relationship = relationship
        detailType = DetailType.Relationship
    }
    
    func updateDetailView(anyObject: AnyObject?, detailType: DetailType) {
        var isValid = true
        
        switch detailType {
        case .Entity:
            if let entity = anyObject as? Entity {
                self.setEntity(entity)
            } else {
                isValid = false
            }
            break
        case .Attribute:
            if let attribute = anyObject as? Attribute {
                self.setAttribute(attribute)
            } else {
                isValid = false
            }
            break
        case .Relationship:
            if let relationship = anyObject as? Relationship {
                self.setRelationship(relationship)
            } else {
                isValid = false
            }
            break
        case .Empty:
            self.setEmpty()
            break
        }
        
        if !isValid {
            self.setEmpty()
        }
    }

    //MARK: - EntityDetailViewController delegate
    func entityDetailVC(entityDetailVC:EntityDetailVC, detailDidChangeFor entity:Entity) {
        self.delegate?.detailsVC(self, detailObject: entity, detailType: DetailType.Entity)
    }
    
    //MARK: - AttributeDetailViewController delegate
    func attributeDetailVC(attributeDetailVC:AttributeDetailVC, detailDidChangeFor attribute:Attribute) {
        self.delegate?.detailsVC(self, detailObject: attribute, detailType: DetailType.Attribute)
    }
    
    //MARK: - RelatioinshipDetailViewController delegate
    func relationshipDetailVC(relationshipDetailVC:RelationshipDetailVC, detailDidChangeFor relationship:Relationship) {
        self.delegate?.detailsVC(self, detailObject: relationship, detailType: DetailType.Relationship)
    }
}
