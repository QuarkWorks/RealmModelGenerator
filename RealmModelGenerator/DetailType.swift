//
//  DetailType.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/31/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation

enum DetailType: String {
    case Entity, Attribute, Relationship, Empty
    
    static let values = [Entity, Attribute, Relationship, Empty]
    
    init(rawValueSafe:Swift.String) {
        self = .Empty
        if let type = DetailType.init(rawValue: rawValueSafe) {
            self = type
        }
    }
}
