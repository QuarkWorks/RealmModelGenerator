//
//  AttributesRelationshipsViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/31/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

@objc protocol AttributesRelationViewControllerDelegate {
    optional func attributesRelationshipsViewController(attributesRelationshipsViewController:AttributesRelationshipsViewController, selectionChange index:Int)
}

class AttributesRelationshipsViewController: NSViewController, AttributesViewControllerDelegate {
    static let TAG = NSStringFromClass(AttributesRelationshipsViewController)
    
    static let attributesViewControllerSegue = "AttributesViewControllerSegue"
    static let relationshipsViewControllerSegue = "RelationshipsViewControllerSegue"
    
    let attributesViewController = NSStoryboard(name: "Main", bundle: nil).instantiateControllerWithIdentifier("AttributesViewController") as! AttributesViewController
    let relationshipsViewController = NSStoryboard(name: "Main", bundle: nil).instantiateControllerWithIdentifier("RelationshipsViewController") as! RelationshipsViewController
    
    @IBOutlet weak var relationshipsContainerView: NSView!
    @IBOutlet weak var attributesContainerView: NSView!
    
    weak var delegate: AttributesRelationViewControllerDelegate?
    
    var entity: Entity?
    var defaultEntity: Entity? {
        willSet(defaultEntity) {
            entity = defaultEntity
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        attributesContainerView.subviews[0].removeFromSuperview()
        attributesViewController.defaultEntity = entity
        attributesViewController.delegate = self
        attributesContainerView.addSubview(attributesViewController.view)

        relationshipsContainerView.subviews[0].removeFromSuperview()
        relationshipsViewController.defaultEntity = entity
        relationshipsContainerView.addSubview(relationshipsViewController.view)
    }
    
    //MARK: - AttributesViewControllerDelegate
    func attributesViewController(attributesViewController: AttributesViewController, selectionChange index: Int) {
        self.delegate?.attributesRelationshipsViewController?(self, selectionChange: index)
    }
    
    //MARK: - prepareForSegue
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case AttributesRelationshipsViewController.attributesViewControllerSegue:
            if let attributesViewController: AttributesViewController = segue.destinationController as? AttributesViewController {
                attributesViewController.delegate = self
            }
            break;
        case AttributesRelationshipsViewController.relationshipsViewControllerSegue:
            break;
        default:
            //TODO: throw an NSAssertion().throw()
            print("Unknown segue identifier")
            break;
        }
    }

}
