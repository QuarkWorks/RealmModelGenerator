//
//  SwiftContentGenerator.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/7/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation

class SwiftContentGenerator {
    static let TAG = NSStringFromClass(SwiftContentGenerator)
    
    var content = ""
    var entity: Entity
    
    init(entity: Entity) {
        self.entity = entity
    }
    
    func getContent() -> String {
        content += Tools.getHeaderComments(entity, fileExtension: "swift")
        
        content += "import RealmSwift\n\n"
        content += "class " + entity.name + ": Object {\n"
        content += "\tstatic let TAG = NSStringFromClass(" + entity.name + ");\n\n"
        
        appendAttributes()
        
        content += "}"
        
        return content
    }
    
    //MARK: Append attributes and relicationships
    func appendAttributes() {
        var indexedProperties = ""
        var ignoredProperties = ""
        
        // Append attributes
        for attr in entity.attributes {
            var attrDefination = "\tdynamic var " + attr.name + " : " + attr.type.swiftName
            
            if (attr.type == .String || attr.type == .Date || attr.type == .Blob) && !attr.isRequired && !attr.hasDefault {
                attrDefination += "? = nil"
            }
            
            if attr.hasDefault {
                if attr.type == .String {
                    attrDefination += " = \"" + attr.defaultValue + "\""
                } else {
                    attrDefination += " = " + attr.defaultValue
                }
            }
            
            content += attrDefination
            content += "\n"
            
            if attr.isIndexed {
                if indexedProperties.isEmpty {
                    indexedProperties += "\"" + attr.name + "\""
                } else {
                    indexedProperties += ", \"" + attr.name + "\""
                }
            }
            
            if attr.isIgnored {
                if ignoredProperties.isEmpty {
                    ignoredProperties += "\"" + attr.name + "\""
                } else {
                    ignoredProperties += ", \"" + attr.name + "\""
                }
            }
        }
        
        // Append relationship
        for relationship in entity.relationships {
            var relationshipDefination = ""
            
            if relationship.isMany {
                relationshipDefination += "\tlet " + relationship.name + " = List<" + relationship.destination!.name + ">()\n"
                
            } else {
                relationshipDefination += "\tdynamic var " + relationship.name + " : " + relationship.destination!.name + "? \n"
            }
            
            content += relationshipDefination;
        }
        
        content += "\n"
        
        appendPrimaryKey()
        appendIndexedProperties(indexedProperties)
        appendIgnoredProperties(ignoredProperties)
    }
    
    //MARK: Append primary key
    func appendPrimaryKey() {
        if let primarykey = entity.primaryKey {
            content += "\toverride class func primaryKey() -> String? {\n"
            content += "\t\treturn \"" + primarykey.name + "\"\n"
            content += "\t}\n\n"
        }
    }
    
    //MARK: Append indexed property
    func appendIndexedProperties(indexProperties: String) {
        if indexProperties.isEmpty {
            return
        }
        
        content += "\toverride static func indexedProperties() -> [String] {\n"
        content += "\t\treturn [" + indexProperties + "]\n"
        content += "\t}\n\n"
    }
    
    //MARK: Append ignored property
    func appendIgnoredProperties(ignoredProperties: String) {
        if ignoredProperties.isEmpty {
            return
        }
        
        content += "\toverride static func ignoredProperties() -> [String] {\n"
        content += "\t\treturn [" + ignoredProperties + "]\n"
        content += "\t}\n\n"
    }
}

extension AttributeType {
    var swiftName:Swift.String {
        get {
            switch (self) {
                case .Bool:
                    return "Bool"
                case .Short:
                    return "Int"
                case .Int:
                    return "Int"
                case .Long:
                    return "Int"
                case .Float:
                    return "Float"
                case .Double:
                    return "Double"
                case .String:
                    return "String"
                case .Date:
                    return "NSDate"
                case .Blob:
                    return "NSData"
                default:
                    return "<Unknown>"
            }
        }
    }
}