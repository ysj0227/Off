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

    lazy var noDataImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "no_data_image")
        return view
    }()
    lazy var noDataLabel: UILabel = {
        let view = UILabel()
        view.text = "暂无数据\n数据被外星人带走了"
        view.numberOfLines = 0
        view.textColor = kAppColor_666666
        view.font = FONT_14
        view.textAlignment = .center
        return view
    }()
    lazy var noDataButton: UIButton = {
        let view = UIButton()
        view.isHidden = false
        view.setTitle("再试一次", for: .normal)
        view.titleLabel?.font = FONT_16
        view.backgroundColor = kAppBlueColor
        view.setCornerRadius(cornerRadius: 17, masksToBounds: true)
        view.setTitleColor(kAppWhiteColor, for: .normal)
        view.addTarget(self, action: #selector(clickReloadData), for: .touchUpInside)
        return view
    }()
    lazy var noDataView: UIView = {
        let view = UIView()
        view.addSubview(noDataImageView)
        view.addSubview(noDataLabel)
        view.addSubview(noDataButton)
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
    
    @objc func clickReloadData() {
        
    }
    
    ///版本更新判断
    func requestVersionUpdate() {

       SSNetworkTool.SSVersion.request_version(success: { [weak self] (response) in

           if let model = VersionModel.deserialize(from: response, designatedPath: "data") {
            self?.showUpdateAlertview(versionModel: model)
           }
           }, failure: { (error) in

       }) {(code, message) in
        
           //只有5000 提示给用户
           if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
               AppUtilities.makeToast(message)
           }

        }
               
    }
    
    //弹出版本更新弹框
    func showUpdateAlertview(versionModel: VersionModel) {
        let alert = SureAlertView(frame: self.view.frame)
        alert.isHiddenVersionCancel = versionModel.force ?? false
        alert.ShowAlertView(withalertType: AlertType.AlertTypeVersionUpdate, title: "版本更新", descMsg: versionModel.desc ?? "", cancelButtonCallClick: {
            
        }) {
            if let url = URL(string: versionModel.uploadUrl ?? "") {
                if UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler:nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleview?.leftButton.addTarget(self, action: #selector(leftBtnClick), for: .touchUpInside)
        
        titleview?.rightButton.addTarget(self, action: #selector(rightBtnClick), for: .touchUpInside)
        
        self.view.backgroundColor = kAppWhiteColor
        
        //点击登录的通知
        /*
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NoLoginClickToLogin, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            
            self?.showLoginView()
        }*/
    }
    
    @objc func isLogin() -> Bool {
        if UserTool.shared.isLogin() != true {
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
        let vc = RenterSearchResultListViewController()
        vc.searchString = sarchStr
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


class NoDataShowView: UIView {
 
     lazy var noDataImageView: UIImageView = {
         let view = UIImageView()
         view.contentMode = .scaleAspectFit
         view.image = UIImage(named: "toLoginIcon")
         return view
     }()
     lazy var noDataLabel: UILabel = {
         let view = UILabel()
         view.text = "您当前未登录，请登录后再进行此操作"
         view.textColor = kAppColor_666666
         view.font = FONT_15
         view.textAlignment = .center
         return view
     }()
     lazy var noDataButton: UIButton = {
         let view = UIButton()
         view.setTitle("去登录", for: .normal)
         view.titleLabel?.font = FONT_MEDIUM_15
         view.setCornerRadius(cornerRadius: 19, masksToBounds: true)
         view.layer.borderColor = kAppBlueColor.cgColor
         view.layer.borderWidth = 1.0
         view.setTitleColor(kAppBlueColor, for: .normal)
        view.addTarget(self, action: #selector(loginBtnClick), for: .touchUpInside)
         return view
     }()
     lazy var noDataView: UIView = {
         let view = UIView()
         view.addSubview(noDataImageView)
         view.addSubview(noDataLabel)
         view.addSubview(noDataButton)
         return view
     }()
     
    @objc func loginBtnClick() {
        guard let blockk = loginCallBack else {
            return
        }
        blockk()
    }
    
     var loginCallBack:(() -> Void)?

    override init(frame: CGRect)  {
         
         super.init(frame: frame)
        
        self.backgroundColor = kAppWhiteColor
         
         //217
    
        addSubview(noDataView)
        
         noDataView.snp.makeConstraints { (make) in
             make.center.equalToSuperview()
             make.size.equalTo(CGSize(width: kWidth, height: 217))
         }
         noDataImageView.snp.makeConstraints { (make) in
             make.centerX.equalToSuperview()
             make.top.equalToSuperview()
             make.size.equalTo(CGSize(width: 100, height: 100))
         }
         noDataLabel.snp.makeConstraints { (make) in
             make.centerX.equalToSuperview()
             make.top.equalTo(noDataImageView.snp.bottom)
             make.size.equalTo(CGSize(width: kWidth, height: 80))
         }
         noDataButton.snp.makeConstraints { (make) in
             make.centerX.equalToSuperview()
             make.bottom.equalToSuperview()
             make.size.equalTo(CGSize(width: 94, height: 38))
         }
     }
     
     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
 }
