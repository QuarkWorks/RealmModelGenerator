//
//  FileContentGenerator.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/6/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation

class JavaContentGenerator: BaseContentGenerator {
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
        content += getHeaderComments(entity, fileExtension: "java")
        
        content += "import io.realm.*;\nimport io.realm.annotations.*;\n"
        if (importDate()) {
            content += "import java.util.Date;\n"
        }
        content += "\npublic class " + entity.name + " extends RealmObject {\n"
        content += "\tprivate static final String TAG = " + entity.name + ".class.getSimpleName();\n\n"
    }
    
    //MARK: Append RealmKeys
    func appendRealmKeys() {
        content += "\tpublic static final class RealmKeys {"
        
        for attr in entity.attributes {
            var realmKey = "\n"
            realmKey += "\t\tpublic static final String " + attr.name.uppercaseString + "_KEY = \"" + attr.name.lowercaseString + "\";"
            content += realmKey
        }
        
        content += "\n\t}\n\n"
    }
    
    //MARK: Append attributes and relicationships
    func appendAttributes() {
        let primarykey = entity.primaryKey
        
        // Append attributes
        for attr in entity.attributes {
            var attrAnnotions = ""
            var attrDefination = "\t"
            
            //TODO: handle multiple annotions in the same property?
            //Get attribute annotions
            if primarykey?.name == attr.name {
                attrAnnotions += "\t@PrimaryKey\n"
            }
            
            if attr.isIndexed && primarykey?.name != attr.name {
                attrAnnotions += "\t@Index\n"
            }
            
            if attr.isIgnored {
                attrAnnotions += "\t@Ignore\n"
            }
            
            if attr.isRequired {
                attrAnnotions += "\t@Require\n"
            }
            
            //Get attribute defination
            attrDefination += "private " + attr.type.name(Language.Java, isRequired: false) + " " + attr.name
            if attr.hasDefault {
                if attr.type == .String {
                    attrDefination += " = \"" + attr.defaultValue + "\";\n"
                } else {
                    attrDefination += " = " + attr.defaultValue + ";\n"
                }
            }
            
            if !attrAnnotions.isEmpty {
                content += attrAnnotions
            }
            
            content += attrDefination + "\n"
        }
        
        // Append relationship
        for relationship in entity.relationships {
            var relationshipDefination = "\t"
            if relationship.isMany {
                relationshipDefination += "private RealmList<" + relationship.destination!.name + "> " + relationship.name
            } else {
                relationshipDefination += "private " + relationship.destination!.name + " " + relationship.name
            }
            content += relationshipDefination + "\n";
        }
        
        content += "\n"
    }
    
    //MARK: Append Getters and Setters
    func appendGettersAndSetters() {
        // Append attribute Getters and Setters
        for attr in entity.attributes {
            var getter = "\t"
            var setter = "\t"
            
            getter += "public " + attr.type.name(Language.Java, isRequired: false) + " get" + attr.name.uppercaseFirst + "(){\n"
            getter += "\t\treturn " + attr.name + ";\n\t}\n\n"
            
            setter += "public void set" + attr.name.uppercaseFirst + "(" + attr.type.name(Language.Java, isRequired: false) + " " + attr.name + "){\n"
            setter += "\t\tthis." + attr.name + " = " + attr.name + ";\n\t}\n\n"
            
            content += getter
            content += setter
        }
        
        // Append relationship Getters and Setters
        for relationship in entity.relationships {
            var getter = "\t"
            var setter = "\t"
            
            if relationship.isMany {
                getter += "public RealmList<" + relationship.destination!.name + "> get" + relationship.name.uppercaseFirst + "(){\n"
                getter += "\t\treturn " + relationship.name + ";\n\t}\n\n"
                
                setter += "public void set" + relationship.name.uppercaseFirst + "(RealmList<" + relationship.destination!.name + "> " + relationship.name + "){\n"
                setter += "\t\tthis." + relationship.name + " = " + relationship.name + ";\n\t}\n\n"
            } else {
                getter += "public " + relationship.destination!.name + " get" + relationship.name.uppercaseFirst + "(){\n"
                getter += "\t\treturn " + relationship.name + ";\n\t}\n\n"
                
                setter += "public void set" + relationship.name.uppercaseFirst + "(" + relationship.destination!.name + " " + relationship.name + "){\n"
                setter += "\t\tthis." + relationship.name + " = " + relationship.name + ";\n\t}\n\n"
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
