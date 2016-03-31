//
//  GeneratorError.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/18/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation

enum GeneratorError: ErrorType {
    case InvalidAttribteType(attribute: Attribute)
    case InvalidRelationshiDestination(relationship: Relationship)
    case InvalidFileContent(errorMsg: String)
    case Other(errorMsg: String)
}
