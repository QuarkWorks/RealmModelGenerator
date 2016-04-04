//
//  DetailsViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/28/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

protocol DetailsVCDelegate: class {
    func detailsVC(detailsVC:DetailsMainVC, detailObject:AnyObject, detailType:DetailType)
}

class DetailsMainVC: NSViewController, EntityDetailVCDelegate, AttributeDetailVCDelegate, RelationshipDetailVCDelegate {
    static let TAG = NSStringFromClass(DetailsMainVC)
    
    var entityDetailVC: EntityDetailVC! = nil {
        didSet {
            self.entityDetailVC.delegate = self
        }
    }
    
    var attributeDetailVC: AttributeDetailVC! = nil {
        didSet {
            self.attributeDetailVC.delegate = self
        }
    }
    
    var relationshipDetailVC: RelationshipDetailVC! = nil {
        didSet {
            self.relationshipDetailVC.delegate = self
        }
    }
    
    @IBOutlet weak var detailsContainerView: NSView!
    @IBOutlet weak var emptyTextField: NSTextField!
    
    weak var delegate: DetailsVCDelegate?
    
    private var detailType: DetailType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        entityDetailVC = self.storyboard?.instantiateControllerWithIdentifier("EntityDetailVC") as! EntityDetailVC
        attributeDetailVC = self.storyboard?.instantiateControllerWithIdentifier("AttributeDetailVC") as! AttributeDetailVC
        relationshipDetailVC = self.storyboard?.instantiateControllerWithIdentifier("RelationshipDetailVC") as! RelationshipDetailVC
    }
    
    override func viewWillAppear() {
        self.addChildViewController(entityDetailVC)
        self.addChildViewController(attributeDetailVC)
        self.addChildViewController(relationshipDetailVC)
        
        detailsContainerView.addSubview(entityDetailVC.view)
        detailsContainerView.addSubview(attributeDetailVC.view)
        detailsContainerView.addSubview(relationshipDetailVC.view)
        invalidViews()
        setEmpty()
    }
    
    func invalidViews() {
        for childViewController in self.childViewControllers {
            childViewController.view.hidden = true
        }
        
        emptyTextField.hidden = true
    }
    
    func setEmpty() {
        emptyTextField.hidden = false
    }
    
    func setEntity(entity: Entity) {
        entityDetailVC.entity = entity
        entityDetailVC.view.hidden = false
    }
    
    func setAttribute(attribute: Attribute) {
        attributeDetailVC.attribute = attribute
        attributeDetailVC.view.hidden = false
    }
    
    func setRelationship(relationship: Relationship) {
        relationshipDetailVC.relationship = relationship
        relationshipDetailVC.view.hidden = false
    }
    
    func updateDetailView(anyObject: AnyObject?, detailType: DetailType) {
        invalidViews()
        
        if anyObject == nil {
            self.setEmpty()
            return
        }
        
        switch detailType {
        case .Entity:
            self.setEntity(anyObject as! Entity)
            break
        case .Attribute:
            self.setAttribute(anyObject as! Attribute)
            break
        case .Relationship:
            self.setRelationship(anyObject as! Relationship)
            break
        case .Empty:
            self.setEmpty()
            break
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
