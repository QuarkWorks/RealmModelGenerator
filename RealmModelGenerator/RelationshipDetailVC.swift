//
//  RelationshipViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/29/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

class RelationshipDetailVC: NSViewController {
    static let TAG = NSStringFromClass(RelationshipDetailVC)
    
    weak var relationship: Relationship?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setRelationship(relationship:Relationship) {
        self.relationship = relationship
    }
}
