//
//  RelationshipViewController.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/29/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa

class RelationshipDetailVC: NSViewController, RelationshipDetailViewDelegate, Observer {
    static let TAG = NSStringFromClass(RelationshipDetailVC)
    
    private var entityNameList:[String] = ["None"]
    
    @IBOutlet weak var relationshipDetailView: RelationshipDetailView! {
        didSet{ self.relationshipDetailView.delegate = self }
    }
    
    weak var relationship:Relationship? {
        didSet{
            if oldValue === self.relationship { return }
            oldValue?.observable.removeObserver(self)
            self.relationship?.observable.addObserver(self)
            self.invalidateViews()
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func invalidateViews() {
        if !self.viewLoaded || relationship == nil { return }
        relationshipDetailView.name = self.relationship!.name
        relationshipDetailView.isMany = self.relationship!.isMany
        self.entityNameList = ["None"]
        self.relationship?.entity?.model.entities.forEach{(e) in entityNameList.append(e.name)}
        self.entityNameList.removeAtIndex(self.entityNameList.indexOf(self.relationship!.entity!.name)!)
        self.relationshipDetailView.destinationNames = self.entityNameList
        if let destination = self.relationship?.destination {
            relationshipDetailView.selectedIndex = entityNameList.indexOf(destination.name)!
        } else {
            relationshipDetailView.selectedIndex = 0
        }
    }
    
    func onChange(observable: Observable) {
        self.invalidateViews()
    }
    
    //MARK: - RelatioinshipDetailView delegate
    func relationshipDetailView(relationshipDetailView: RelationshipDetailView, shouldChangeRelationshipTextField newValue: String, identifier: String) -> Bool {
        do {
            try self.relationship!.setName(newValue)
        } catch {
            Tools.popupAllert("Error", buttonTitile: "OK", informativeText: "Unable to rename relationship: \(relationship!.name) to: \(newValue). There is another relationship with the same name.")
            return false
        }
        
        return true
    }
    
    func relationshipDetailView(attributeDetailView: RelationshipDetailView, shouldChangeRelationshipCheckBoxFor identifier: String, state: Bool) -> Bool {
        
        self.relationship?.isMany = state
        
        return true
    }
    
    func relationshipDetailView(relationshipDetailView: RelationshipDetailView, selectedDestinationDidChange selectedIndex: Int) -> Bool {
        self.relationship!.destination = self.relationship?.entity.model.entities.filter({$0.name == entityNameList[selectedIndex]}).first
                return true
    }
}
