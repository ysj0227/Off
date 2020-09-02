//
//  BannerOutClickWebViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/9/2.
//  Copyright © 2020 Senwei. All rights reserved.
//

import WebKit

class BannerOutClickWebViewController: BaseViewController, UINavigationControllerDelegate {
    
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
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController = WKUserContentController()
        let view = WKWebView(frame: CGRect.zero, configuration: configuration)
        view.scrollView.bounces = true
        view.scrollView.alwaysBounceVertical = true
        view.navigationDelegate = self
        view.uiDelegate = self
        view.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions.new, context: nil)
        return view
    }()
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if keyPath == "title" {
            if object as? WKWebView == webView {
                titleString = webView?.title
            }
        }
    }
    func loadWebview() {
        if let url = URL(string: urlString ?? "") {
            LoadingHudView.showHud()
            let request = URLRequest(url: url)
            self.webView?.load(request)
        }
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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = kAppWhiteColor
        
        titleview = ThorNavigationView.init(type: .backTitleRight)
        titleview?.backgroundColor = kAppWhiteColor
        titleview?.leftButtonCallBack = { [weak self] in
            self?.leftBtnClick()
        }
        
        view.addSubview(titleview ?? ThorNavigationView.init(type: .backTitleRight))
            
        if let webView = webView {
            view.insertSubview(webView, at: 0)
            webView.snp.makeConstraints { (make) in
                make.top.equalTo(kNavigationHeight)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
//                make.bottom.equalToSuperview().offset(-bottomMargin())
            }
        }
        
        self.view.addSubview(noDataView)
        noDataView.isHidden = true
        noDataView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
            make.size.equalTo(CGSize(width: kWidth, height: 247))
        }
        noDataImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 165, height: 145))
        }
        noDataLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(noDataImageView.snp.bottom)
            make.size.equalTo(CGSize(width: kWidth, height: 48))
        }
        noDataButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 108, height: 34))
        }
        
        SendNetworkStatus()
    }
    
    func SendNetworkStatus() {
        
        switch NetAlamofireReachability.shared.status {
        case .Unknown, .NotReachable:
            noDataImageView.image = UIImage(named: "no_network_image")
            noDataLabel.text = TitleStringEnum.noNetworkString
        case .WiFi, .Wwan:
            noDataImageView.image = UIImage(named: "no_data_image")
            noDataLabel.text = TitleStringEnum.noDataString
        }
    }
    
    override func clickReloadData() {
        
        SendNetworkStatus()
        
        if let url = URL(string: urlString ?? "\(SSAPI.SSH5Host)\(SSDelegateURL.h5AboutUsUrl)") {
            let request = URLRequest(url: url)
            webView?.load(request)
            LoadingHudView.showHud()
        }
    }
    
}

extension BannerOutClickWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        ///js调用本地的方法 -
        //如果是左上角的返回按钮 - 关闭页面
        if message.name == "closeView" {
            
            leftBtnClick()
        }
    }
}
extension BannerOutClickWebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertViewController = UIAlertController(title: "提示", message:message, preferredStyle: UIAlertController.Style.alert)
        alertViewController.addAction(UIAlertAction(title: "确认", style: UIAlertAction.Style.default, handler: { (action) in
            completionHandler()
        }))
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertVicwController = UIAlertController(title: "提示", message: message, preferredStyle: UIAlertController.Style.alert)
        alertVicwController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: { (alertAction) in
            completionHandler(false)
        }))
        alertVicwController.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (alertAction) in
            completionHandler(true)
        }))
        self.present(alertVicwController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alertViewController = UIAlertController(title: prompt, message: "", preferredStyle: UIAlertController.Style.alert)
        alertViewController.addTextField { (textField) in
            textField.text = defaultText
        }
        alertViewController.addAction(UIAlertAction(title: "完成", style: UIAlertAction.Style.default, handler: { (alertAction) in
            completionHandler(alertViewController.textFields![0].text)
        }))
        self.present(alertViewController, animated: true, completion: nil)
    }
}

extension BannerOutClickWebViewController: WKNavigationDelegate {
    
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        noDataView.isHidden = true
        LoadingHudView.showHud()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        noDataView.isHidden = true
        LoadingHudView.hideHud()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        LoadingHudView.hideHud()
        
        let eeee: NSError = error as NSError
        if eeee.code == NSURLErrorCancelled {
            noDataView.isHidden = true
        }else {
            noDataView.isHidden = false
        }
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        /*
         AppUtilities.makeToast(error.localizedDescription)*/
        noDataView.isHidden = false
        LoadingHudView.hideHud()
    }
}
