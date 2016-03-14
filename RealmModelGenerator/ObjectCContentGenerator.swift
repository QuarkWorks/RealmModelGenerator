//
//  ObjectCContentGenerator.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/10/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation

class ObjectCContentGenerator: BaseContentGenerator {
    static let TAG = NSStringFromClass(ObjectCContentGenerator)
    
    var hContent = ""
    var mContent = ""
    
    var entity: Entity
    
    init(entity: Entity) {
        self.entity = entity
    }
    
    func getContent() -> (hContent: String, mContent: String) {
        hContent += getHeaderComments(entity, fileExtension: "h")
        
        hContent += "#import <Realm/Realm.h>\n\n"
        hContent += "@interface " + entity.name + " : " + "RLMObject\n\n"
        
        mContent += getHeaderComments(entity, fileExtension: "m")
        mContent += "#import \"" + entity.name + ".h\"\n\n"
        mContent += "@implementation " + entity.name + "\n\n"
        
        appendAttributes()
        hContent += "@end\n"
        hContent += "RLM_ARRAY_TYPE(" + entity.name + ")"
        mContent += "@end\n"
        
        return (hContent, mContent)
    }
    
    //MARK: Append attributes and relicationships
    func appendAttributes() {
        var indexedProperties = ""
        var defaultProperties = ""
        var ignoredProperties = ""
        var requiredProperties = ""
        
        // Append attributes
        for attr in entity.attributes {
            var attrDefination = "@property "
            
            if attr.isRequired {
                attrDefination += attr.type.name(Language.Objc, isRequired: true) + " "
            } else {
                attrDefination += attr.type.name(Language.Objc, isRequired: false)
            }
            
            attrDefination += attr.name + ";\n"
            hContent += attrDefination
            
            // indexed
            if attr.isIndexed {
                indexedProperties += indexedProperties.isEmpty ? "" : "," + attr.name + "\""
            }
            
            // ignored
            if attr.isIgnored {
                ignoredProperties += ignoredProperties.isEmpty ? "" : "," + attr.name + "\""
            }
            
            // required
            if attr.isRequired {
                requiredProperties += requiredProperties.isEmpty ? "" : "," + attr.name + "\""
            }
            
            // default value
            if attr.hasDefault {
                var defaultValue = "@\"" + attr.name + "\" : @"
                
                if attr.type == .String {
                    defaultValue += "\"" + attr.defaultValue + "\""
                } else {
                    defaultValue += attr.defaultValue
                }
                
                defaultProperties += defaultProperties.isEmpty ? "" : "," + defaultValue
                
            }
        }
        
        // Append relationship property
        for relationship in entity.relationships {
            hContent += "@property "
            if relationship.isMany {
                hContent += "RLMArray<" + (relationship.destination?.name)! + ">"
            } else {
                hContent += (relationship.destination?.name)!
            }
            
            hContent += " *" + relationship.name + ";\n"
        }
        
        hContent += "\n"
        
        appendPrimaryKey()
        appendIndexedProperties(indexedProperties)
        appendDefaultPropertyValues(defaultProperties)
        appendIgnoredProperties(ignoredProperties)
        appendRequiredProperties(requiredProperties)
    }
    
    //MARK: Append attributes for property
    func appendIndexedProperties(indexedProperties: String) {
        if indexedProperties.isEmpty {
            return
        }
        
        mContent += "+ (NSArray *)indexedProperties {\n"
        mContent += "\treturn @[" + indexedProperties + "];\n"
        mContent += "}\n\n"
    }
    
    //MARK: Append primary key
    func appendPrimaryKey() {
        let primaryKey = entity.primaryKey
        if primaryKey == nil {
            return
        }
        
        let primaryKeyType: String = primaryKey!.type.name(Language.Objc, isRequired: false)
        
        mContent += "+(" + primaryKeyType + ")primaryKey {\n"
        mContent += "\treturn @\"" + primaryKey!.name + "\";\n"
        mContent += "}\n\n"
    }

    //MARK: Append default property value
    func appendDefaultPropertyValues(defaultProperties: String) {
        if defaultProperties.isEmpty {
            return
        }
        
        mContent += "+ (NSDictionary *)defaultPropertyValues {\n"
        mContent += "\treturn @{" + defaultProperties + "};\n"
        mContent += "}\n\n"
    }
    
    //MARK: Append ignored properties
    func appendIgnoredProperties(ignoredProperties: String) {
        if ignoredProperties.isEmpty {
            return
        }
        
        mContent += "+ (NSArray *)ignoredProperties {\n"
        mContent += "\treturn @[" + ignoredProperties + "];\n"
        mContent += "}\n\n"
    }
    
    //MARK: Append required properties
    func appendRequiredProperties(requiredProperties: String) {
        if requiredProperties.isEmpty {
            return
        }
        
        mContent += "+ (NSArray *)requiredProperties {\n"
        mContent += "\treturn @[" + requiredProperties + "];\n"
        mContent += "}\n\n"
    }
}