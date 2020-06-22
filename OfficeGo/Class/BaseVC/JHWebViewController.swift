//
//  JHBaseWebViewController.swift
//  JHToolsModule_Swift
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 dengfei. All rights reserved.

import UIKit
import JavaScriptCore
import WebKit
import RxSwift
import RxCocoa
import SwiftyJSON

class JHBaseWebViewController: BaseViewController {

    //通过类型 - 设置url
    var typeEnum: OwnerIdentifyOrFYType?
    
    var urlString: String? {
        didSet {
            loadWebview()
        }
    }
    var titleString: String? {
        didSet {
            titleview?.titleLabel.text = titleString
        }
    }
    
    lazy var webView: WKWebView? = {
        let view = WKWebView()
        let preferences = WKPreferences()
        //preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController = WKUserContentController()
        //注册closeView这个函数,让js调用
        configuration.userContentController.add(self, name: "closeView")
        configuration.userContentController.add(self, name: "identifyComplete")
        var webView = WKWebView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), configuration: configuration)
        webView.scrollView.bounces = true
        webView.scrollView.alwaysBounceVertical = true
        webView.navigationDelegate = self
        return view
    }()
    let disposeBag = DisposeBag()
    
    init(protocalType: OwnerIdentifyOrFYType) {
        super.init(nibName: nil, bundle: nil)
        typeEnum = protocalType
        setUrlWithType()
    }
    
    func loadWebview() {
        if let url = URL(string: urlString ?? "") {
            LoadingHudView.showHud()
            let request = URLRequest(url: url)
            self.webView?.load(request)
        }
    }
    
    func setUrlWithType() {
        
        if let type = typeEnum {
            switch type {
                
            ///认证
            case .ProtocalTypeIdentifyOwnerUrl:
                urlString = SSDelegateURL.h5IdentifyOwnerUrl
            ///房源管理
            case .ProtocalTypeFYOwnerUrl:
                urlString = SSDelegateURL.h5IdentifyOwnerUrl
           
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        clearCache()
    }
    
    func clearCache() {
        if #available(iOS 9.0, *) {
            let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
            let date = NSDate(timeIntervalSince1970: 0)
            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date as Date, completionHandler:{ })
        } else {
            var libraryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, false).first!
            libraryPath += "/Cookies"
            
            do {
                try FileManager.default.removeItem(atPath: libraryPath)
            } catch {
                SSLog("error")
            }
            URLCache.shared.removeAllCachedResponses()
        }
    }

    ///关闭当前VC
    open func closeVC() {
        if let viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            guard viewControllers.count <= 1 else {
                self.navigationController?.popViewController(animated: true)
                return
            }
        }
        if (self.presentingViewController != nil) {
            self.dismiss(animated: true, completion: nil)
        }
    }

    
    ///用户信息
    func setUserInfo() {
        
    }
    
    ///用户信息
    // MARK: - 方法
    ///重写父类返回方法
    @objc func closeView() {
        if webView?.canGoBack ?? false {
            webView?.goBack()
        }else{
           closeVC()
        }
    }
    
    ///用户信息
    func identifyComplete() {
        
    }
    override func viewDidLoad() {
        
        titleview?.titleLabel.text = titleString
        
        super.viewDidLoad()
        
        if let webView = webView {
            view.insertSubview(webView, at: 0)
            webView.snp.makeConstraints { (make) in
                make.top.equalTo(kStatusBarHeight)
                make.leading.bottom.trailing.equalToSuperview()
            }
        }
        
        _ = webView?.rx.observeWeakly(String.self, "title")
            .subscribe(onNext: { [weak self] (value) in
                if let value = value, value.count > 0 {
                    self?.titleString = value
                }
            })
        
        self.view.addSubview(noDataView)
        noDataView.isHidden = true
        noDataView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
            make.size.equalTo(CGSize(width: 160, height: 190))
        }
        noDataImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        noDataLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(noDataImageView.snp.bottom)
            make.size.equalTo(CGSize(width: kWidth, height: 30))
        }
        noDataButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 80, height: 30))
        }
        noDataLabel.text = "加载失败，点击重试"
        
        SendNetworkStatus()
    }
    
    func SendNetworkStatus() {
        
        switch NetAlamofireReachability.shared.status {
        case .Unknown, .NotReachable:
            noDataButton.isHidden = false
            noDataImageView.image = UIImage(named: "no_network_image")
            noDataLabel.text = "网络连接失败，请查看你的网络设置"
        case .WiFi, .Wwan:
            noDataButton.isHidden = true
            noDataImageView.image = UIImage(named: "no_data_image")
            noDataLabel.text = "加载失败，点击重试"
        }
    }
    
    override func clickReloadData() {
        if let url = URL(string: urlString ?? SSDelegateURL.h5AboutUsUrl) {
            let request = URLRequest(url: url)
            webView?.load(request)
            LoadingHudView.showHud()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*
        webView?.configuration.userContentController.add(self, name: "thorJump")
        webView?.configuration.userContentController.add(self, name: "sendEventId")
 */
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /*
        webView?.configuration.userContentController.removeScriptMessageHandler(forName: "thorJump")
        webView?.configuration.userContentController.removeScriptMessageHandler(forName: "sendEventId")*/
    }
}

extension JHBaseWebViewController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        LoadingHudView.hideHud()
        noDataView.isHidden = true
    }
}

extension JHBaseWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

        ///js调用本地的方法 -
        //如果是左上角的返回按钮 - 关闭页面
        if message.name == "closeView" {
           
            closeVC()
            
        }else if message.name == "identifyComplete" {
            
            closeVC()
        }
    }
}

extension JHBaseWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        noDataView.isHidden = true
        LoadingHudView.hideHud()
        //web加载好了才有左边按钮
//        let leftBtton = UIButton()
//        leftBtton.setImage(UIImage.init(named: "wechat"), for: .normal)
//        leftBtton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
//        self.view.addSubview(leftBtton)
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        AppUtilities.makeToast(error.localizedDescription)
        noDataView.isHidden = false
        LoadingHudView.hideHud()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        AppUtilities.makeToast(error.localizedDescription)
        noDataView.isHidden = false
        LoadingHudView.hideHud()
    }
}
