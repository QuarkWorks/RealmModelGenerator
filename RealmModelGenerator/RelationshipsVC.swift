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

class RelationshipsVC: NSViewController, RelationshipsViewDelegate, RelationshipsViewDataSource, Observer {
    static let TAG = NSStringFromClass(RelationshipsVC)

    private var entityNameList:[String] = ["None"]
    
    @IBOutlet weak var relationshipsView: RelationshipsView! {
        didSet {
            self.relationshipsView.delegate = self
            self.relationshipsView.dataSource = self
        }
    }

    weak var selectedEntity: Entity? {
        didSet {
            if oldValue === self.selectedEntity { return }
            oldValue?.observable.removeObserver(self)
            self.selectedEntity?.observable.addObserver(self)
            selectedRelationship = nil
            if let entity = self.selectedEntity {
                self.relationships = entity.relationships
            } else {
                self.relationships = []
            }
            self.invalidateViews()
        }
    }
    
    private weak var selectedRelationship: Relationship? {
        didSet {
            previousSelectedRelationship = oldValue
            if oldValue === self.selectedRelationship { return }
            invalidateSelectedIndex()
            self.delegate?.relationshipsVC(self, selectedRelationshipDidChange: self.selectedRelationship)
        }
    }
    
    private var relationships: [Relationship] = []
    weak var previousSelectedRelationship: Relationship?
    
    private var acending:Bool = true {
        didSet{ self.invalidateViews() }
    }
    
    private var isSortByDestination = false {
        didSet{ self.invalidateViews() }
    }
    
    weak var delegate: RelationshipsVCDelegate?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func onChange(observable: Observable) {
        if self.selectedEntity?.relationships.count != self.relationships.count {
            self.relationships = (self.selectedEntity?.relationships)!
        }
        self.invalidateViews()
    }
    
    func invalidateViews() {
        if !self.viewLoaded { return }
        updateDestinationList()
        updateItemOrder()
        self.relationshipsView.reloadData()
        invalidateSelectedIndex()
    }
    
    func invalidateSelectedIndex() {
        self.relationshipsView.selectedIndex = self.relationships.indexOf({$0 === self.selectedRelationship})
    }
    
    //MARK: - Update selected relationship after its detail changed
    func updateSelectedRelationship(selectedRelationship: Relationship) {
        self.selectedRelationship = selectedRelationship
        invalidateViews()
    }
    
    func updateDestinationList() {
        self.entityNameList = ["None"]
        self.selectedEntity?.model.entities.forEach{(e) in entityNameList.append(e.name)}
        self.relationshipsView.destinationNames = entityNameList
    }
    
    func updateItemOrder() {
        if selectedEntity == nil { return }
        if acending {
            if isSortByDestination {
                self.relationships = self.selectedEntity!.relationships.sort{
                    if let destination0 = $0.destination, destination1 = $1.destination {
                        return destination0.name < destination1.name
                    } else if let destination0 = $0.destination {
                        return destination0.name < entityNameList[0]
                    } else if let destination1 = $1.destination {
                        return entityNameList[0] < destination1.name
                    } else {
                        return true
                    }
                }
            } else {
                self.relationships = self.selectedEntity!.relationships.sort{ return $0.name < $1.name }
            }
        } else {
            if isSortByDestination {
                self.relationships = self.selectedEntity!.relationships.sort{
                    if let destination0 = $0.destination, destination1 = $1.destination {
                        return destination0.name > destination1.name
                    } else if let destination0 = $0.destination {
                        return destination0.name > entityNameList[0]
                    } else if let destination1 = $1.destination {
                        return entityNameList[0] > destination1.name
                    } else {
                        return true
                    }
                }
            } else {
                self.relationships = self.selectedEntity!.relationships.sort{ return $0.name > $1.name }
            }
        }
    }
    
    //MARK: - RelationshipsViewDataSource
    func numberOfRowsInRelationshipsView(relationshipsView: RelationshipsView) -> Int {
        return self.relationships.count
    }
    
    func relationshipsView(relationshipsView: RelationshipsView, titleForRelationshipAtIndex index: Int) -> String {
        return self.relationships[index].name
    }
    
    func relationshipsView(relationshipsView: RelationshipsView, destinationForRelationshipAtIndex index: Int) -> String {
        if let destination = self.relationships[index].destination {
            return destination.name
        } else {
            return entityNameList[0]
        }
    }
    
    //MAKR: - RelationshipsViewDelegate
    func addRelationshipInRelationshipsView(relationshipsView: RelationshipsView) {
        if self.selectedEntity != nil {
            let relationship = self.selectedEntity!.createRelationship()
            self.relationships.append(relationship)
            self.selectedRelationship = relationship
        }
    }
    
    func relationshipsView(relationshipsView: RelationshipsView, removeRelationshipAtIndex index: Int) {
        let relationship = self.selectedEntity!.relationships[index]
        if relationship === self.selectedRelationship {
            if self.relationships.count <= 1 {
                self.selectedRelationship = nil
            } else if index == self.relationships.count - 1 {
                self.selectedRelationship = self.relationships[index - 1]
            } else {
                self.selectedRelationship = self.relationships[index + 1]
            }
        }
        
        self.selectedEntity!.removeRelationship(relationship)
    }
    
    func relationshipsView(relationshipsView: RelationshipsView, selectedIndexDidChange index: Int?) {
        if let index = index {
            self.selectedRelationship = self.relationships[index]
        } else {
            self.selectedRelationship = nil
        }
    }
    
    func relationshipsView(relationshipsView: RelationshipsView, shouldChangeRelationshipName name: String, atIndex index: Int) -> Bool {
        let relationship = selectedEntity!.relationships[index]
        do {
            try relationship.setName(name)
        } catch {
            Tools.popupAllert("Error", buttonTitile: "OK", informativeText: "Unable to rename relationship: \(relationship.name) to: \(name). There is a relationship with the same name.")
            return false
        }
        return true
    }
    
    func relationshipsView(relationshipsView: RelationshipsView, atIndex index: Int, changeDestination destinationName: String) {
        let destination = selectedEntity?.model.entities.filter({$0.name == destinationName}).first
        self.relationships[index].destination = destination
    }
    
    func relationshipsView(relationshipsView: RelationshipsView, sortByColumnName name: String, ascending: Bool) {
        if previousSelectedRelationship != nil {
            self.selectedRelationship = previousSelectedRelationship
        }
        self.acending = ascending
        self.isSortByDestination = name == RelationshipsView.DESTINATION_COLUMN ? true : false
    }
}