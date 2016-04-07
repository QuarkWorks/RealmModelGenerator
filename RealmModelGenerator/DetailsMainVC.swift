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
    
    private var detailType: DetailType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        entityDetailVC = self.storyboard!.instantiateControllerWithIdentifier("EntityDetailVC") as! EntityDetailVC
        attributeDetailVC = self.storyboard!.instantiateControllerWithIdentifier("AttributeDetailVC") as! AttributeDetailVC
        relationshipDetailVC = self.storyboard!.instantiateControllerWithIdentifier("RelationshipDetailVC") as! RelationshipDetailVC
    }
    
    override func viewWillAppear() {
        self.addChildViewController(entityDetailVC)
        self.addChildViewController(attributeDetailVC)
        self.addChildViewController(relationshipDetailVC)
        
        detailsContainerView.addSubview(entityDetailVC.view)
        detailsContainerView.addSubview(attributeDetailVC.view)
        detailsContainerView.addSubview(relationshipDetailVC.view)
        
        invalidViews()
    }
    
    func invalidViews() {
        entityDetailVC.entity = nil
        attributeDetailVC.attribute = nil
        relationshipDetailVC.relationship = nil
    }
    
    func updateDetailView(detail: AnyObject?, detailType: DetailType) {
        invalidViews()
        
        emptyTextField.hidden = detail != nil
        
        if detail == nil {
            return
        }
        
        switch detailType {
        case .Entity:
                entityDetailVC.entity = (detail as! Entity)
            break
        case .Attribute:
            attributeDetailVC.attribute = (detail as! Attribute)
            break
        case .Relationship:
            relationshipDetailVC.relationship = (detail as! Relationship)
            break
        case .Empty:
            break
        }
    }
}
