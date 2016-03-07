//
//  SwiftContentGenerator.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/7/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation
import AddressBook

class SwiftContentGenerator {
    static let TAG = NSStringFromClass(SwiftContentGenerator)
    
    var content = ""
    var entity: Entity
    
    init(entity: Entity) {
        self.entity = entity
    }
    
    func getContent()->String
    {
        appendHeader()
        appendAttributes()
        appendPrimaryKey()
        
        content += "}"
        return content
    }
    
    //MARK: Append header
    func appendHeader()
    {
        appendHeaderComments()
        
        // Static import
        content += "import RealmSwift\n\n"
        content += "class " + entity.name + " : Object {\n"
        content += "    static let TAG = NSStringFromClass(" + entity.name + ");\n\n"
    }
    
    func appendHeaderComments() {
        content += "/**\n"
        content += " *\t" + entity.name + ".swift\n"
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
            }
            
            content += ". All rights reserved.\n"
        }
        
        content += " *\tModel file Generated using Realm Model Genrator.\n"
        content += " */\n\n"
    }
    
    //MARK: Append attributes and relicationships
    func appendAttributes()
    {
        // Append attributes
        for (_, (_, attr)) in entity.attributesByName.enumerate() {
            var attrDefination = ""
            
            //Get attribute defination
            if attr.hasDefault {
                attrDefination += "dynamic var " + attr.name + " : " + attr.type.rawValue + " = "
                    + attr.defaultValue
            } else {
                attrDefination += "dynamic var " + attr.name + " : " + attr.type.rawValue
            }
            
            content += "    " + attrDefination
            content += "\n"
        }
        
        // Append relationship
        for (_, relationship) in entity.relationshipsByName {
            var relationshipDefination = ""
            if relationship.isMany {
                relationshipDefination += "dynamic var " + relationship.name + " = " + "RLMArray(objectClassName: " + relationship.destination!.name + ".className())"
            } else {
                relationshipDefination += "dynamic var " + relationship.name + " : " + relationship.destination!.name
            }
            content += "    " + relationshipDefination + "\n";
        }
        
        content += "\n"
    }
    
    //MARK: Append primary key
    func appendPrimaryKey()
    {
        if let primarykey = entity.primaryKey {
            content += "    override class func primaryKey() -> " + primarykey.type.rawValue + "\n"
            content += "    {\n"
            content += "        return \"" + primarykey.name + "\"\n    }\n"
        }
    }
    
    // Returns the current year as String
    func getYear() -> String
    {
        return "\(NSCalendar.currentCalendar().component(.Year, fromDate: NSDate()))"
    }
    
    // Returns today date in the format dd/mm/yyyy
    func getTodayFormattedDay() -> String
    {
        let components = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: NSDate())
        return "\(components.day)/\(components.month)/\(components.year)"
    }
}