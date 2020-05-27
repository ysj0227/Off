//
//  DispatchExtensions.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 Senwei. All rights reserved.
//

import Foundation


// MARK: - Swizzling会改变全局状态,所以用 DispatchQueue.once 来确保无论多少线程都只会被执行一次
//====================================================================================
extension DispatchQueue {
  
  private static var onceTracker = [String]()
  
  //Executes a block of code, associated with a unique token, only once.  The code is thread safe and will only execute the code once even in the presence of multithreaded calls.
  public class func once(token: String, block: () -> Void)
  {   // 保证被 objc_sync_enter 和 objc_sync_exit 包裹的代码可以有序同步地执行
    objc_sync_enter(self)
    defer { // 作用域结束后执行defer中的代码
      objc_sync_exit(self)
    }
    
    if onceTracker.contains(token) {
      return
    }
    
    onceTracker.append(token)
    block()
  }
    typealias Task = (_ cancel: Bool) -> Void
    func delay(_ time: TimeInterval, task: @escaping ()->()) -> Task? {
        
        func dispatch_later(_ block: @escaping ()->()) {
            let t = DispatchTime.now() + time
            self.asyncAfter(deadline: t, execute: block)
        }
        
        var closure: (()->Void)? = task
        var result: Task?
        
        let delayedClosure: Task = { cancel in
            if let internalClosure = closure {
                if cancel == false {
                    self.async(execute: internalClosure)
                }
            }
            closure = nil
            result = nil
        }
        
        result = delayedClosure
        
        dispatch_later {
            if let delayedClosure = result {
                delayedClosure(false)
            }
        }
        
        return result
    }
    
    func cancel(_ task: Task?) {
        task?(true)
    }
}
