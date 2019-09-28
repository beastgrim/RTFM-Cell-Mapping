//
//  ObjectObserversProtocol.swift

import UIKit

protocol ObjectObserversProtocol {
    associatedtype SelfClass
    associatedtype ProtocolClass
    
    func callObservers(_ block: @escaping (SelfClass, ProtocolClass) -> Void)
    func register(observer: ProtocolClass)
    func unregister(observer: ProtocolClass)
    
    func afterRegister(observer: ProtocolClass)
    func afterUnregister(observer: ProtocolClass)
}

var ObjectObserversProtocolObjectHandle: UInt8 = 0

extension ObjectObserversProtocol {
    
    var observers: NSHashTable<AnyObject> {
        get {
            if let value = objc_getAssociatedObject(self, &ObjectObserversProtocolObjectHandle) as? NSHashTable<AnyObject> {
                return value
            }
            
            let observers = NSHashTable<AnyObject>(options: NSPointerFunctions.Options.weakMemory)
            objc_setAssociatedObject(self, &ObjectObserversProtocolObjectHandle, observers, .OBJC_ASSOCIATION_RETAIN)
            return observers
        }
    }
    
    public func register(observer: ProtocolClass) {
        let object = observer as AnyObject
        ASQueue.getterSetter.barrierAsync {
            if !self.observers.contains(object) {
                self.observers.add(object)
            }
            self.afterRegister(observer: observer)
        }
    }
    
    public func unregister(observer: ProtocolClass) {
        let object = observer as AnyObject
        ASQueue.getterSetter.sync {
            if self.observers.contains(object) {
                self.observers.remove(object)
            }
            self.afterUnregister(observer: observer)
        }
    }
    
    func afterRegister(observer: ProtocolClass) {
    }
    func afterUnregister(observer: ProtocolClass) {
    }
    
    public func callObservers(_ block: @escaping (SelfClass, ProtocolClass) -> Void) {
        ASQueue.main.sync {
            var observers: [AnyObject]!
            
            ASQueue.getterSetter.sync {
                observers = self.observers.allObjects
            }
        
            for object in observers {
                if let observer = object as? ProtocolClass {
                    block(self as! SelfClass, observer)
                }
            }
        }
    }
    
    public func replaceObservers(_ observers: NSHashTable<AnyObject>) {
        ASQueue.getterSetter.sync {
            objc_setAssociatedObject(self, &ObjectObserversProtocolObjectHandle, observers, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
}
