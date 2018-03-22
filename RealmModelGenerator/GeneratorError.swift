//
//  GeneratorError.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/18/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation

enum GeneratorError: Error {
    case InvalidAttributeType(attribute: Attribute)
    case InvalidRelationshipDestination(relationship: Relationship)
    case InvalidFileContent(errorMsg: String)
    case Other(errorMsg: String)
}
