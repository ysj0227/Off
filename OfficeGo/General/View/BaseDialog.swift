//
//  BaseDialog.swift
//  OfficeGo
//
//  Created by keke on 2018/9/14.
//  Copyright © 2018年 RRTV. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BaseDialog: UIView {
    let kTransitionDuration = 0.3
    var bgTapped: (() -> Void)?
    var shouldDismissByBgTap = true
    let disposeBag = DisposeBag()
    lazy var bgWindow: UIWindow = {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: kWidth, height: kHeight))
        let vc = UIViewController()
        window.rootViewController = vc
        window.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        vc.view.addSubview(self)
        let tap = UITapGestureRecognizer()
        window.addGestureRecognizer(tap)
        tap.rx.event
            .subscribe(onNext: { [weak self] recognizer in
                if let bgTapped = self?.bgTapped {
                    bgTapped()
                } else {
                    if self?.shouldDismissByBgTap != false {
                        self?.dismiss(animate: true)
                    }
                }
            }).disposed(by: disposeBag)
        self.bounds = CGRect(x: 0, y: 0, width: kWidth, height: kHeight)
        self.center = CGPoint(x: kWidth/2, y: kHeight/2)
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        return window
    }()
    
    public func show() {
        bgWindow.windowLevel = UIWindow.Level.alert
        self.window?.backgroundColor = .clear
        bgWindow.makeKeyAndVisible()
        UIView.animate(withDuration: kTransitionDuration) {
            self.transform = CGAffineTransform.identity
        }
    }
    
    public func dismiss(animate: Bool) {
        if animate {
            UIView.animate(withDuration: kTransitionDuration, animations: {
            }) { (finish) in
                self.remove()
            }
        } else {
            remove()
        }
    }
    
    private func remove() {
        bgWindow.isHidden = true
        bgWindow.removeFromSuperview()
    }
}
