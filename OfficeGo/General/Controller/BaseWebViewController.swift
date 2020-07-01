//
//  BaseWebViewController.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import JavaScriptCore
import WebKit
import RxSwift
import RxCocoa
import SwiftyJSON

class BaseWebViewController: BaseViewController {

    //通过类型 - 设置url
    var typeEnum: ProtocalType?
    
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
        view.navigationDelegate = self
        return view
    }()
    let disposeBag = DisposeBag()
    
    init(protocalType: ProtocalType) {
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
        let dateNow = Date()//当前时间
        let timeStamp = String.init(format: "%ld", Int(dateNow.timeIntervalSince1970))
        if let type = typeEnum {
            switch type {
            ///员工管理 staffList.html
           case .ProtocalTypeStaffListOwnerUrl:
                urlString = "\(SSDelegateURL.h5OwnerStaffListUrl)?token=\(UserTool.shared.user_token ?? "")&channel=\(UserTool.shared.user_channel)&identity=\(UserTool.shared.user_id_type ?? 9)&time=\(timeStamp)"
            ///关于我们
            case .ProtocalTypeAboutUs:
                urlString = SSDelegateURL.h5AboutUsUrl
            ///服务协议
            case .ProtocalTypeRegisterProtocol:
                urlString = SSDelegateURL.h5RegisterProtocolUrl
            ///隐私条款
            case .ProtocalTypePrivacyProtocolUrl:
                urlString = SSDelegateURL.h5PrivacyProtocolUrl
            ///帮助与反馈
            case .ProtocalTypeHelpAndFeedbackUrl:
                urlString = SSDelegateURL.h5HelpAndFeedbackUrl
            ///常见问题
            case .ProtocalTypeQuestionUrl:
                urlString = SSDelegateURL.h5QuestionUrl
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

    override func viewDidLoad() {
        
        titleview?.titleLabel.text = titleString
        
        super.viewDidLoad()
        
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
                make.bottom.equalToSuperview().offset(-bottomMargin())
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

extension BaseWebViewController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        LoadingHudView.hideHud()
        noDataView.isHidden = true
    }
}

extension BaseWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //        didReceiveScriptMessage(message)
    }
}

extension BaseWebViewController: WKNavigationDelegate {
//    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//        /*
//        decisionHandler(WKNavigationResponsePolicy.allow);
//        THPrint(navigationResponse)
// */
//    }
//
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        /*
//        THPrint(navigationAction)
//        let url = navigationAction.request.url
//        //        if url?.scheme == kAPPURLScheme, let urlString = url?.absoluteString, AppLinkManager.shared.parseLinkURL(urlString) == true {
//        //            decisionHandler(WKNavigationActionPolicy.cancel);
//        //            return
//        //        }
//        if navigationAction.targetFrame == nil {
//            webView.load(navigationAction.request)
//        }
//        decisionHandler(WKNavigationActionPolicy.allow);
//        */
//    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        noDataView.isHidden = true
        LoadingHudView.hideHud()
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
