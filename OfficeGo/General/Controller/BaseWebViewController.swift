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

class BaseWebViewController: BaseViewController, UINavigationControllerDelegate {
    
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
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController = WKUserContentController()
        //注册closeView这个函数,让js调用
        //           configuration.userContentController.add(self, name: "closeView")
        //           configuration.userContentController.add(self, name: "identifyComplete")
        let view = WKWebView(frame: CGRect.zero, configuration: configuration)
        view.scrollView.bounces = true
        view.scrollView.alwaysBounceVertical = true
        view.navigationDelegate = self
        view.uiDelegate = self
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
                urlString = "\(SSAPI.SSH5Host)\(SSDelegateURL.h5OwnerStaffListUrl)?token=\(UserTool.shared.user_token ?? "")&channel=\(UserTool.shared.user_channel)&identity=\(UserTool.shared.user_id_type ?? 9)&time=\(timeStamp)"
            ///关于我们
            case .ProtocalTypeAboutUs:
                urlString = SSAPI.SSH5Host + SSDelegateURL.h5AboutUsUrl
            ///服务协议
            case .ProtocalTypeRegisterProtocol:
                urlString = SSAPI.SSH5Host + SSDelegateURL.h5RegisterProtocolUrl
            ///隐私条款
            case .ProtocalTypePrivacyProtocolUrl:
                urlString = SSAPI.SSH5Host + SSDelegateURL.h5PrivacyProtocolUrl
            ///帮助与反馈
            case .ProtocalTypeHelpAndFeedbackUrl:
                //租户
                if UserTool.shared.user_id_type == 0 {
                    urlString = SSAPI.SSH5Host + SSDelegateURL.h5RenterHelpAndFeedbackUrl + "?time=\(timeStamp)"
                }else if UserTool.shared.user_id_type == 1 {
                    urlString = "\(SSAPI.SSH5Host)\(SSDelegateURL.h5OwnerHelpAndFeedbackUrl)?token=\(UserTool.shared.user_token ?? "")&channel=\(UserTool.shared.user_channel)&identity=\(UserTool.shared.user_id_type ?? 9)&time=\(timeStamp)"
                }
            ///常见问题
            case .ProtocalTypeQuestionUrl:
                urlString = SSAPI.SSH5Host + SSDelegateURL.h5QuestionUrl + "?time=\(timeStamp)"
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
        
        super.viewDidLoad()
        
        self.view.backgroundColor = kAppWhiteColor
        
        titleview = ThorNavigationView.init(type: .backTitleRight)
        titleview?.backgroundColor = kAppWhiteColor
        titleview?.leftButtonCallBack = { [weak self] in
            self?.leftBtnClick()
        }
        
        view.addSubview(titleview ?? ThorNavigationView.init(type: .backTitleRight))
        
        titleview?.titleLabel.text = titleString
        
        if let webView = webView {
            view.insertSubview(webView, at: 0)
            webView.snp.makeConstraints { (make) in
                make.top.equalTo(kNavigationHeight)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview().offset(-bottomMargin())
            }
        }
        /*
         _ = webView?.rx.observeWeakly(String.self, "title")
         .subscribe(onNext: { [weak self] (value) in
         if let value = value, value.count > 0 {
         self?.titleString = value
         }
         })*/
        
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.webView?.configuration.userContentController.add(self, name: "closeView")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        webView?.configuration.userContentController.removeScriptMessageHandler(forName: "closeView")
    }
    
}

extension BaseWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        ///js调用本地的方法 -
        //如果是左上角的返回按钮 - 关闭页面
        if message.name == "closeView" {
            
            leftBtnClick()
        }
    }
}
extension BaseWebViewController: WKUIDelegate {
    //此方法作为js的alert方法接口的实现，默认弹出窗口应该只有提示消息，及一个确认按钮，当然可以添加更多按钮以及其他内容，但是并不会起到什么作用
    //点击确认按钮的相应事件，需要执行completionHandler，这样js才能继续执行
    ////参数 message为  js 方法 alert(<message>) 中的<message>
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertViewController = UIAlertController(title: "提示", message:message, preferredStyle: UIAlertController.Style.alert)
        alertViewController.addAction(UIAlertAction(title: "确认", style: UIAlertAction.Style.default, handler: { (action) in
            completionHandler()
        }))
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    // confirm
    //作为js中confirm接口的实现，需要有提示信息以及两个相应事件， 确认及取消，并且在completionHandler中回传相应结果，确认返回YES， 取消返回NO
    //参数 message为  js 方法 confirm(<message>) 中的<message>
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
    
    // prompt
    //作为js中prompt接口的实现，默认需要有一个输入框一个按钮，点击确认按钮回传输入值
    //当然可以添加多个按钮以及多个输入框，不过completionHandler只有一个参数，如果有多个输入框，需要将多个输入框中的值通过某种方式拼接成一个字符串回传，js接收到之后再做处理
    //参数 prompt 为 prompt(<message>, <defaultValue>);中的<message>
    //参数defaultText 为 prompt(<message>, <defaultValue>);中的 <defaultValue>
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

extension BaseWebViewController: WKNavigationDelegate {
    
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        noDataView.isHidden = true
        LoadingHudView.hideHud()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        LoadingHudView.hideHud()

        /*
         AppUtilities.makeToast(error.localizedDescription)*/
//        if error.code == NSURLErrorCancelled {
//            noDataView.isHidden = true
//        }else {
//            noDataView.isHidden = false
//        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        /*
         AppUtilities.makeToast(error.localizedDescription)*/
        noDataView.isHidden = false
        LoadingHudView.hideHud()
    }
}
