//
//  RelationshipViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/29/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

class RelationshipDetailVC: NSViewController, Observer {
    static let TAG = NSStringFromClass(RelationshipDetailVC)
    
    weak var relationship:Relationship? {
        didSet{
            if oldValue === self.relationship { return }
            oldValue?.observable.removeObserver(self)
            self.relationship?.observable.addObserver(self)
            self.invalidateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func invalidateViews() {
        
    }
    
    func onChange(observable: Observable) {
        
    }
}
