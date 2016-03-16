//
//  AttributeTypeExtension.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/16/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation

extension AttributeType {
    
    func name(language: Language, isRequired: Swift.Bool) -> Swift.String {
        switch self {
        case .Bool:
            switch language {
                case .Java:
                    return  "Boolean"
                case .Objc:
                    return isRequired ? "BOOL " : "NSNumber<RLMBool> *"
                case .Swift:
                    return isRequired ? "" : "Bool"
                }
        case .Short:
            switch language {
            case .Java:
                return  "Short"
            case .Objc:
                return isRequired ? "int" : "NSNumber<RLMInt> *"
            case .Swift:
                return isRequired ? "" : "Int"
            }
        case .Int:
            switch language {
            case .Java:
                return  "Integer"
            case .Objc:
                return isRequired ? "int" : "NSNumber<RLMInt> *"
            case .Swift:
                return isRequired ? "" : "Int"
            }
        case .Long:
            switch language {
            case .Java:
                return  "Long"
            case .Objc:
                return isRequired ? "int" : "NSNumber<RLMInt> *"
            case .Swift:
                return isRequired ? "" : "Int"
            }
        case .Float:
            switch language {
            case .Java:
                return  "Float"
            case .Objc:
                return isRequired ? "float" : "NSNumber<RLMFloat> *"
            case .Swift:
                return isRequired ? ": Float" : "Float"
            }
        case .Double:
            switch language {
            case .Java:
                return  "Double"
            case .Objc:
                return isRequired ? "double" : "NSNumber<RLMDouble> *"
            case .Swift:
                return isRequired ? ": Double" : "Double"
            }
        case .String:
            switch language {
            case .Java:
                return  "String"
            case .Objc:
                return "NSString *"
            case .Swift:
                return isRequired ? "" : ": String?"
            }
        case .Date:
            switch language {
            case .Java:
                return  "Date"
            case .Objc:
                return "NSDate *"
            case .Swift:
                return isRequired ? "" : ": NSDate?"
            }
        case .Blob:
            switch language {
            case .Java:
                return  "Blob"
            case .Objc:
                return "NSData *"
            case .Swift:
                return isRequired ? "" : ": NSData?"
            }
        default:
            return "<Unknown>"
        }
    }

}