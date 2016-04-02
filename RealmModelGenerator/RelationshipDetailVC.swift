//
//  RelationshipViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/29/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

protocol RelationshipDetailVCDelegate: class {
    func relationshipDetailVC(relationshipDetailVC:RelationshipDetailVC, detailDidChangeFor relationship:Relationship)
}

class RelationshipDetailVC: NSViewController {
    static let TAG = NSStringFromClass(RelationshipDetailVC)
    
    weak var relationship: Relationship?
    
    weak var delegate: RelationshipDetailVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setRelationship(relationship:Relationship) {
        self.relationship = relationship
    }
}
