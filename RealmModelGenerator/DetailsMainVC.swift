//
//  DetailsMainVC.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/28/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

class DetailsMainVC: NSViewController {
    static let TAG = NSStringFromClass(DetailsMainVC.self)
    
    private var entityDetailVC: EntityDetailVC! = nil
    private var attributeDetailVC: AttributeDetailVC! = nil
    private var relationshipDetailVC: RelationshipDetailVC! = nil
    
    @IBOutlet weak var detailsContainerView: NSView!
    @IBOutlet weak var emptyTextField: NSTextField!
    var isAttributeSelected = false
    
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
            self.isAttributeSelected = true
            self.invalidateViews()
        }
    }
    
    weak var selectedRelationship: Relationship? {
        didSet {
            if self.selectedRelationship === oldValue { return }
            self.isAttributeSelected = false
            self.invalidateViews()
        }
    }
    
    var detailType: DetailType {
        if selectedEntity != nil {
            if selectedAttribute != nil && (self.isAttributeSelected || selectedRelationship == nil) {
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
        
        entityDetailVC = self.storyboard!.instantiateController(withIdentifier: "EntityDetailVC") as! EntityDetailVC
        attributeDetailVC = self.storyboard!.instantiateController(withIdentifier: "AttributeDetailVC") as! AttributeDetailVC
        relationshipDetailVC = self.storyboard!.instantiateController(withIdentifier: "RelationshipDetailVC") as! RelationshipDetailVC
        
        self.addChildViewController(entityDetailVC)
        self.addChildViewController(attributeDetailVC)
        self.addChildViewController(relationshipDetailVC)
        
        detailsContainerView.addSubview(entityDetailVC.view)
        detailsContainerView.addSubview(attributeDetailVC.view)
        detailsContainerView.addSubview(relationshipDetailVC.view)
        self.emptyTextField.isHidden = false
        self.entityDetailVC.view.isHidden = true
        self.attributeDetailVC.view.isHidden = true
        self.relationshipDetailVC.view.isHidden = true
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        invalidateViews()
    }
    
    func invalidateViews() {
        entityDetailVC.entity = self.selectedEntity
        attributeDetailVC.attribute = self.selectedAttribute
        relationshipDetailVC.relationship = self.selectedRelationship
        
        self.emptyTextField.isHidden = true
        self.entityDetailVC.view.isHidden = true
        self.attributeDetailVC.view.isHidden = true
        self.relationshipDetailVC.view.isHidden = true
        
        switch self.detailType {
        case .Entity:
            self.entityDetailVC.view.isHidden = false
        case .Attribute:
            self.attributeDetailVC.view.isHidden = false
        case .Relationship:
            self.relationshipDetailVC.view.isHidden = false
        case .Empty:
            self.emptyTextField.isHidden = false
        }
    }
}
