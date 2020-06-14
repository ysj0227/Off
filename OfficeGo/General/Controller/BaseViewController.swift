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
    
    
    lazy var noDataImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "empty_placeholde_happy_image")
        return view
    }()
    lazy var noDataLabel: UILabel = {
        let view = UILabel()
        view.text = "暂无数据"
        view.textColor = kAppColor_666666
        view.font = FONT_15
        view.textAlignment = .center
        return view
    }()
    lazy var noDataView: UIButton = {
        let view = UIButton()
        view.isUserInteractionEnabled = true
        view.addSubview(noDataImageView)
        view.addSubview(noDataLabel)
        return view
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
    
    func showLoginView() {
        let windows = UIApplication.shared.keyWindow
        let alert = SureAlertView(frame: windows?.frame ?? CGRect(x: 0, y: 0, width: kWidth, height: kHeight))
        alert.inputTFView.text = "您还没登录，请先登录"
        alert.isHiddenVersionCancel = true
        alert.ShowAlertView(withalertType: AlertType.AlertTypeVersionUpdate, message: "温馨提示", cancelButtonCallClick: {
            
        }) {[weak self] in
            self?.showLoginVC()
        }
    }
    
    func showLoginVC() {
        let vc = ReviewLoginViewController()
        let loginNav = BaseNavigationViewController.init(rootViewController: vc)
        loginNav.modalPresentationStyle = .overFullScreen
        //TODO: 这块弹出要设置
        self.present(loginNav, animated: true) {
            vc.titleview?.leftButton.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleview?.leftButton.addTarget(self, action: #selector(leftBtnClick), for: .touchUpInside)
        
        titleview?.rightButton.addTarget(self, action: #selector(rightBtnClick), for: .touchUpInside)
        
        self.view.backgroundColor = kAppWhiteColor
        
        //点击登录的通知
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NoLoginClickToLogin, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            
            self?.showLoginView()
        }
    }
    
    @objc func isLogin() -> Bool {
        if UserTool.shared.isLogin() != true {
//            AppUtilities.makeToast("您还没有登录")
            showLoginView()
            return false
        }else {
            return true
        }
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
