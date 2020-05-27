//
//  UIGestureRecognizerExtension.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 dengfei. All rights reserved.
//

import UIKit
import Foundation

public extension UIGestureRecognizer {
    private class GestureAction {
        var action: (UIGestureRecognizer) -> Void
        
        init(action: @escaping (UIGestureRecognizer) -> Void) {
            self.action = action
        }
    }
    
    private struct AssociatedKeys {
        static var ActionName = "action"
    }
    
    private var gestureAction: GestureAction? {
        set { objc_setAssociatedObject(self, &AssociatedKeys.ActionName, newValue, .OBJC_ASSOCIATION_RETAIN) }
        get { return objc_getAssociatedObject(self, &AssociatedKeys.ActionName) as? GestureAction }
    }

    convenience init(action: @escaping (UIGestureRecognizer) -> Void) {
        self.init()
        gestureAction = GestureAction(action: action)
        addTarget(self, action: #selector(handleAction(_:)))
    }
    
    @objc dynamic private func handleAction(_ recognizer: UIGestureRecognizer) {
        gestureAction?.action(recognizer)
    }
}
