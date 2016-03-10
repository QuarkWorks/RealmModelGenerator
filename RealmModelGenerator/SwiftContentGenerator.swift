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
    
    func getContent() -> String
    {
        appendHeader()
        appendAttributesAndAnnotations()
        
        content += "}"
        
        return content
    }
    
    //MARK: Append header
    func appendHeader()
    {
        content += Tools.getHeaderComments(entity, fileExtension: "swift")
        
        // Static import
        content += "import RealmSwift\n\n"
        content += "class " + entity.name + " : Object {\n"
        content += "  static let TAG = NSStringFromClass(" + entity.name + ");\n\n"
    }
    
    //MARK: Append attributes and relicationships
    func appendAttributesAndAnnotations()
    {
        var indexedProperties = ""
        var ignoredProperties = ""
        
        // Append attributes
        for (_, (_, attr)) in entity.attributesByName.enumerate() {
            var attrDefination = "dynamic var " + attr.name + " : " + attr.type.rawValue
            
            if !attr.isRequired {
                attrDefination += "?"
            }
            
            if attr.hasDefault {
                attrDefination += " = " + attr.defaultValue
            }
            
            content += "  " + attrDefination
            content += "\n"
            
            if attr.isIndexd {
                if indexedProperties.isEmpty {
                    indexedProperties += "\"" + attr.name + "\""
                } else {
                    indexedProperties += ",\"" + attr.name + "\""
                }
            }
            
            if attr.isIgnored {
                if ignoredProperties.isEmpty {
                    ignoredProperties += "\"" + attr.name + "\""
                } else {
                    ignoredProperties += ",\"" + attr.name + "\""
                }
            }
        }
        
        // Append relationship
        for (_, relationship) in entity.relationshipsByName {
            var relationshipDefination = "dynamic var " + relationship.name
            
            if relationship.isMany {
                relationshipDefination += " = " + "RLMArray(objectClassName: " + relationship.destination!.name + ".className())"
            } else {
                relationshipDefination += " : " + relationship.destination!.name
            }
            
            content += "  " + relationshipDefination + "\n";
        }
        
        content += "\n"
        
        appendPrimaryKey()
        appendIndexedProperties(indexedProperties)
        appendIgnoredProperties(ignoredProperties)
    }
    
    //MARK: Append primary key
    func appendPrimaryKey()
    {
        if let primarykey = entity.primaryKey {
            content += "  override class func primaryKey() -> " + primarykey.type.rawValue + "? {\n"
            content += "    return \"" + primarykey.name + "\"\n"
            content += "  }\n\n"
        }
    }
    
    //MARK: Append indexed property
    func appendIndexedProperties(indexProperties: String)
    {
        
        if indexProperties.isEmpty {
            return
        }
        
        content += "  override static func indexedProperties() -> [String] {\n"
        content += "    return [" + indexProperties + "]\n"
        content += "  }\n\n"
    }
    
    //MARK: Append ignored property
    func appendIgnoredProperties(ignoredProperties: String)
    {
        if ignoredProperties.isEmpty {
            return
        }
        
        content += "  override static func ignoredProperties() -> [String] {\n"
        content += "    return [" + ignoredProperties + "]\n"
        content += "  }\n\n"
    }
}