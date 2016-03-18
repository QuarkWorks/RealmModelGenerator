//
//  FileModel.swift
//  RealmModelGenerator
//
//  Created by Zhaolong Zhong on 3/6/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Foundation

class FileModel {
    var name: String
    var content: String
    var fileExtension: String
    
    init(name: String, content: String, fileExtension: String) {
        self.name = name
        self.content = content
        self.fileExtension = fileExtension
    }
}