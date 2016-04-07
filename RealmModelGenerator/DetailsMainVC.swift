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
        invalidViews(nil)
    }
    
    func invalidViews(viewController: NSViewController?) {
        emptyTextField.hidden = viewController != nil
        
        for childViewController in self.childViewControllers {
            if viewController != nil {
                childViewController.view.hidden = viewController != childViewController
            } else {
                childViewController.view.hidden = true
            }
        }
    }
    
    func updateDetailView(anyObject: AnyObject?, detailType: DetailType) {
        if anyObject == nil {
            invalidViews(nil)
            return
        }
        
        switch detailType {
        case .Entity:
            entityDetailVC.entity = (anyObject as! Entity)
            invalidViews(entityDetailVC)
            break
        case .Attribute:
            attributeDetailVC.attribute = (anyObject as! Attribute)
            invalidViews(attributeDetailVC)
            break
        case .Relationship:
            relationshipDetailVC.relationship = (anyObject as! Relationship)
            invalidViews(relationshipDetailVC)
            break
        case .Empty:
            invalidViews(nil)
            break
        }
    }
}
