//
//  ViewTools.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/20/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//

import Cocoa
import Quartz

extension NSView {
    var backgroundColor: NSColor? {
        get {
            guard let layer = layer, backgroundColor = layer.backgroundColor else { return nil }
            return NSColor(CGColor: backgroundColor)
        }
        
        set {
            wantsLayer = true
            layer?.backgroundColor = newValue?.CGColor
        }
    }
    
    var cornerRadius: CGFloat {
        get {
            guard let layer = layer else { return 0.0 }
            return layer.cornerRadius
        }
        
        set {
            self.wantsLayer = true
            self.layer?.cornerRadius = newValue
        }
    }
    
    var borderWidth: CGFloat {
        get {
            guard let layer = layer else { return 0.0 }
            return layer.borderWidth
        }
        
        set {
            self.wantsLayer = true
            self.layer!.borderWidth = newValue
        }
    }
    
    var borderColor :NSColor? {
        get {
            guard let layer = layer, borderColor = layer.borderColor else { return nil }
            return NSColor(CGColor: borderColor)
        }
        
        set {
            wantsLayer = true
            layer?.borderColor = newValue?.CGColor
        }
    }
}