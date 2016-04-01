//
//  DetailsViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/28/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

@objc protocol DetailsViewControllerDelegate {
    optional func notifiyDetailsChange(detailsViewController:DetailsViewController, detailChangedAt:String)
}

class DetailsViewController: NSViewController, EntityDetailViewControllerDelegate, AttributeDetailViewControllerDelegate, RelationshipDetailViewControllerDelegate {
    static let TAG = NSStringFromClass(DetailsViewController)
    
    let entityDetailViewController = NSStoryboard(name: "Main", bundle: nil).instantiateControllerWithIdentifier("EntityDetailViewController") as! EntityDetailViewController
    let attributeDetailViewController = NSStoryboard(name: "Main", bundle: nil).instantiateControllerWithIdentifier("AttributeDetailViewController") as! AttributeDetailViewController
    let relationshipDetailViewController = NSStoryboard(name: "Main", bundle: nil).instantiateControllerWithIdentifier("RelationshipDetailViewController") as! RelationshipDetailViewController
    
    @IBOutlet weak var detailsContainerView: NSView!
    @IBOutlet weak var emptyTextField: NSTextField!
    
    var delegate: DetailsViewControllerDelegate?
    
    private var detailType: DetailType?
    private var entity: Entity?
    private var attribute: Attribute?
    private var relationship: Relationship?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        entityDetailViewController.delegate = self
        attributeDetailViewController.delegate = self
        relationshipDetailViewController.delegate = self
    }
    
    override func viewWillAppear() {
        if detailsContainerView != nil && detailsContainerView.subviews.count > 0 {
            detailsContainerView.subviews[0].removeFromSuperview()
        }
        
        if let detailType = self.detailType {
            emptyTextField.hidden = true
            switch detailType {
            case .Entity:
                entityDetailViewController.entity = entity
                entityDetailViewController.delegate = self
                detailsContainerView.addSubview(entityDetailViewController.view)
                break
            case .Attribute:
                attributeDetailViewController.attribute = attribute
                detailsContainerView.addSubview(attributeDetailViewController.view)
                break
            case .Relationship:
                relationshipDetailViewController.relationship = relationship
                detailsContainerView.addSubview(relationshipDetailViewController.view)
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
    
    //MARK: - EntityDetailViewController delegate
    func entityDetailDidChange(entityDetailViewController: EntityDetailViewController) {
        self.delegate?.notifiyDetailsChange?(self, detailChangedAt: DetailType.Entity.rawValue)
    }
    
    //MARK: - AttributeDetailViewController delegate
    func attributeDetailDidChange(attributeDetailViewController: AttributeDetailViewController) {
        self.delegate?.notifiyDetailsChange?(self, detailChangedAt: DetailType.Attribute.rawValue)
    }
    
    //MARK: - RelatioinshipDetailViewController delegate
    func relationshipDetailViewControllerDelegate(relationshipDetailViewControllerDelegate: RelationshipDetailViewControllerDelegate) {
        self.delegate?.notifiyDetailsChange?(self, detailChangedAt: DetailType.Relationship.rawValue)
    }
}
