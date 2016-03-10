//
//  Tools.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/10/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation
import AddressBook

class Tools {
    static let TAG = NSStringFromClass(Tools)

    static func getHeaderComments(entity: Entity, fileExtension: String) -> String {
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
        
        content += " *\tModel file Generated using Realm Model Genrator.\n"
        content += " */\n\n"
        
        return content
    }

    // Returns the current year as String
    static func getYear() -> String
    {
        return "\(NSCalendar.currentCalendar().component(.Year, fromDate: NSDate()))"
    }
    
    // Returns today date in the format dd/mm/yyyy
    static func getTodayFormattedDay() -> String
    {
        let components = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: NSDate())
        return "\(components.day)/\(components.month)/\(components.year)"
    }
    
}

//Reference: http://stackoverflow.com/a/28288340
extension String {
    var first: String {
        return String(characters.prefix(1))
    }
    var last: String {
        return String(characters.suffix(1))
    }
    var uppercaseFirst: String {
        return first.uppercaseString + String(characters.dropFirst())
    }
}