//
//  ObjectCContentGenerator.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/10/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation

class ObjectCContentGenerator {
    static let TAG = NSStringFromClass(ObjectCContentGenerator)
    
    var hContent = ""
    var mContent = ""
    
    var entity: Entity
    
    init(entity: Entity) {
        self.entity = entity
    }
    
    func getContent() -> (hContent: String, mContent: String) {
        hContent += Tools.getHeaderComments(entity, fileExtension: "h")
        hContent += "#import <Realm/Realm.h>\n\n"
        hContent += "@interface " + entity.name + " : " + "RLMObject\n\n"
        
        mContent += Tools.getHeaderComments(entity, fileExtension: "m")
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
            var attrDefination = "@property " + attr.type.objectCName + " "
            
            if attr.type == .String {
                attrDefination += "* "
            }
            
            attrDefination += attr.name + ";\n"
            hContent += attrDefination
            
            // indexed
            if attr.isIndexed {
                if indexedProperties.isEmpty {
                    indexedProperties += "@\"" + attr.name + "\""
                } else {
                    indexedProperties += ", @\"" + attr.name + "\""
                }
            }
            
            // default value
            if attr.hasDefault {
                var defaultValue = "@\"" + attr.name + "\" : @"
                
                
                if attr.type == .String {
                    defaultValue += "\"" + attr.defaultValue + "\""
                } else {
                    defaultValue += attr.defaultValue
                }
                
                if defaultProperties.isEmpty {
                    defaultProperties += defaultValue
                } else {
                    defaultProperties += ", " + defaultValue
                }
                
            }
            
            // ignored
            if attr.isIgnored {
                if ignoredProperties.isEmpty {
                    ignoredProperties += "@\"" + attr.name + "\""
                } else {
                    ignoredProperties += ", @\"" + attr.name + "\""
                }
            }
            
            if attr.isRequired {
                if requiredProperties.isEmpty {
                    requiredProperties += "@\"" + attr.name + "\""
                } else {
                    requiredProperties += ", @\"" + attr.name + "\""
                }
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
            
            hContent += " * " + relationship.name + ";\n"
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
        
        mContent += "+(\((primaryKey?.type.objectCName)!) *)primaryKey {\n"
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

extension AttributeType {
    var objectCName:Swift.String {
        get {
            switch (self) {
                case .Bool:
                    return "BOOL"
                case .Short:
                    return "NSInteger"
                case .Int:
                    return "NSInteger"
                case .Long:
                    return "NSInteger"
                case .Float:
                    return "CGFloat"
                case .Double:
                    return "double"
                case .String:
                    return "NSString"
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