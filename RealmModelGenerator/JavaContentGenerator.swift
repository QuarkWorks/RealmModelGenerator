//
//  FileContentGenerator.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/6/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation

class JavaContentGenerator {
    static let TAG = NSStringFromClass(JavaContentGenerator)
    
    var content = ""
    var entity: Entity
    
    init(entity: Entity) {
        self.entity = entity
    }
    
    func getContent() -> String {
        appendHeader()
        appendRealmKeys()
        appendAttributes()
        appendGettersAndSetters()
        
        return content
    }
    
    //MARK: Append header
    func appendHeader() {
        content += Tools.getHeaderComments(entity, fileExtension: "java")
        
        content += "import io.realm.*;\nimport io.realm.annotations.*;\n"
        if (importDate()) {
            content += "import java.util.Date;\n"
        }
        content += "\npublic class " + entity.name + " extends RealmObject {\n"
        content += "    private static final String TAG = " + entity.name + ".class.getSimpleName();\n\n"
    }
    
    //MARK: Append RealmKeys
    func appendRealmKeys() {
        content += "    public static final class RealmKeys {"
        
        for attr in entity.attributes {
            var realmKey = "\n"
            realmKey += "        public static final String " + attr.name.uppercaseString + "_KEY = \"" + attr.name.lowercaseString + "\";"
            content += realmKey
        }
        
        content += "\n    }\n\n"
    }
    
    //MARK: Append attributes and relicationships
    func appendAttributes() {
        let primarykey = entity.primaryKey
        
        // Append attributes
        for attr in entity.attributes {
            var attrAnnotions = ""
            var attrDefination = ""
            
            //Get attribute annotions
            if primarykey?.name == attr.name {
                attrAnnotions += "@PrimaryKey\n"
            }
            
            if attr.isIndexed && primarykey?.name != attr.name {
                attrAnnotions += "@Index\n"
            }
            
            if attr.isIgnored {
                attrAnnotions += "@Ignore\n"
            }
            
            if attr.isRequired {
                attrAnnotions += "@Require\n"
            }
            
            //Get attribute defination
            attrDefination += "private " + attr.type.javaName + " " + attr.name
            if attr.hasDefault {
                if attr.type == .String {
                    attrDefination += " = \"" + attr.defaultValue + "\";\n"
                } else {
                    attrDefination += " = " + attr.defaultValue + ";\n"
                }
            }
            
            if !attrAnnotions.isEmpty {
                content += "    " + attrAnnotions
            }
            
            content += "    " + attrDefination
            content += "\n"
        }
        
        // Append relationship
        for relationship in entity.relationships {
            var relationshipDefination = ""
            if relationship.isMany {
                relationshipDefination += "private RealmList<" + relationship.destination!.name + "> " + relationship.name
            } else {
                relationshipDefination += "private " + relationship.destination!.name + " " + relationship.name
            }
            content += "    " + relationshipDefination + "\n";
        }
        
        content += "\n"
    }
    
    //MARK: Append Getters and Setters
    func appendGettersAndSetters() {
        // Append attribute Getters and Setters
        for attr in entity.attributes {
            var getter = "    "
            var setter = "    "
            
            getter += "public " + attr.type.javaName + " get" + attr.name.uppercaseFirst + "(){\n"
            getter += "        return " + attr.name + ";\n    }\n\n"
            
            setter += "public void set" + attr.name.uppercaseFirst + "(" + attr.type.javaName + " " + attr.name + "){\n"
            setter += "        this." + attr.name + " = " + attr.name + ";\n    }\n\n"
            
            content += getter
            content += setter
        }
        
        // Append relationship Getters and Setters
        for relationship in entity.relationships {
            var getter = "    "
            var setter = "    "
            
            if relationship.isMany {
                getter += "public RealmList<" + relationship.destination!.name + "> get" + relationship.name.uppercaseFirst + "(){\n"
                getter += "        return " + relationship.name + ";\n    }\n\n"
                
                setter += "public void set" + relationship.name.uppercaseFirst + "(RealmList<" + relationship.destination!.name + "> " + relationship.name + "){\n"
                setter += "        this." + relationship.name + " = " + relationship.name + ";\n    }\n\n"
            } else {
                getter += "public " + relationship.destination!.name + " get" + relationship.name.uppercaseFirst + "(){\n"
                getter += "        return " + relationship.name + ";\n    }\n\n"
                
                setter += "public void set" + relationship.name.uppercaseFirst + "(" + relationship.destination!.name + " " + relationship.name + "){\n"
                setter += "        this." + relationship.name + " = " + relationship.name + ";\n    }\n\n"
            }
            
            content += getter
            content += setter
        }
        
        content += "}"
    }
    
    // Check if we are going to import Date
    func importDate() -> Bool {
        for attr in entity.attributes {
            if attr.type == .Date {
                return true
            }
        }
        
        return false
    }
}

extension AttributeType {
    var javaName:Swift.String {
        get {
            switch (self) {
                case .Bool:
                    return "Boolean"
                case .Short:
                    return "Short"
                case .Int:
                    return "Integer"
                case .Long:
                    return "Long"
                case .Float:
                    return "Float"
                case .Double:
                    return "Double"
                case .String:
                    return "String"
                case .Date:
                    return "Date"
                case .Blob:
                    return "Blob"
                default:
                    return "<Unknown>"
            }
        }
    }
}
