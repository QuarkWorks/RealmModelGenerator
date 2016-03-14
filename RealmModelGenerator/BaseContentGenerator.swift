//
//  ContentGenerator.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/14/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation
import AddressBook

class BaseContentGenerator {
<<<<<<< e66f80e86b1829a9faa7d2d738c8f6ffcd14e0d2
    
    // Check if an enity is valid or not, if not, print out error
    // TODO: provide user with a popup with details of invalid entity
    func isValidEntity(entity: Entity) -> Bool {
        do {
            return try validEntity(entity)
        } catch GeneratorError.InvalidAttribteType(let attribute){
            print("Entity \(entity.name) attribute \(attribute.name) has an unknown type.")
            let alert = NSAlert()
            alert.messageText = "Error"
            alert.addButtonWithTitle("OK")
            alert.informativeText = "Entity \(entity.name) attribute \(attribute.name) has an unknown type."
            alert.runModal()

        } catch GeneratorError.InvalidRelationshiDestination(let relationship) {
            print("Entity \(entity.name) relationship \(relationship.name) has an unknown destination.")
            let alert = NSAlert()
            alert.messageText = "Error"
            alert.addButtonWithTitle("OK")
            alert.informativeText = "Entity \(entity.name) relationship \(relationship.name) has an unknown destination."
            alert.runModal()
        } catch {
            print("Invalid entity \(entity.name)")
            let alert = NSAlert()
            alert.messageText = "Error"
            alert.addButtonWithTitle("OK")
            alert.informativeText = "Invalid entity \(entity.name)"
            alert.runModal()
        }
        
        return false
    }
    
    func validEntity(entity: Entity) throws -> Bool {
        // Check unknown attribute
        for attribute in entity.attributes {
            if attribute.type == AttributeType.Unknown {
                throw GeneratorError.InvalidAttribteType(attribute: attribute)
            }
        }
        
        // Check unknown relationship desitnation
        for relationship in entity.relationships {
            guard let _: Entity = relationship.destination else {
                throw GeneratorError.InvalidRelationshiDestination(relationship: relationship)
            }
        }
        
        return true
    }
=======
>>>>>>> Added BaseContentGenerator
 
    func getHeaderComments(entity: Entity, fileExtension: String) -> String {
        var content = ""
        content += "/**\n"
        content += " *\t" + entity.name + "." + fileExtension + "\n"
        content += " *\tModel version: " + entity.model.version + "\n"
        
        if let me = ABAddressBook.sharedAddressBook()?.me(){
            
            if let firstName = me.valueForProperty(kABFirstNameProperty as String) as? String{
                content += " *\tCreate by \(firstName)"
                if let lastName = me.valueForProperty(kABLastNameProperty as String) as? String{
                    content += " \(lastName)"
                }
            }
            
            content += " on \(getTodayFormattedDay())\n *\tCopyright © \(getYear())"
            
            if let organization = me.valueForProperty(kABOrganizationProperty as String) as? String{
                content += " \(organization)"
            } else {
                content += " QuarkWorks"
            }
            
            content += ". All rights reserved.\n"
        }
        
        content += " *\tModel file Generated using Realm Model Generator.\n"
        content += " */\n\n"
        
        return content
    }
    
    // Returns the current year as String
<<<<<<< e66f80e86b1829a9faa7d2d738c8f6ffcd14e0d2
    func getYear() -> String {
=======
    func getYear() -> String
    {
>>>>>>> Added BaseContentGenerator
        return "\(NSCalendar.currentCalendar().component(.Year, fromDate: NSDate()))"
    }
    
    // Returns today date in the format dd/mm/yyyy
<<<<<<< e66f80e86b1829a9faa7d2d738c8f6ffcd14e0d2
    func getTodayFormattedDay() -> String {
=======
    func getTodayFormattedDay() -> String
    {
>>>>>>> Added BaseContentGenerator
        let components = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: NSDate())
        return "\(components.day)/\(components.month)/\(components.year)"
    }

<<<<<<< e66f80e86b1829a9faa7d2d738c8f6ffcd14e0d2
=======
    
>>>>>>> Added BaseContentGenerator
}