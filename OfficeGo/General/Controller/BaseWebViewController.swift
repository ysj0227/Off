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
    
    let urlString: String
    var isShowNaviBar = true
    var isShowReportButton = false
    var loadingBgView: UIView?
    var titleString: String? {
        didSet {
            if isShowNaviBar {
                self.title = titleString
            }
        }
    }
    lazy var webView: WKWebView? = {
        let view = WKWebView()
        view.navigationDelegate = self
        return view
    }()
    let disposeBag = DisposeBag()
    lazy var leftButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "topbar_ic_back_w"), for: .normal)
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.leftBtnClick()
            })
            .disposed(by: disposeBag)
        return button
    }()
    lazy var reportButton: UIButton = {
        var colors = ThorButtonTextColor()
        colors.normalColor = kAppColor_666666
        let button = BaseButton.init(textColors: colors, imageNames: nil, texts: nil)
        button.titleLabel?.font = UIFont.appRegular(12)
        button.backgroundColor = kAppColor_F6F6F6
        button.setTitle(NSLocalizedString("投诉", comment: ""), for: .normal)
        button.layer.cornerRadius = 9
        button.clipsToBounds = true
        return button
    }()
    
    init(url: String, showNaviBar: Bool = true, showReportButton: Bool = false) {
        urlString = url
        isShowNaviBar = showNaviBar
        isShowReportButton = showReportButton
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLoad() {
        titleString = NSLocalizedString("加载中...", comment: "")
        super.viewDidLoad()
//        self.navigationHidden(hidden: !isShowNaviBar)

//        self.navigationView.isHidden = !isShowNaviBar
        if let webView = webView {
            view.insertSubview(webView, at: 0)
            showLoadingView()
            webView.snp.makeConstraints { (make) in
//                make.top.equalTo(isShowNaviBar ? navigationView.snp.bottom : 0)
                make.leading.bottom.trailing.equalToSuperview()
            }
            if let url = URL(string: urlString) {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        }
        if isShowNaviBar {
            if isShowReportButton {
//                navigationView.addSubview(reportButton)
                reportButton.snp.makeConstraints { (make) in
//                    make.centerY.equalTo(navigationView.titleLabel.snp.centerY)
                    make.width.equalTo(56)
                    make.height.equalTo(18)
                    make.trailing.equalTo(-10)
                }
                reportButton.rx.tap.subscribe(onNext: {
//                    AppLinkManager.shared.gotoFeedbackVC()
                }).disposed(by: disposeBag)
            }
        } else {
            view.addSubview(leftButton)
            leftButton.snp.makeConstraints { (make) in
                make.leading.equalToSuperview()
                make.top.equalTo(kNavigationHeight - 55)
                make.width.height.equalTo(55)
            }
        }
        _ = webView?.rx.observeWeakly(String.self, "title")
            .subscribe(onNext: { [weak self] (value) in
                if let value = value, value.count > 0 {
                    self?.titleString = value
                }
            })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView?.configuration.userContentController.add(self, name: "thorJump")
        webView?.configuration.userContentController.add(self, name: "sendEventId")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView?.configuration.userContentController.removeScriptMessageHandler(forName: "thorJump")
        webView?.configuration.userContentController.removeScriptMessageHandler(forName: "sendEventId")
    }
        
    override func showLoadingView() {
        var loadingImageName: String? = nil
        if urlString.contains("/invite-code-desc") {
            loadingImageName = "code-placeholder"
        } else if urlString.contains("/income-ranking") {
            loadingImageName = "income-placeholder"
        } else if urlString.contains("/apprentice-list") {
            loadingImageName = "invite-placeholder"
        }
        if let name = loadingImageName {
            loadingBgView = UIView()
            loadingBgView?.backgroundColor = .white
//            self.view.insertSubview(loadingBgView ?? UIView(), belowSubview: navigationView)
            loadingBgView?.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
            let view = UIImageView(image: UIImage(named: name))
            loadingBgView?.addSubview(view)
            if isShowNaviBar {
                view.snp.makeConstraints({ (make) in
                    make.leading.trailing.equalToSuperview()
                    make.top.equalToSuperview().inset(kNavigationHeight)
                })
            } else {
                loadingBgView?.snp.makeConstraints({ (make) in
                    make.leading.trailing.equalToSuperview()
                    if #available(iOS 11.0, *) {
                        make.top.equalToSuperview().inset(self.view.safeAreaInsets.top)
                    } else {
                        make.top.equalToSuperview()
                    }
                })
            }
        } else {
            super.showLoadingView()
        }
    }
    
    override func removeLoadingView() {
        if let view = loadingBgView {
            view.removeFromSuperview()
        } else {
            super.removeLoadingView()
        }
    }
}

extension BaseWebViewController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        removeLoadingView()
    }
}

extension BaseWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//        didReceiveScriptMessage(message)
    }
}

extension BaseWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(WKNavigationResponsePolicy.allow);
        THPrint(navigationResponse)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        THPrint(navigationAction)
        let url = navigationAction.request.url
//        if url?.scheme == kAPPURLScheme, let urlString = url?.absoluteString, AppLinkManager.shared.parseLinkURL(urlString) == true {
//            decisionHandler(WKNavigationActionPolicy.cancel);
//            return
//        }
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        decisionHandler(WKNavigationActionPolicy.allow);
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        removeLoadingView()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        AppUtilities.makeToast(error.localizedDescription)
        removeLoadingView()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        AppUtilities.makeToast(error.localizedDescription)
        removeLoadingView()
    }
}
