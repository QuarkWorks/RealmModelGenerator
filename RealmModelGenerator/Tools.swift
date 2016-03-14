//
//  Tools.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/10/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation
import AddressBook

class Tools {
    static let TAG = NSStringFromClass(Tools)
}

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