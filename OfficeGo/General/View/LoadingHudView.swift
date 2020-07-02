//
//  LoadingHudView.swift
//  OfficeGo
//
//  Created by mac on 2020/6/15.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class LoadingHudView: UIView {

    private var loadingActivity: UIActivityIndicatorView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubview()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSubview() {
        
        let view = UIActivityIndicatorView()
        view.color = kAppBlueColor
        view.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            view.style = .large
        } else {
            // Fallback on earlier versions
        }
        loadingActivity = view
        addSubview(loadingActivity!)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        loadingActivity?.snp.makeConstraints({ (snp) in
            snp.width.height.equalTo(150)
            snp.center.equalTo(self.snp.center)
        })
    }
    
    /// show in window
    @objc public class func showHud() {
        DispatchQueue.main.async {
            self.showHud(inView: UIApplication.shared.keyWindow!)
        }
    }
    
    /// show in a view
    @objc public class func showHud(inView:UIView) {
        DispatchQueue.main.async {
        for view in inView.subviews {
            if view.isKind(of: LoadingHudView.self) {
                LoadingHudView.hideHud(inView: inView)
                return
            }
        }
        let hud = LoadingHudView()
        hud.frame = inView.bounds
        hud.loadingActivity?.startAnimating()
        inView.addSubview(hud)
        
      }
    }
    
    /// hide from window
    @objc public class func hideHud(){
        DispatchQueue.main.async {
            self.hideHud(inView: UIApplication.shared.keyWindow!)
        }
    }
    
    /// hide from a view
    @objc public class func hideHud(inView:UIView){
        DispatchQueue.main.async {
            for view in inView.subviews {
                if view.isKind(of: LoadingHudView.self) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        for view in inView.subviews {
                            if view.isKind(of: LoadingHudView.self) {
                                view.removeFromSuperview()
                            }
                        }
                    }
                }
            }
        }
    }

}
