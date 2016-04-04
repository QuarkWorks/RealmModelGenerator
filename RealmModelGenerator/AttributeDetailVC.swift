//
//  AttributeDetailViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/29/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

protocol AttributeDetailVCDelegate: class {
    func attributeDetailVC(attributeDetailVC:AttributeDetailVC, detailDidChangeFor attribute:Attribute)
}

class AttributeDetailVC: NSViewController, AttributeDetailViewDelegate {
    static let TAG = NSStringFromClass(AttributeDetailVC)

    @IBOutlet weak var attributeDetailView: AttributeDetailView! {
        didSet{ self.attributeDetailView.delegate = self }
    }
    
    weak var attribute: Attribute?
    weak var delegate: AttributeDetailVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        if attribute != nil {
            attributeDetailView.name = attribute!.name ?? ""
        }
    }
    
    func attributeDetailView(attributeDetailView: AttributeDetailView, shouldChangeAttributeName name: String) -> Bool {
        do {
            try self.attribute!.setName(name)
            self.delegate?.attributeDetailVC(self, detailDidChangeFor: self.attribute!)
        } catch {
            Tools.popupAllert("Error", buttonTitile: "OK", informativeText: "Unable to rename attribute: \(attribute!.name) to: \(name). There is an attribute with the same name.")
            return false

        }
        return true
    }
}
