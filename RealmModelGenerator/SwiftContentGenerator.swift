//
//  SwiftContentGenerator.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/7/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation

class SwiftContentGenerator: BaseContentGenerator {
    static let TAG = NSStringFromClass(SwiftContentGenerator.self)
    
    private var content = ""
    private var entity: Entity
    
    init(entity: Entity) {
        self.entity = entity
    }
    
    func getContent() -> Array<String> {
        
        if isValidEntity(entity: entity) {
            appendHeader()
            appendRealmKeys()
            appendAttributes()
        }
        
        return [content]
    }
    
    // MARK: - Append header
    func appendHeader() {
        content += getHeaderComments(entity: entity, fileExtension: "swift")
        
        content += "import RealmSwift\n\n"
        content += "class " + entity.name + ": \(entity.superEntity?.name ?? "Object") {\n"
        content += "\tstatic let TAG = NSStringFromClass(" + entity.name + ");\n"
    }
    
    // MARK: - Append RealmKeys
    func appendRealmKeys() {
        for attr in entity.attributes {
            var realmKey = "\n"
            realmKey += "\tstatic let " + getAllCapitalizedKeyName(name: attr.name) + " = \"" + attr.name + "\""
            content += realmKey
        }
        
        content += "\n\n"
    }
    
    // MARK: - Append attributes and relationships
    func appendAttributes() {
        var indexedProperties = ""
        var ignoredProperties = ""
        
        // Append attributes
        for attr in entity.attributes {
            var attrDefinition = ""
            let primaryKey = self.entity.primaryKey
            
            // we treat required attribute as non-option one.
            if (attr.isRequired || attr.hasDefault || (primaryKey != nil && attr === primaryKey!)) {
                if attr.hasDefault {
                    attrDefinition += "\tdynamic var " + attr.name + attr.type.name(language: .Swift, isRequired: true) + " = " + attr.defaultValue
                    // handle empty string default
                    if attr.defaultValue == "" {
                        attrDefinition += "\"\""
                    }
                } else {
                    attrDefinition += "\tdynamic var " + attr.name + attr.type.name(language: .Swift, isRequired: true) + " = "
                    switch attr.type {
                    case .Bool:
                        attrDefinition += "false"
                        break
                    case .Int:
                        attrDefinition += "0"
                        break
                    case .Short:
                        attrDefinition += "0"
                        break
                    case .Long:
                        attrDefinition += "0"
                        break
                    case .Float:
                        attrDefinition += "0.0"
                        break
                    case .Double:
                        attrDefinition += "0.0"
                        break
                    case .String:
                        attrDefinition += "\"\""
                        break
                    case .Blob:
                        attrDefinition += "NSData()"
                        break
                    case .Date:
                        attrDefinition += "NSDate()"
                    default:
                        //TODO: throw error
                        break
                    }
                }
            } else if (attr.type == .Bool || attr.type == .Int || attr.type == .Short || attr.type == .Long || attr.type == .Float || attr.type == .Double){
                attrDefinition += "\tlet " + attr.name + " = RealmOptional<" + attr.type.name(language: .Swift, isRequired: false) + ">()"
            } else {
                attrDefinition += "\tdynamic var " + attr.name + attr.type.name(language: .Swift, isRequired: false) + " = nil"
            }
            
            content += attrDefinition
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
            var relationshipDefinition = ""
            
            if relationship.isMany {
                relationshipDefinition += "\tlet " + relationship.name + " = List<" + relationship.destination!.name + ">()\n"
                
            } else {
                relationshipDefinition += "\tdynamic var " + relationship.name + " : " + relationship.destination!.name + "? \n"
            }
            
            content += relationshipDefinition;
        }
        
        content += "\n"
        
        appendPrimaryKey()
        appendIndexedProperties(indexProperties: indexedProperties)
        appendIgnoredProperties(ignoredProperties: ignoredProperties)
        
        content += "}"
    }
    
    // MARK: - Append primary key
    func appendPrimaryKey() {
        if let primarykey = entity.primaryKey {
            content += "\toverride static func primaryKey() -> String? {\n"
            content += "\t\treturn \"" + primarykey.name + "\"\n"
            content += "\t}\n\n"
        }
    }
    
    // MARK: - Append indexed property
    func appendIndexedProperties(indexProperties: String) {
        if indexProperties.isEmpty {
            return
        }
        
        content += "\toverride static func indexedProperties() -> [String] {\n"
        content += "\t\treturn [" + indexProperties + "]\n"
        content += "\t}\n\n"
    }
    
    // MARK: - Append ignored property
    func appendIgnoredProperties(ignoredProperties: String) {
        if ignoredProperties.isEmpty {
            return
        }
        
        content += "\toverride static func ignoredProperties() -> [String] {\n"
        content += "\t\treturn [" + ignoredProperties + "]\n"
        content += "\t}\n\n"
    }
}
