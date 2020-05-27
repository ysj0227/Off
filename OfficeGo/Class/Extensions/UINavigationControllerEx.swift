//
//  UINavigationControllerEx.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 dengfei. All rights reserved.
//

import UIKit

//@available(iOS 13.0, *)
//extension UIResponder {
//    @objc var coordinatingResponder: UIResponder? {
//        return self.next
//    }
//}
//
//@available(iOS 13.0, *)
//extension UIScene{
//    override open var next: UIResponder? {
//        SwizzleNavBar.swizzle
//        return super.next
//    }
//}

extension UIApplication {
    override open var next: UIResponder? {
        SwizzleNavBar.swizzle
        return super.next
    }
}

public class SwizzleNavBar {
    public static let swizzle: Void = {
        UIViewController.swizzleMethod()
        UINavigationController.swizzle()
    }()
}

public extension NSObject {

    static func swizzlingForClass(_ forClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
        guard let originalMethod = class_getInstanceMethod(forClass, originalSelector),
              let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector) else {
            return
        }

        let isAddSuccess = class_addMethod(forClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        if isAddSuccess {
            class_replaceMethod(forClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}

public extension UIViewController {
 
    private struct Associated {
        static var WillAppearInject: String = "WillAppearInject"
    }
    typealias ViewControllerWillAppearInjectBlock = (_ viewController: UIViewController , _ animated: Bool) -> Void

    class func swizzleMethod(){
        guard self == UIViewController.self else { return }
        let originalSelector = #selector(viewWillAppear(_ : ))
        let swizzledSelector = #selector(jh_viewWillAppear(_ : ))
        swizzlingForClass(UIViewController.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }

    @objc internal var willAppearInjectBlock: ViewControllerWillAppearInjectBlock? {
        get {
            if let block =  objc_getAssociatedObject(self, &Associated.WillAppearInject) as? ViewControllerWillAppearInjectBlock{
                return block
            }
            return nil
        }
        set (newValue){
            objc_setAssociatedObject(self, &Associated.WillAppearInject, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
//    @_dynamicReplacement(for: viewWillAppear(_ : ))
    @objc func jh_viewWillAppear(_ animated: Bool) {
        self.jh_viewWillAppear(animated)
        guard let block = self.willAppearInjectBlock else {
            return
        }
        block(self , animated)
    }

}

public extension UIViewController {
    private struct Associate {
        static var NavigationBarHidden: String = "NavigationBarHidden"
    }
    
    var prefersNavigationBarHidden: Bool? {
        get {
            return objc_getAssociatedObject(self, &Associate.NavigationBarHidden) as? Bool
        }
        set {
            if let value = newValue {
                objc_setAssociatedObject(self, &Associate.NavigationBarHidden, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}

public extension UINavigationController {
    
    private struct Associated {
        static var NavigationBarAppearanceEnabled: String = "NavigationBarAppearanceEnabled"
    }
    
    var viewControllerBasedNavigationBarAppearanceEnabled: Bool? {
        get {
            self.viewControllerBasedNavigationBarAppearanceEnabled = true
            guard let number = objc_getAssociatedObject(self, &Associated.NavigationBarAppearanceEnabled) as? NSNumber else {
                return true
            }
            return  number.boolValue
        }
        set {
            if let value = newValue {
                objc_setAssociatedObject(self, &Associated.NavigationBarAppearanceEnabled, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    class func swizzle(){
        guard self == UINavigationController.self else { return }
        let originalSelector = #selector(setViewControllers(_:animated:))
        let swizzledSelector = #selector(jh_setViewControllers(_:animated:))
        swizzlingForClass(UINavigationController.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
        
        let original = #selector(pushViewController(_:animated:))
        let swizzled = #selector(jh_pushViewController(_:animated:))
        swizzlingForClass(UINavigationController.self, originalSelector: original, swizzledSelector: swizzled)
    }

    @objc func jh_pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.setupViewControllerBasedNavigationBarAppearanceIfNeeded(appearingViewController: viewController)
        self.jh_pushViewController(viewController, animated: animated)
    }
//
//    @_dynamicReplacement(for: setViewControllers(_: animated:))
    @objc func jh_setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        for  vc in viewControllers {
            self.setupViewControllerBasedNavigationBarAppearanceIfNeeded(appearingViewController: vc)
        }
        self.jh_setViewControllers(viewControllers, animated: animated)
    }
    
    func setupViewControllerBasedNavigationBarAppearanceIfNeeded(appearingViewController: UIViewController){
        if self.viewControllerBasedNavigationBarAppearanceEnabled == false {
            return
        }

        appearingViewController.willAppearInjectBlock = { [weak self] (viewController: UIViewController, animated: Bool) in
            guard let `self` = self else { return }
            self.setNavigationBarHidden(viewController.prefersNavigationBarHidden ?? false, animated: animated)
        }
        
        // 因为不是所有的都是通过push的方式，把控制器压入stack中，也可能是"-setViewControllers:"的方式，所以需要对栈顶控制器做下判断并赋值。
        guard let disappearingViewController = self.viewControllers.last, disappearingViewController.willAppearInjectBlock == nil else {
            return
        }
        disappearingViewController.willAppearInjectBlock = { [weak self] (viewController: UIViewController, animated: Bool) in
            guard let `self` = self else { return }
            self.setNavigationBarHidden(viewController.prefersNavigationBarHidden ?? false, animated: animated)
        }
        
    }
}
