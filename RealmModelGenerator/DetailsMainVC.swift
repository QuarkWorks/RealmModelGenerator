//
//  DetailsViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/28/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

class DetailsMainVC: NSViewController {
    static let TAG = NSStringFromClass(DetailsMainVC)
    
    private var entityDetailVC: EntityDetailVC! = nil
    private var attributeDetailVC: AttributeDetailVC! = nil
    private var relationshipDetailVC: RelationshipDetailVC! = nil
    
    @IBOutlet weak var detailsContainerView: NSView!
    @IBOutlet weak var emptyTextField: NSTextField!
    
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
    
    var detailType: DetailType {
        if selectedEntity != nil {
            if selectedAttribute != nil {
                return .Attribute
            }
            if selectedRelationship != nil {
                return .Relationship
            }
            return .Entity
        }
        return .Empty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        entityDetailVC = self.storyboard!.instantiateControllerWithIdentifier("EntityDetailVC") as! EntityDetailVC
        attributeDetailVC = self.storyboard!.instantiateControllerWithIdentifier("AttributeDetailVC") as! AttributeDetailVC
        relationshipDetailVC = self.storyboard!.instantiateControllerWithIdentifier("RelationshipDetailVC") as! RelationshipDetailVC
        
        self.addChildViewController(entityDetailVC)
        self.addChildViewController(attributeDetailVC)
        self.addChildViewController(relationshipDetailVC)
        
        detailsContainerView.addSubview(entityDetailVC.view)
        detailsContainerView.addSubview(attributeDetailVC.view)
        detailsContainerView.addSubview(relationshipDetailVC.view)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        invalidateViews()
    }
    
    func invalidateViews() {
        entityDetailVC.entity = self.selectedEntity
        attributeDetailVC.attribute = self.selectedAttribute
        relationshipDetailVC.relationship = self.selectedRelationship
        
        self.emptyTextField.hidden = true
        self.entityDetailVC.view.hidden = true
        self.attributeDetailVC.view.hidden = true
        self.relationshipDetailVC.view.hidden = true
        
        switch self.detailType {
        case .Entity:
            self.entityDetailVC.view.hidden = false
        case .Attribute:
            self.attributeDetailVC.view.hidden = false
        case .Relationship:
            self.relationshipDetailVC.view.hidden = false
        case .Empty:
            self.emptyTextField.hidden = false
        }
    }
}
