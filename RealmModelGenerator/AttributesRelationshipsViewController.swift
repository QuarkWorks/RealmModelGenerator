//
//  AttributesRelationshipsViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/31/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

protocol AttributesRelationViewControllerDelegate {
    func attributeSelected(attribute: Attribute?)
    func relationshipSelected(relationship: Relationship?)
}

class AttributesRelationshipsViewController: NSViewController, AttributesViewControllerDelegate {
    static let TAG = NSStringFromClass(AttributesRelationshipsViewController)
    
    static let attributesViewControllerSegue = "AttributesViewControllerSegue"
    static let relationshipsViewControllerSegue = "RelationshipsViewControllerSegue"
    
    var delegate: AttributesRelationViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - AttributesViewControllerDelegate
    func attributeSelected(attribute: Attribute?) {
        self.delegate?.attributeSelected(attribute)
    }
    
    //MARK: - prepareForSegue
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case AttributesRelationshipsViewController.attributesViewControllerSegue:
            if let attributesViewController: AttributesViewController = segue.destinationController as? AttributesViewController {
                attributesViewController.delegate = self
            }
            break;
        case AttributesRelationshipsViewController.relationshipsViewControllerSegue:
            break;
        default:
            //TODO: throw an NSAssertion().throw()
            print("Unknown segue identifier")
            break;
        }
    }

}
