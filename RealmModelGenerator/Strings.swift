//
//  Strings.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/11/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation

//Reference: http://stackoverflow.com/a/28288340
extension String {
    var first: String {
        return String(characters.prefix(1))
    }
    var last: String {
        return String(characters.suffix(1))
    }
    var uppercaseFirst: String {
        return first.uppercaseString + String(characters.dropFirst())
    }
}