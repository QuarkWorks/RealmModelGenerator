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
    static let TAG = NSStringFromClass(Tools.self)
    
    static func popupAllert(messageText:String, buttonTitile:String, informativeText:String) {
        let alert = NSAlert()
        alert.messageText = messageText
        alert.addButton(withTitle: buttonTitile)
        alert.informativeText = informativeText
        alert.runModal()

    }
}

extension String {
    var first: Substring {
        return self.prefix(1)
    }
    var last: Substring {
        return self.suffix(1)
    }
    var uppercaseFirst: String {
        return String(self.prefix(1).uppercased() + self.dropFirst())
    }
    
    var lowercaseFirst: String {
        return String(self.prefix(1).lowercased() + self.dropFirst())
    }
}
