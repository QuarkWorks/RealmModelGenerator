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

public protocol Observer: AnyObject {
    func onChange(observable:Observable)
}

public typealias ObserveBlock = (Observable) -> ()

public class ObserverToken: Observer {
    
    let observable:Observable
    let observeBlock:ObserveBlock
    
    internal init(observable:Observable, observeBlock:@escaping ObserveBlock) {
        self.observable = observable
        self.observeBlock = observeBlock
        
        self.observable.addObserver(observer: self)
    }
    
    public func stopListening() {
        observable.removeObserver(observer: self)
    }
    
    public func onChange(observable: Observable) {
        observeBlock(observable)
    }
    
    deinit {
        stopListening()
    }
}

public protocol Observable: AnyObject {
    func addObserver(observer: Observer)
    func removeObserver(observer: Observer)
    func removeAllObservers()
    func notifyObservers()
}

public extension Observable {
    public func addObserveBlockBlock(observeBlock:@escaping ObserveBlock) -> ObserverToken {
        return ObserverToken(observable: self, observeBlock: observeBlock)
    }
}

public class DeferredObservable: Observable, Observer {
    private let observable:Observable
    private var weakHashTable = NSHashTable<AnyObject>.weakObjects()
    
    
    public init(observable: Observable) {
        self.observable = observable
        self.observable.addObserver(observer: self)
    }
    
    public func addObserver(observer: Observer) -> Void {
        if !weakHashTable.contains(observer) {
            weakHashTable.add(observer)
        }
    }
    
    public func removeObserver(observer: Observer) -> Void {
        while weakHashTable.contains(observer) {
            weakHashTable.remove(observer)
        }
    }
    
    public func removeAllObservers() -> Void {
        self.weakHashTable.removeAllObjects()
    }
    
    public func removeFromParent() {
        self.observable.removeObserver(observer: self)
    }
    
    public func notifyObservers() -> Void {
        self.observable.notifyObservers()
    }
    
    public func onChange(observable: Observable) {
        self.weakHashTable.allObjects.forEach({
            ($0 as! Observer).onChange(observable: self)
        })
    }
    
    deinit {
        self.removeFromParent()
    }
}

public class BaseObservable: Observable {
    private var weakHashTable = NSHashTable<AnyObject>.weakObjects()
    private var willNotify = false
    
    public func addObserver(observer: Observer) {
        if !weakHashTable.contains(observer) {
            weakHashTable.add(observer)
        }
    }
    
    public func removeObserver(observer: Observer) {
        while weakHashTable.contains(observer) {
            weakHashTable.remove(observer)
        }
    }
    
    public func removeAllObservers() {
        weakHashTable.removeAllObjects()
    }
    
    public func notifyObservers() {
        if willNotify == true {return}
        willNotify = true
        OperationQueue.main.addOperation({[weak self] in
            guard let sSelf = self else {return}
            sSelf.weakHashTable.allObjects.forEach({
                let observer = $0 as! Observer
                observer.onChange(observable: sSelf)
            })
            sSelf.willNotify = false;
        })
    }
}
