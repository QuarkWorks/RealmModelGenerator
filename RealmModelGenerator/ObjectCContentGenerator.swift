//
//  ObjectCContentGenerator.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/10/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

//  --:MARK:--
//  KILL THIS FEATURE
//

import Foundation

class ObjectCContentGenerator: BaseContentGenerator {
    static let TAG = NSStringFromClass(ObjectCContentGenerator.self)
    
    private var hContent = ""
    private var mContent = ""
    
    private var entity: Entity
    
    init(entity: Entity) {
        self.entity = entity
    }
    
    func getContent() -> Array<String> {
        
        if isValidEntity(entity: entity) {
            appendHeader()
            appendAttributes()
        }
        
        return [hContent, mContent]
    }
    
    // MARK: - Append header
    func appendHeader() {
        hContent += getHeaderComments(entity: entity, fileExtension: "h")
        
        hContent += "#import <Realm/Realm.h>\n\n"
        hContent += "@interface " + entity.name + " : " + "RLMObject\n\n"
        if let superClass = self.entity.superEntity {
            hContent += "@property " + superClass.name + " *\(superClass.name.lowercaseFirst);\n"
        }
        
        mContent += getHeaderComments(entity: entity, fileExtension: "m")
        mContent += "#import \"" + entity.name + ".h\"\n\n"
        mContent += "@implementation " + entity.name + "\n\n"

    }
    
    // MARK: - Append attributes and relationships
    func appendAttributes() {
        var indexedProperties = ""
        var defaultProperties = ""
        var ignoredProperties = ""
        var requiredProperties = ""
        
        // Append attributes
        for attr in entity.attributes {
            var attrDefinition = "@property "
            
            // required
            attrDefinition += attr.type.name(language: .Objc, isRequired: attr.isRequired)
            
            attrDefinition += attr.name + ";\n"
            hContent += attrDefinition
            
            // indexed
            if attr.isIndexed {
                indexedProperties += indexedProperties.isEmpty ? "" : ","
                indexedProperties += "@\"" + attr.name + "\""
            }
            
            // ignored
            if attr.isIgnored {
                ignoredProperties += ignoredProperties.isEmpty ? "" : ","
                ignoredProperties += "@\"" + attr.name + "\""
            }
            
            // required
            if attr.isRequired {
                requiredProperties += requiredProperties.isEmpty ? "" : ","
                requiredProperties += "@\"" + attr.name + "\""
            }
            
            // default value
            if attr.hasDefault {
                var defaultValue = "@\"" + attr.name + "\" : @"
                
                if attr.type == .String {
                    defaultValue += "\"" + attr.defaultValue + "\""
                } else {
                    defaultValue += attr.defaultValue
                }
                
                defaultProperties += defaultProperties.isEmpty ? "" : ","
                defaultProperties += defaultValue
            }
        }
        
        // Append relationship property
        for relationship in entity.relationships {
            hContent += "@property "
            if relationship.isMany {
                hContent += "RLMArray<\(relationship.destination!.name) *><\(relationship.destination!.name)>"
            } else {
                hContent += (relationship.destination?.name)!
            }
            
            hContent += " *" + relationship.name + ";\n"
        }
        
        hContent += "\n"
        
        appendPrimaryKey()
        appendIndexedProperties(indexedProperties: indexedProperties)
        appendDefaultPropertyValues(defaultProperties: defaultProperties)
        appendIgnoredProperties(ignoredProperties: ignoredProperties)
        appendRequiredProperties(requiredProperties: requiredProperties)
        
        print(mContent)
        hContent += "@end\n"
        hContent += "RLM_ARRAY_TYPE(" + entity.name + ")"
        mContent += "@end\n"
    }
    
    // MARK: - Append attributes for property
    func appendIndexedProperties(indexedProperties: String) {
        if indexedProperties.isEmpty {
            return
        }
        
        mContent += "+ (NSArray *)indexedProperties {\n"
        mContent += "\treturn @[" + indexedProperties + "];\n"
        mContent += "}\n\n"
    }
    
    // MARK: - Append primary key
    func appendPrimaryKey() {
        let primaryKey = entity.primaryKey
        if primaryKey == nil {
            return
        }
        
        let primaryKeyType: String = primaryKey!.type.name(language: .Objc, isRequired: false)
        
        mContent += "+(" + primaryKeyType + ")primaryKey {\n"
        mContent += "\treturn @\"" + primaryKey!.name + "\";\n"
        mContent += "}\n\n"
    }

    // MARK: - Append default property value
    func appendDefaultPropertyValues(defaultProperties: String) {
        if defaultProperties.isEmpty {
            return
        }
        
        mContent += "+ (NSDictionary *)defaultPropertyValues {\n"
        mContent += "\treturn @{" + defaultProperties + "};\n"
        mContent += "}\n\n"
    }
    
    // MARK: - Append ignored properties
    func appendIgnoredProperties(ignoredProperties: String) {
        if ignoredProperties.isEmpty {
            return
        }
        
        mContent += "+ (NSArray *)ignoredProperties {\n"
        mContent += "\treturn @[" + ignoredProperties + "];\n"
        mContent += "}\n\n"
    }
    
    // MARK: - Append required properties
    func appendRequiredProperties(requiredProperties: String) {
        if requiredProperties.isEmpty {
            return
        }
        
        mContent += "+ (NSArray *)requiredProperties {\n"
        mContent += "\treturn @[" + requiredProperties + "];\n"
        mContent += "}\n\n"
    }
}
