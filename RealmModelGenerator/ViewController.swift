//
//  ViewController.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/2/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, EntitiesViewControllerDelegate, AttributesRelationViewControllerDelegate, DetailsViewControllerDelegate {
    static let TAG = NSStringFromClass(ViewController)
    
    static let entitiesViewControllerSegue = "EntitiesViewControllerSegue"
    static let attributesRelationshipsViewControllerSegue = "AttributesRelationshipsViewControllerSegue"
    static let detailsViewControllerSegue = "DetailsViewControllerSegue"
    
    var schema: Schema = Schema(name:"ViewControllerSchema")
    var model: Model?
    var entity: Entity?
    
    let entitiesViewController = NSStoryboard(name: "Main", bundle: nil).instantiateControllerWithIdentifier("EntitiesViewController") as! EntitiesViewController
    let attributesRelationshipsViewController = NSStoryboard(name: "Main", bundle: nil).instantiateControllerWithIdentifier("AttributesRelationshipsViewController") as! AttributesRelationshipsViewController
    let detailsViewController = NSStoryboard(name: "Main", bundle: nil).instantiateControllerWithIdentifier("DetailsViewController") as! DetailsViewController
    
    @IBOutlet weak var leftDivider: NSView!
    @IBOutlet weak var rightDivider: NSView!
    
    @IBOutlet weak var entitiesContainerView: NSView!
    @IBOutlet weak var attributesRelationshipsContainerView: NSView!
    @IBOutlet weak var detailsContainerView: NSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let currentModel = schema.getCurrentModel() {
            model = currentModel
        } else {
            model = schema.createModel()
        }
        
        self.view.wantsLayer = true
        leftDivider.layer?.backgroundColor = NSColor.grayColor().CGColor
        rightDivider.layer?.backgroundColor = NSColor.grayColor().CGColor
        
        entitiesViewController.delegate = self
        attributesRelationshipsViewController.delegate = self
        detailsViewController.delegate = self
    }
    
    //MARK: - EntitiesViewController delegate
    func entiesViewController(entitiesViewController: EntitiesViewController, selectionChange index: Int) {
        if index == EntitiesViewController.SELECTED_NONE_INDEX {
            self.entity = nil
            notifyDetailViewDataSourceChange(nil, detailType: DetailType.Empty)
            
        } else {
            self.entity = model!.entities[index]
            notifyDetailViewDataSourceChange(model!.entities[index], detailType: DetailType.Entity)
        }
        
        notifyAttributesRelationshipsDataChange()
    }
    
    //MARK: - AttributesRelationshipsViewController delegate
    func attributesRelationshipsViewController(attributesRelationshipsViewController: AttributesRelationshipsViewController, selectionChange index: Int) {
        
        if index == AttributesViewController.SELECTED_NONE_INDEX {
            notifyDetailViewDataSourceChange(nil, detailType: DetailType.Empty)
        } else if let attribute = entity?.attributes[index] {
            notifyDetailViewDataSourceChange(attribute, detailType: DetailType.Attribute)
        }
    }
    
    //MARK: - DetailsViewController delegate
    func notifiyDetailsChange(detailsViewController: DetailsViewController, detailChangedAt: String) {
        switch DetailType.init(rawValueSafe: detailChangedAt) {
        case .Entity:
            notifyEntitiesViewDataSourceChange()
            break;
        case .Attribute:
            notifyAttributesRelationshipsDataChange()
            break;
        case .Relationship:
            break;
        default:
            break;
        }
    }
    
    //MARK: - Notify entities view data change
    func notifyEntitiesViewDataSourceChange() {
        entitiesContainerView.subviews[0].removeFromSuperview()
        entitiesViewController.defaultModel = model
        entitiesContainerView.addSubview(entitiesViewController.view)
    }
    
    //MARK: - Notify attributes and relationships view data change
    func notifyAttributesRelationshipsDataChange() {
        attributesRelationshipsContainerView.subviews[0].removeFromSuperview()
        attributesRelationshipsViewController.defaultEntity = entity
        attributesRelationshipsContainerView.addSubview(attributesRelationshipsViewController.view)
    }
    
    //MARK: - Notify detail view data source change
    func notifyDetailViewDataSourceChange(anyObject: AnyObject?, detailType: DetailType) {
        detailsContainerView.subviews[0].removeFromSuperview()
        
        var isValid = true
        
        switch detailType {
        case .Entity:
            if let entity = anyObject as? Entity {
                detailsViewController.setEntity(entity)
            } else {
                isValid = false
            }
            break
        case .Attribute:
            if let attribute = anyObject as? Attribute {
                detailsViewController.setAttribute(attribute)
            } else {
                isValid = false
            }
            break
        case .Relationship:
            if let relationship = anyObject as? Relationship {
                detailsViewController.setRelationship(relationship)
            } else {
                isValid = false
            }
            break
        case .Empty:
            detailsViewController.setEmpty()
            break
        }
        
        if !isValid {
            detailsViewController.setEmpty()
        }
        
        detailsContainerView.addSubview(detailsViewController.view)
    }
    
    //MARK: - prepareForSegue
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case ViewController.entitiesViewControllerSegue:
            if let entitiesViewController: EntitiesViewController = segue.destinationController as? EntitiesViewController {
                entitiesViewController.defaultModel = model
                entitiesViewController.delegate = self
            }
            break;
        case ViewController.attributesRelationshipsViewControllerSegue:
            if let attributesRelationshipsViewController: AttributesRelationshipsViewController = segue.destinationController as? AttributesRelationshipsViewController {
                attributesRelationshipsViewController.delegate = self
            }
            break;
        case ViewController.detailsViewControllerSegue:
            if let detailsViewController: DetailsViewController = segue.destinationController as? DetailsViewController {
                detailsViewController.delegate = self
            }
            break;
        default:
            //TODO: throw an NSAssertion().throw()
            break;
        }
    }
}