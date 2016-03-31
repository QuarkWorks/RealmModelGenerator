//
//  RelationshipViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/29/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

class RelationshipDetailViewController: NSViewController {
    static let TAG = NSStringFromClass(RelationshipDetailViewController)
    
    var relationship: Relationship?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(RelationshipViewController.TAG)
    }
    
    override func viewWillAppear() {
//        print("relationship:\(relationship)")
    }
    
    func setRelationship(relationship:Relationship) {
        self.relationship = relationship
    }
    
}
