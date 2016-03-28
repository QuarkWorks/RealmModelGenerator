//
//  DetailViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/28/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

class DetailsViewController : NSViewController {
    static let TAG = NSStringFromClass(DetailsViewController)
    
    private var entity: Entity?
    private var attribute: Attribute?
    private var relationship: Relationship?
    
    override func viewDidLoad() {
        let  mainStoryboard: NSStoryboard = NSStoryboard(name: "Main", bundle: nil)
        
        if let entity = self.entity {
            let entityDetailViewController = mainStoryboard.instantiateControllerWithIdentifier("EntityDetailViewController") as! EntityDetailViewController
            
            entityDetailViewController.setEntiy(entity)
        } else if let attribute = self.attribute {
            //TODO: complete attribute
            print("attribute:\(attribute)")
            
        } else if let relationship = self.relationship {
            //TODO: complete relationship
            print("relationship:\(relationship)")
        } else {
            let emptyViewController = mainStoryboard.instantiateControllerWithIdentifier("EmptyViewController") as! EmptyViewController
            print("emptyViewController:\(emptyViewController)")
        }
    }
    
    func setEntity(entity: Entity) {
        self.entity = entity
        
        //TODO: set other object to nil
    }
    
    //MARK: - prepareForSegue
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "EntityDetailViewController":
            if let entityDetailViewController: EntityDetailViewController = segue.destinationController as? EntityDetailViewController {
                entityDetailViewController.setEntiy(entity!)
                entityDetailViewController.view.hidden = false
            }
            
            break;
        case "EmptyViewController":
            if let emptyViewController: EmptyViewController = segue.destinationController as? EmptyViewController {
                emptyViewController.view.hidden = true
            }
            
            break;
        default:
            //TODO: throw an NSAssertion().throw()
            break;
            
        }
    }
}
