//
//  AttributeDetailViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/29/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

class AttributeDetailViewController: NSViewController {
    static let TAG = NSStringFromClass(AttributeDetailViewController)

    var attribute: Attribute?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(AttributeDetailViewController.TAG)
    }
    
    override func viewWillAppear() {
//        print("attribute:\(attribute)")
    }
    
    func setAttribute(attribute: Attribute?) {
        self.attribute = attribute
    }
    
}
