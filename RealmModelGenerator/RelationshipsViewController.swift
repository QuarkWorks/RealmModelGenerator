//
//  RelationshipsViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/31/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

protocol RelationshipsVCDelegate: class {
    func relationshipsVC(relationshipsVC: RelationshipsViewController, selectedRelationshipDidChange relationship:Relationship?)
}

class RelationshipsViewController: NSViewController {
    static let TAG = NSStringFromClass(RelationshipsViewController)

    var entity: Entity? {
        didSet {
//            invalidateViews()
            selectedRelationship = nil
        }
    }
    
    weak var selectedRelationship: Relationship? {
        didSet {
            if oldValue === self.selectedRelationship { return }
//            invalidateSelectedIndex()
//            self.delegate?.relationshipsVC(self, selectedRelationshipDidChange: self.selectedRelationship)
        }
    }
    
    //MARK: - Update selected attribute after its detail changed
    func updateSelectedAttribute(selectedRelationship: Relationship) {
        self.selectedRelationship = selectedRelationship
//        invalidateViews()
    }
    
    weak var delegate:RelationshipsVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
