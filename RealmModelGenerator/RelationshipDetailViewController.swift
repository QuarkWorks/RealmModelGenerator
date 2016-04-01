//
//  RelationshipViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/29/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

@objc protocol RelationshipDetailViewControllerDelegate {
    optional func relationshipDetailViewControllerDelegate(relationshipDetailViewControllerDelegate:RelationshipDetailViewControllerDelegate)
}

class RelationshipDetailViewController: NSViewController {
    static let TAG = NSStringFromClass(RelationshipDetailViewController)
    
    weak var delegate: RelationshipDetailViewControllerDelegate?
    var relationship: Relationship?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setRelationship(relationship:Relationship) {
        self.relationship = relationship
    }
}
