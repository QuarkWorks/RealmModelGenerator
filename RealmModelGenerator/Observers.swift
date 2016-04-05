//
//  Observers.swift
//  RealmModelGenerator
//
//  Created by Brandon Erbschloe on 3/23/16.
//  Copyright © 2016 QuarkWorks. All rights reserved.
//
//  This class is not thread safe and should only be used on the main thread / dispatch queue
//

import Foundation

public protocol Observer: class {
    func onChange(observable:Observable)
}

public typealias ObserveBlock = (Observable) -> ()

public class ObserverToken: Observer {
    
    let observable:Observable
    let observeBlock:ObserveBlock
    
    internal init(observable:Observable, observeBlock:ObserveBlock) {
        self.observable = observable
        self.observeBlock = observeBlock
        
        self.observable.addObserver(self)
    }
    
    public func stopListening() {
        observable.removeObserver(self)
    }
    
    public func onChange(observable: Observable) {
        observeBlock(observable)
    }
    
    deinit {
        stopListening()
    }
}

public protocol Observable: class {
    func addObserver(observer: Observer)
    func removeObserver(observer: Observer)
    func removeAllObservers()
    func notifyObservers()
}

public extension Observable {
    public func addObserveBlockBlock(observeBlock:ObserveBlock) -> ObserverToken {
        return ObserverToken(observable: self, observeBlock: observeBlock)
    }
}

public class DeferedObservable: Observable {
    private let observable:Observable
    private var weakHashTable = NSHashTable.weakObjectsHashTable()
    
    
    public init(observable: Observable) {
        self.observable = observable
    }
    
    public func addObserver(observer: Observer) -> Void {
        self.observable.addObserver(observer)
        
        if !weakHashTable.containsObject(observer) {
            weakHashTable.addObject(observer)
        }
    }
    
    public func removeObserver(observer: Observer) -> Void {
        self.observable.removeObserver(observer)
        
        while weakHashTable.containsObject(observer) {
            weakHashTable.removeObject(observer)
        }
    }
    
    public func removeAllObservers() -> Void {
        self.weakHashTable.allObjects.forEach({
            self.observable.removeObserver($0 as! Observer)
        })
        self.weakHashTable.removeAllObjects()
    }
    
    public func notifyObservers() -> Void {
        self.observable.notifyObservers()
    }
    
    deinit {
        self.removeAllObservers()
    }
}

public class BaseObservable: Observable {
    private var weakHashTable = NSHashTable.weakObjectsHashTable()
    private var willNotify = false
    
    public func addObserver(observer: Observer) {
        if !weakHashTable.containsObject(observer) {
            weakHashTable.addObject(observer)
        }
    }
    
    public func removeObserver(observer: Observer) {
        while weakHashTable.containsObject(observer) {
            weakHashTable.removeObject(observer)
        }
    }
    
    public func removeAllObservers() {
        weakHashTable.removeAllObjects()
    }
    
    public func notifyObservers() {
        if willNotify == true {return}
        willNotify = true
        NSOperationQueue.mainQueue().addOperationWithBlock({[weak self] in
            guard let sSelf = self else {return}
            sSelf.weakHashTable.allObjects.forEach({
                let observer = $0 as! Observer
                observer.onChange(sSelf)
            })
            sSelf.willNotify = false;
            })
    }
}