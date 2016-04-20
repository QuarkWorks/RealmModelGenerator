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
    
    //MARK: - Check if entity is valid or not
    func isValidEntity(entity: Entity) -> Bool {
        do {
            return try validEntity(entity)
        } catch GeneratorError.InvalidAttribteType(let attribute){
            Tools.popupAllert("Error", buttonTitile: "OK", informativeText: "Entity \(entity.name) attribute \(attribute.name) has an unknown type.")
        } catch GeneratorError.InvalidRelationshiDestination(let relationship) {
            Tools.popupAllert("Error", buttonTitile: "OK", informativeText: "Entity \(entity.name) relationship \(relationship.name) has an unknown destination.")
        } catch {
            Tools.popupAllert("Error", buttonTitile: "OK", informativeText: "Invalid entity \(entity.name)")
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
    
    //MARK: - Get header comments
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
    func getYear() -> String {
        return "\(NSCalendar.currentCalendar().component(.Year, fromDate: NSDate()))"
    }
    
    // Returns today date in the format dd/mm/yyyy
    func getTodayFormattedDay() -> String {
        let components = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: NSDate())
        return "\(components.day)/\(components.month)/\(components.year)"
    }
    
}