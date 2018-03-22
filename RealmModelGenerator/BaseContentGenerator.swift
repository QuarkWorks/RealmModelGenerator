//
//  BaseContentGenerator.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/14/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation
import AddressBook

class BaseContentGenerator {
    
    // MARK: - Check if entity is valid or not
    func isValidEntity(entity: Entity) -> Bool {
        do {
            return try validEntity(entity: entity)
        } catch GeneratorError.InvalidAttributeType(let attribute){
            Tools.popupAlert(messageText: "Error", buttonTitle: "OK", informativeText: "Entity \(entity.name) attribute \(attribute.name) has an unknown type.")
        } catch GeneratorError.InvalidRelationshipDestination(let relationship) {
            Tools.popupAlert(messageText: "Error", buttonTitle: "OK", informativeText: "Entity \(entity.name) relationship \(relationship.name) has an unknown destination.")
        } catch {
            Tools.popupAlert(messageText: "Error", buttonTitle: "OK", informativeText: "Invalid entity \(entity.name)")
        }
        
        return false
    }
    
    func validEntity(entity: Entity) throws -> Bool {
        // Check unknown attribute
        for attribute in entity.attributes {
            if attribute.type == .Unknown {
                throw GeneratorError.InvalidAttributeType(attribute: attribute)
            }
        }
        
        // Check unknown relationship destination
        for relationship in entity.relationships {
            guard let _: Entity = relationship.destination else {
                throw GeneratorError.InvalidRelationshipDestination(relationship: relationship)
            }
        }
        
        return true
    }
    
    // MARK: - Get header comments
    func getHeaderComments(entity: Entity, fileExtension: String) -> String {
        var content = ""
        content += "/**\n"
        content += " *\t" + entity.name + "." + fileExtension + "\n"
        content += " *\tModel version: " + entity.model.version + "\n"
        
        if let me = ABAddressBook.shared()?.me(){
            
            if let firstName = me.value(forProperty: kABFirstNameProperty as String) as? String{
                content += " *\tCreate by \(firstName)"
                if let lastName = me.value(forProperty: kABLastNameProperty as String) as? String{
                    content += " \(lastName)"
                }
            }
            
            content += " on \(getTodayFormattedDay())\n *\tCopyright © \(getYear())"
            
            if let organization = me.value(forProperty: kABOrganizationProperty as String) as? String{
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
        return "\(Calendar.current.component(.year, from: Date()))"
    }
    
    // Returns today date in the format dd/mm/yyyy
    func getTodayFormattedDay() -> String {
        let components = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        return "\(components.day!)/\(components.month!)/\(components.year!)"
    }
    
    // MARK: - Get all capitalized key name
    func getAllCapitalizedKeyName(name: String) -> String {
        var result = ""
        
        for c in name {
            if ("A"..."Z").contains(c) {
                result.append("_")
            }
            
            result.append(c)
        }
        
        return result.uppercased()
    }
}
