//
//  RelationshipsViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/31/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

class RelationshipsViewController: NSViewController {
    static let TAG = NSStringFromClass(RelationshipsViewController)

    private var entity: Entity?
    
    var defaultEntity:Entity? {
        willSet(defaultEntity) {
            entity = defaultEntity
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
