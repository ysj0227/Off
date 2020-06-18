//
//  AppLinkManager.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import SwiftyJSON
import MobileCoreServices

class AppLinkManager: NSObject {

    enum ActionType: String {
        case browser    = "browser"
        case webview    = "webview"
        case share      = "share"
        case wallet     = "wallet"
        case coins      = "coins"
        case message    = "message"
        case pasteboard = "pasteboard"
        
        func needLogin() -> Bool {
            switch self {
            case .browser, .webview, .share, .pasteboard:
                return false
            case .wallet, .coins, .message:
                return true
            }
        }
    }
    
    static let shared = AppLinkManager()
    var navigationController: BaseNavigationViewController? 
    
//    public func parseLinkURL(_ urlString: String, toRoot: Bool = false, isInWebview: Bool = false) -> Bool {
//        if let url = URL(string: urlString) {
//            let scheme = url.scheme
//            let param = url.query?.parseQueryToDictionary()
//            if scheme == kAPPURLScheme {
//                guard let type = ActionType(rawValue: url.host ?? "") else {
//                    return false
//                }
//                if type.needLogin() && UserInfo.shared().isLogin() == false {
//                    showLoginVC()
//                    return true
//                }
//                switch type {
//                case .browser:
//                    if let param = param, let urlString = param["url"] {
//                        openBrowser(urlString: urlString)
//                    }
//                case .webview:
//                    if let param = param, let urlString = param["url"] {
//                        openWebView(urlString: urlString)
//                    }
//                case .share:
//                    if let param = param {
//                        share(message: param["message"], link: param["link"])
//                    }
//                case .wallet:
//                    gotoWalletVC()
//                case .coins:
//                    gotoCoinVC()
//                case .message:
//                    gotoMessageTypeVC()
//                case .pasteboard:
//                    UIPasteboard.general.string = param?["string"] ?? ""
//                }
//                return true
//            } else if scheme == "http" || scheme == "https" {
//
//                return true
//            }
//        }
//        return false
//    }
//
//    public func share(message:String?, link: String?) {
//        if link?.contains("invite-share") ?? false {
//            AppShareInfoManager.shared().displayShareVC(message: message, link: link, type: .apprientice)
//        } else {
//            AppShareInfoManager.shared().displayShareVC(message: message, link: link)
//        }
//    }
//
//    public func openBrowser(urlString: String) {
//        if let url = URL(string: urlString) {
//            UIApplication.shared.openURL(url)
//        }
//    }
//
//    public func openWebView(urlString: String) {
//        let acceptLanguage = UserInfo.shared().perferLanguage().valueToServer()
//        let url = String(format: "%@?language=%@&token=%@", urlString, acceptLanguage, UserInfo.shared().token ?? "")
//        navigationController?.pushViewController(BaseWebViewController(url: url, showNaviBar: true, showReportButton: false), animated: true)
//    }
//
//
//    public func pushViewController(_ vc: UIViewController) {
//        if let presentedNavigation = navigationController?.presentedViewController as? BaseNavigationViewController {
//            presentedNavigation.pushViewController(vc, animated: true)
//        } else {
//            navigationController?.pushViewController(vc, animated: true)
//        }
//    }
//
//    public func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
//        if let presentedNavigation = navigationController?.presentedViewController as? BaseNavigationViewController {
//            presentedNavigation.present(viewControllerToPresent, animated: flag, completion: completion)
//        } else if let presentedVC = navigationController?.presentedViewController {
//            presentedVC.present(viewControllerToPresent, animated: flag, completion: completion)
//        } else {
//            navigationController?.present(viewControllerToPresent, animated: flag, completion: completion)
//        }
//    }
//
//    public func showLoginVC(loginFrom: LoginFrom = .default, presentFrom fromVC: BaseViewController? = nil, selectHome: Bool = false) {
//        if loginFrom == .default && selectHome {
//            navigationController?.popToRootViewController(animated: false)
//        }
//        if selectHome, let tabBar = (navigationController?.viewControllers.first as? ThorTabBarViewController) {
//            tabBar.selectedIndex = 0
//        }
//        if UserInfo.shared().isPassed {
//            let loginVC = LoginViewController()
//            loginVC.loginFrom = loginFrom
//            if let prVC = fromVC {
//                prVC.present(BaseNavigationViewController(rootViewController: loginVC), animated: true, completion: nil)
//            } else {
//                navigationController?.present(BaseNavigationViewController(rootViewController: loginVC), animated: true, completion: nil)
//            }
//        } else {
//            let loginVC = ReviewLoginViewController()
//            if let prVC = fromVC {
//                prVC.present(BaseNavigationViewController(rootViewController: loginVC), animated: true, completion: nil)
//            } else {
//                navigationController?.present(BaseNavigationViewController(rootViewController: loginVC), animated: true, completion: nil)
//            }
//        }
//    }
//
//    public func showHomeVC() {
//        if let tabBar = (navigationController?.viewControllers.first as? ThorTabBarViewController) {
//            navigationController?.setViewControllers([tabBar], animated: true)
//            tabBar.selectedIndex = 0
//        }
//    }
//
//    public func gotoWathHistory() {
//        pushViewController(YoutubeWatchHistoryController())
//    }
//
//    public func gotoSearchVC() {
//        pushViewController(YoutubeSearchViewController())
//    }
//
//    public func gotoSettingVC() {
//        pushViewController(SettingViewController())
//    }
//
//    public func gotoBindMobileVC() {
//        navigationController?.pushViewController(BindMobileViewController(), animated: true)
//    }
//
//    public func gotoWithdrawVC() {
//        navigationController?.pushViewController(WithdrawCashViewController(), animated: true)
//    }
//
//    public func gotoWalletVC() {
//        navigationController?.pushViewController(WalletViewController(), animated: true)
//    }
//
//    public func gotoMessageTypeVC() {
//        navigationController?.pushViewController(MessageTypeViewController(), animated: true)
//    }
//
//    public func gotoCoinVC() {
//        if let tabBarController = navigationController?.viewControllers.first as? ThorTabBarViewController {
//            navigationController?.popToRootViewController(animated: true)
//            tabBarController.selectedIndex = 0
//        }
//    }
//
//    public func gotoPostVideoVC() {
//        navigationController?.pushViewController(ReviewPostViewController(), animated: true)
//    }
//
//    public func gotoEditProfileVC() {
//        navigationController?.pushViewController(ReViewEditProfileViewController(), animated: true)
//    }
//
//    public func showCaptrueVC() {
//        let camera =  ForReviewCaptrueViewController()
//        camera.sourceType = .camera
//        camera.mediaTypes = [kUTTypeMovie as String]
//        camera.cameraCaptureMode = .video
//        camera.videoQuality = .typeHigh
//        navigationController?.present(camera, animated: true, completion: nil)
//    }
//
//    public func gotoFeedbackVC() {
//        self.pushViewController(FeedbackViewController())
//    }
//
//    public func gotoInternalWebPage(withPath path: String, showNaviBar: Bool = true, showReportButton: Bool = false) {
//        let acceptLanguage = UserInfo.shared().perferLanguage().valueToServer()
//        let url = String(format: "%@%@?lang=%@&token=%@", NetworkManager.shared.h5RootDomain, path, acceptLanguage, UserInfo.shared().token ?? "")
//        let vc = BaseWebViewController(url: url, showNaviBar: showNaviBar, showReportButton: showReportButton)
//        if let presentedNavigation = navigationController?.presentedViewController as? BaseNavigationViewController {
//            presentedNavigation.pushViewController(vc, animated: true)
//        } else {
//            navigationController?.pushViewController(vc, animated: true)
//        }
//    }
//
//    public func gotoTutorialVC() {
//        gotoInternalWebPage(withPath: "/beginner-tutorial", showNaviBar: false)
//    }
//
//    public func gotoIncomeRankVC() {
//        gotoInternalWebPage(withPath: "/income-ranking", showNaviBar: false)
//    }
//
//    public func gotoInviteCodeVC() {
//        gotoInternalWebPage(withPath: "/invite-code-desc", showNaviBar: true)
//    }
//
//    public func gotoApprenticeVC() {
//        gotoInternalWebPage(withPath: "/apprentice-list", showNaviBar: true, showReportButton: true)
//    }
//
//    public func gotoAgreementVC() {
//        gotoInternalWebPage(withPath: "/user-agreement", showNaviBar: true)
//    }
//
//    public func gotoReportVC() {
//        gotoInternalWebPage(withPath: "/suggest", showNaviBar: true)
//    }
//
//    public func gotoForbidVC() {
//        gotoInternalWebPage(withPath: "/banned-instructions", showNaviBar: true)
//    }
//
//    public func gotoRechargeCardService() {
//        gotoInternalWebPage(withPath: "/customer-service", showNaviBar: true)
//    }
//
//    public func gotoChannelDetailVC(channelId: String?, name: String?, keyword: String? = nil) {
//        pushViewController(ChannelDetailViewController(id: channelId, name: name, keyword: keyword))
//    }
}
