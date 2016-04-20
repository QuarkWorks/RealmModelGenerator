//
//  SwiftContentGenerator.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/7/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation

class SwiftContentGenerator: BaseContentGenerator {
    static let TAG = NSStringFromClass(SwiftContentGenerator)
    
    private var content = ""
    private var entity: Entity
    
    init(entity: Entity) {
        self.entity = entity
    }
    
    func getContent() -> Array<String> {
        
        if isValidEntity(entity) {
            appendHeader()
            appendAttributes()
        }
        
        return [content]
    }
    
    //MARK: - Append header
    func appendHeader() {
        content += getHeaderComments(entity, fileExtension: "swift")
        
        content += "import RealmSwift\n\n"
        content += "class " + entity.name + ": \(entity.superEntity?.name ?? "Object") {\n"
        content += "\tstatic let TAG = NSStringFromClass(" + entity.name + ");\n\n"
    }
    
    //MARK: - Append attributes and relicationships
    func appendAttributes() {
        var indexedProperties = ""
        var ignoredProperties = ""
        
        // Append attributes
        for attr in entity.attributes {
            var attrDefination = ""
            let primaryKey = self.entity.primaryKey
            
            // we treat required attribute as non-option one.
            if (attr.isRequired || (primaryKey != nil && attr === primaryKey!)) {
                if attr.hasDefault {
                    attrDefination += "\tdynamic var " + attr.name + attr.type.name(Language.Swift, isRequired: true) + " = " + attr.defaultValue
                    // handle empty string default
                    if attr.defaultValue == "" {
                        attrDefination += "\"\""
                    }
                } else {
                    attrDefination += "\tdynamic var " + attr.name + attr.type.name(Language.Swift, isRequired: true) + " = "
                    switch attr.type {
                    case .Bool:
                        attrDefination += "false"
                        break
                    case .Int:
                        attrDefination += "0"
                        break
                    case .Short:
                        attrDefination += "0"
                        break
                    case .Long:
                        attrDefination += "0"
                        break
                    case .Float:
                        attrDefination += "0.0"
                        break
                    case .Double:
                        attrDefination += "0.0"
                        break
                    case .String:
                        attrDefination += "\"\""
                        break
                    case .Blob:
                        attrDefination += "NSData()"
                        break
                    case .Date:
                        attrDefination += "NSDate()"
                    default:
                        //TODO: throw error
                        break
                    }
                }
            } else if (attr.type == .Bool || attr.type == .Int || attr.type == .Short || attr.type == .Long || attr.type == .Float || attr.type == .Double){
                attrDefination += "\tlet " + attr.name + " = RealmOptional<" + attr.type.name(Language.Swift, isRequired: false) + ">()"
            } else {
                attrDefination += "\tdynamic var " + attr.name + attr.type.name(Language.Swift, isRequired: false) + " = nil"
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
        
        content += "}"
    }
    
    //MARK: Append primary key
    func appendPrimaryKey() {
        if let primarykey = entity.primaryKey {
            content += "\toverride static func primaryKey() -> String? {\n"
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