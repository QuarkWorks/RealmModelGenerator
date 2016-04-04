//
//  RelationshipsViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/31/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

protocol RelationshipsVCDelegate: class {
    func relationshipsVC(relationshipsVC: RelationshipsVC, selectedRelationshipDidChange relationship:Relationship?)
}

class RelationshipsVC: NSViewController {
    static let TAG = NSStringFromClass(RelationshipsVC)

    var entity: Entity? {
        didSet {
            selectedRelationship = nil
        }
    }
    
    weak var selectedRelationship: Relationship? {
        didSet {
            if oldValue === self.selectedRelationship { return }
        }
    }
    
    //MARK: - Update selected attribute after its detail changed
    func updateSelectedAttribute(selectedRelationship: Relationship) {
        self.selectedRelationship = selectedRelationship
    }
    
    weak var delegate:RelationshipsVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
