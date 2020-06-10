//
//  BaseViewController.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {
    
    var titleview: ThorNavigationView?
    
    lazy var loadingView: UIView = {
        return UIView()
    }()
    
    /*
     //设置导航栏的颜色 - 可设置透明
     func setNavigationBarColor(color: UIColor) {
     navigationController?.navigationBar.setBackgroundImage(UIImage.create(with: color), for: .default)
     //        if color == kAppClearColor {
     //            self.navigationHidden(hidden: true)
     //        }else {
     //            self.navigationHidden(hidden: false)
     //        }
     }
     
     //消除导航栏下面的黑线
     func setNavigationRemoveBottomView() {
     navigationController?.navigationBar.shadowImage = UIImage()
     }
     
     func navigationHidden(hidden: Bool) {
     navigationController?.navigationBar.isHidden = hidden
     }
     */
    
    var errorView: ErrorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleview?.leftButton.addTarget(self, action: #selector(rightBtnClick), for: .touchUpInside)
        
        titleview?.rightButton.addTarget(self, action: #selector(rightBtnClick), for: .touchUpInside)
        
        self.view.backgroundColor = kAppWhiteColor
    }
    
    @objc func leftBtnClick() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBtnClick() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public func pushViewController(_ viewController: UIViewController) {
        if let naviVC = self.tabBarController?.navigationController {
            naviVC.pushViewController(viewController, animated: true)
            return
        }
        if let naviVC = self.navigationController {
            naviVC.pushViewController(viewController, animated: true)
        }
    }
    
    public func showLoadingView() {
        view.addSubview(loadingView)
        loadingView.snp.remakeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(120)
        }
    }
    
    public func removeLoadingView() {
        loadingView.removeFromSuperview()
    }
    
    public func showErrorView(topMargin: CGFloat? = 0, error: Error? = nil) {
        self.errorView?.removeFromSuperview()
        self.errorView = nil
        var type = ErrorView.ViewType.serverError
        if let domain = (error as NSError?)?.domain {
            if domain == NSURLErrorDomain {
                if let code = (error as NSError?)?.code {
                    if code == NSURLErrorTimedOut || code == NSURLErrorCannotConnectToHost {
                        type = .timeout
                    } else {
                        type = .network
                    }
                }
            }
        }
        let errorView = ErrorView(type: type)
        self.errorView = errorView
        
        view.addSubview(errorView)
        errorView.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview()
            make.centerY.greaterThanOrEqualTo((kHeight - kNavigationHeight) / 10 * 3 + kNavigationHeight + (topMargin ?? 0.0))
            make.width.equalToSuperview()
        }
        weak var weakSelf = self
        errorView.retryBlock = {
            weakSelf?.refreshView()
        }
    }
    
    public func removeErrorView() {
        errorView?.removeFromSuperview()
    }
    
    public func refreshView() {
        removeErrorView()
        errorView = nil
    }
}

extension BaseViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .default
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
    
    override var shouldAutorotate: Bool {
        get {
            return false
        }
    }
}

extension BaseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


extension BaseViewController {
    //跳转到搜索结果列表
    func clickPushToSearchListVc(sarchStr: String) {
        let vc = SearchResultListViewController()
        vc.searchString = sarchStr
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
