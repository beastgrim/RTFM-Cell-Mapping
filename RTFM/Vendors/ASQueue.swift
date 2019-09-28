/*
 * This is the source code of Telegram for iOS v. 1.1
 * It is licensed under GNU GPL v. 2 or later.
 * You should have received a copy of the license in this archive (see LICENSE).
 *
 * Copyright Peter Iakovlev, 2013.
 */

import Foundation

class ASQueue {
    
    fileprivate(set) var queue: DispatchQueue!
    fileprivate var queueSpecificKey: DispatchSpecificKey<String>!
    fileprivate var label: String!
    fileprivate var isMainQueue = false
    
    init() {}
    
    init(label: String, attributes: DispatchQueue.Attributes = []) {
        self.label = label
        
        self.queueSpecificKey = DispatchSpecificKey<String>()

        self.queue = DispatchQueue(label: label, attributes: attributes)
        self.queue.setSpecific(key: self.queueSpecificKey, value: label)
    }
    
    init(label: String, qos: DispatchQoS, attributes: DispatchQueue.Attributes = [], autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency) {
        self.label = label
        
        self.queueSpecificKey = DispatchSpecificKey<String>()
        
        self.queue = DispatchQueue(label: label, qos: qos, attributes: attributes, autoreleaseFrequency: autoreleaseFrequency, target: nil)
        self.queue.setSpecific(key: self.queueSpecificKey, value: label)
    }
    
    deinit {
        self.queue = nil
    }
    
    static let main: ASQueue = {
        let queue = ASQueue()
        queue.queue = DispatchQueue.main
        queue.isMainQueue = true
        return queue
    }()
    
    static let assetsLibrary: ASQueue = {
        let queue = ASQueue(label: "io.faceapp.ios.assetsLibrary")
        return queue
    }()
    
    static let background: ASQueue = {
        let queue = ASQueue(label: "io.faceapp.ios.background")
        return queue
    }()

    static let parse: ASQueue = {
        let queue = ASQueue(label: "io.faceapp.ios.parseQueue")
        return queue
    }()
    
    static let getterSetter: ASQueue = {
        let queue = ASQueue(label: "io.faceapp.ios.getterSetterQueue", attributes: .concurrent)
        return queue
    }()
    
    public var isCurrentQueue: Bool {
        if self.queue == nil {
            return false
        } else if self.isMainQueue {
            return Thread.isMainThread
        } else {
            if let label = DispatchQueue.getSpecific(key: self.queueSpecificKey) {
                return label == self.label
            }
            return false
        }
    }
    
    public func run(_ block: @escaping () -> Void) {
        if self.isCurrentQueue {
            block()
        } else {
            self.dispatch(block, synchronous: false)
        }
    }
    
    public func async(_ block: @escaping () -> Void) {
        self.dispatch(block, synchronous: false)
    }
    
    public func barrierAsync(_ block: @escaping () -> Void) {
        self.queue.async(flags: .barrier) {
            block()
        }
    }
    
    public func sync(_ block: @escaping () -> Void) {
        self.dispatch(block, synchronous: true)
    }

    private func dispatch(_ block: @escaping () -> Void, synchronous: Bool) {
        if synchronous {
            if self.isCurrentQueue {
                block()
            } else {
                self.queue.sync(execute: block)
            }
        } else {
            self.queue.async(execute: block)
        }
    }

}
