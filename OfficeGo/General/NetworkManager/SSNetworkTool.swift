//
//  SSNetworkTool.swift
//  UUEnglish
//
//  Created by Aibo on 2018/3/26.
//  Copyright © 2018年 uuabc. All rights reserved.
//

import Foundation
import Alamofire

typealias SSSuccessedClosure = (_ dataObj: [String: Any]) -> Void
typealias SSErrorCodeMessageClosure = (_ statusCode: String, _ message: String) -> Void
typealias SSFailedErrorClosure = (_ error: NSError) -> Void


class SSNetworkTool: NSObject {
    
    ///通常请求session
    private static let worker: SessionManager = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15  // seconds
        config.timeoutIntervalForResource = config.timeoutIntervalForRequest
        config.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        Alamofire.SessionManager.default.delegate.taskWillPerformHTTPRedirection = nil
        return Alamofire.SessionManager(configuration: config)
    }()
    
    ///上传图片session
    private static let uploadSessionWorker: SessionManager = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 120  // seconds
        config.timeoutIntervalForResource = config.timeoutIntervalForRequest
        config.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        Alamofire.SessionManager.default.delegate.taskWillPerformHTTPRedirection = nil
        return Alamofire.SessionManager(configuration: config)
    }()
    
    private static func createUrlAndHeaders(urlStr: String) -> (url: String, headers: [String: String]){
        let Url = urlStr
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        //        let headers = ["Accept": "application/json; version=\(version)", "token":"\(SSuserDefault.sharedInstance.token ?? "")"]
        let headers = ["Accept": "application/json; version=\(version)"]
        return (Url, headers)
    }
    /// 图片上传
    ///
    /// - Parameters:
    ///   - url: 地址
    ///   - image: 图片
    ///   - params: 参数
    ///   - isShowHud: 是否显示HUD
    static func uploadImage(urlStr: String,image: UIImage,params: [String: String],isShowHud:Bool,success: SSSuccessedClosure!, failed: SSFailedErrorClosure!, error: SSErrorCodeMessageClosure!)  {
        //压缩图片 可自定义
        let imageData : Data = image.jpegData(compressionQuality: 0.01) ?? Data()
        if isShowHud {
            LoadingHudView.showHud()
        }
        
        uploadSessionWorker.upload(multipartFormData: { (multiPart) in
            for p in params {
                multiPart.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
            }
            multiPart.append(imageData, withName: "file", fileName: "\(UserTool.shared.user_phone ?? "").jpg", mimeType: "image/jpg")
        }, to: urlStr, method: .post, headers: nil) { (multiPartResult) in
            switch(multiPartResult) {
            case .success(let request, let streamingFromDisk, let streamFileURL) :
                request.responseJSON(completionHandler: { (Response) in
                    SSLog("数据地址:\(urlStr) 方式：post 参数:\(params) 数据\(Response.result) 数据数据\(String(describing: Response.result.value))")
                    if isShowHud {
                        LoadingHudView.hideHud()
                    }
                    switch Response.result {
                    case .success:
                        guard let resp:[String:Any] = Response.result.value! as? [String:Any] else {
                            return
                        }
                        //                    let infoData = (resp["data"] as? [String: AnyObject])
                        
                        let statusCode = (resp["status"] as? Int) ?? -1
                        if statusCode == SSCode.SUCCESS.code {
                            if let block = success {
                                block(resp)
                            }
                            
                        }else if statusCode == SSCode.DEFAULT_ERROR_CODE_5000.code {
                            var message = ""
                            if let msg  = resp["message"]  {
                                message = (msg as? String) ?? ""
                            }
                            if let block = error {
                                block("\(statusCode)", message)
                            }
                        }else if statusCode == SSCode.ERROR_CODE_5009.code {
                            AppUtilities.makeToast("\(SSCode.ERROR_CODE_5009.msg)")
                            SSTool.delay(time: 2) {
                                NotificationCenter.default.post(name: NSNotification.Name.LoginResignEffect, object: nil)
                            }
                        }else {
                            var message = ""
                            if let msg  = resp["message"]  {
                                message = (msg as? String) ?? ""
                                
                                 //AppUtilities.makeToast("\(statusCode)\n\(message)")
                            }
                            if let block = error {
                                block("\(statusCode)", message)
                            }
                        }
                    case .failure(let error):
                        if let block = failed {
                            block(error as NSError)
                            SSLog("url:\(urlStr) error:\(error)")
                        }
                    }
                })
            case .failure(let error) :
                if isShowHud {
                    LoadingHudView.hideHud()
                }
                SSLog(error)
                //                NotificationCenter.default.post(name: Notification.Name.userChanged, object: false)
            }
        }
        
    }
    
    /// 个人认证多组多张图片上传
    ///
    /// - Parameters:
    ///   - fczImagesArray: 房产证
    ///   - zlAgentImagesArray: 租赁协议
    ///   - imagesArray: 图片
    ///   - params: 参数
    ///   - isShowHud: 是否显示HUD
    static func uploadPersonalMutileArrImage(urlStr: String, frontName: String, frontImage: [UIImage], reverseName: String, reverseImage: [UIImage], fczfileName: String, fczImagesArray: [UIImage], zlAgentfileName: String, zlAgentImagesArray: [UIImage], params: Eic,isShowHud:Bool,success: SSSuccessedClosure!, failed: SSFailedErrorClosure!, error: SSErrorCodeMessageClosure!)  {

        if isShowHud {
            LoadingHudView.showHud()
        }
        
        uploadSessionWorker.upload(multipartFormData: { (multiPart) in
            for p in params {
                multiPart.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
            }
            ///身份证 - 正
            for image in frontImage {
                if  let imageData = image.jpegData(compressionQuality: 1) {
                    multiPart.append(imageData, withName: frontName, fileName: "image.jpg", mimeType: "image/jpg")
                }
            }
            ///身份证 - 反
            for image in reverseImage {
                if  let imageData = image.jpegData(compressionQuality: 1) {
                    multiPart.append(imageData, withName: reverseName, fileName: "image.jpg", mimeType: "image/jpg")
                }
            }
            for image in fczImagesArray {
                if  let imageData = image.jpegData(compressionQuality: 1) {
                    multiPart.append(imageData, withName: fczfileName, fileName: "image.jpg", mimeType: "image/jpg")
                }
            }
            for image in zlAgentImagesArray {
                if  let imageData = image.jpegData(compressionQuality: 1) {
                    multiPart.append(imageData, withName: zlAgentfileName, fileName: "image.jpg", mimeType: "image/jpg")
                }
            }
        }, to: urlStr, method: .post, headers: nil) { (multiPartResult) in
            switch(multiPartResult) {
            case .success(let request, let streamingFromDisk, let streamFileURL) :
                request.responseJSON(completionHandler: { (Response) in
                    SSLog("数据地址:\(urlStr) 方式：post 参数:\(params) 数据\(Response.result) 数据数据\(String(describing: Response.result.value))")
                    if isShowHud {
                        LoadingHudView.hideHud()
                    }
                    switch Response.result {
                    case .success:
                        guard let resp:[String:Any] = Response.result.value! as? [String:Any] else {
                            return
                        }
                        //                    let infoData = (resp["data"] as? [String: AnyObject])
                        
                        let statusCode = (resp["status"] as? Int) ?? -1
                        if statusCode == SSCode.SUCCESS.code {
                            if let block = success {
                                block(resp)
                            }
                            
                        }else if statusCode == SSCode.DEFAULT_ERROR_CODE_5000.code {
                            var message = ""
                            if let msg  = resp["message"]  {
                                message = (msg as? String) ?? ""
                            }
                            if let block = error {
                                block("\(statusCode)", message)
                            }
                        }else if statusCode == SSCode.ERROR_CODE_5009.code {
                            AppUtilities.makeToast("\(SSCode.ERROR_CODE_5009.msg)")
                            SSTool.delay(time: 2) {
                                NotificationCenter.default.post(name: NSNotification.Name.LoginResignEffect, object: nil)
                            }
                        }else {
                            var message = ""
                            if let msg  = resp["message"]  {
                                message = (msg as? String) ?? ""
                                
                                 //AppUtilities.makeToast("\(statusCode)\n\(message)")
                            }
                            if let block = error {
                                block("\(statusCode)", message)
                            }
                        }
                    case .failure(let error):
                        if let block = failed {
                            block(error as NSError)
                            SSLog("url:\(urlStr) error:\(error)")
                        }
                    }
                })
            case .failure(let error) :
                if isShowHud {
                    LoadingHudView.hideHud()
                }
                SSLog(error)
                //                NotificationCenter.default.post(name: Notification.Name.userChanged, object: false)
            }
        }
        
    }
    
    /// 公司 共享办公认证多组多张图片上传
    ///
    /// - Parameters:
    ///   - fczImagesArray: 房产证
    ///   - zlAgentImagesArray: 租赁协议
    ///   - imagesArray: 图片
    ///   - params: 参数
    ///   - isShowHud: 是否显示HUD
    static func uploadMutileArrImage(urlStr: String, fczfileName: String, fczImagesArray: [UIImage], zlAgentfileName: String, zlAgentImagesArray: [UIImage], params: Eic,isShowHud:Bool,success: SSSuccessedClosure!, failed: SSFailedErrorClosure!, error: SSErrorCodeMessageClosure!)  {

        if isShowHud {
            LoadingHudView.showHud()
        }
        
        uploadSessionWorker.upload(multipartFormData: { (multiPart) in
            for p in params {
                multiPart.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
            }
            for image in fczImagesArray {
                if  let imageData = image.jpegData(compressionQuality: 1) {
                    multiPart.append(imageData, withName: fczfileName, fileName: "image.jpg", mimeType: "image/jpg")
                }
            }
            for image in zlAgentImagesArray {
                if  let imageData = image.jpegData(compressionQuality: 1) {
                    multiPart.append(imageData, withName: zlAgentfileName, fileName: "image.jpg", mimeType: "image/jpg")
                }
            }
        }, to: urlStr, method: .post, headers: nil) { (multiPartResult) in
            switch(multiPartResult) {
            case .success(let request, let streamingFromDisk, let streamFileURL) :
                request.responseJSON(completionHandler: { (Response) in
                    SSLog("数据地址:\(urlStr) 方式：post 参数:\(params) 数据\(Response.result) 数据数据\(String(describing: Response.result.value))")
                    if isShowHud {
                        LoadingHudView.hideHud()
                    }
                    switch Response.result {
                    case .success:
                        guard let resp:[String:Any] = Response.result.value! as? [String:Any] else {
                            return
                        }
                        //                    let infoData = (resp["data"] as? [String: AnyObject])
                        
                        let statusCode = (resp["status"] as? Int) ?? -1
                        if statusCode == SSCode.SUCCESS.code {
                            if let block = success {
                                block(resp)
                            }
                            
                        }else if statusCode == SSCode.DEFAULT_ERROR_CODE_5000.code {
                            var message = ""
                            if let msg  = resp["message"]  {
                                message = (msg as? String) ?? ""
                            }
                            if let block = error {
                                block("\(statusCode)", message)
                            }
                        }else if statusCode == SSCode.ERROR_CODE_5009.code {
                            AppUtilities.makeToast("\(SSCode.ERROR_CODE_5009.msg)")
                            SSTool.delay(time: 2) {
                                NotificationCenter.default.post(name: NSNotification.Name.LoginResignEffect, object: nil)
                            }
                        }else {
                            var message = ""
                            if let msg  = resp["message"]  {
                                message = (msg as? String) ?? ""
                                
                                 //AppUtilities.makeToast("\(statusCode)\n\(message)")
                            }
                            if let block = error {
                                block("\(statusCode)", message)
                            }
                        }
                    case .failure(let error):
                        if let block = failed {
                            block(error as NSError)
                            SSLog("url:\(urlStr) error:\(error)")
                        }
                    }
                })
            case .failure(let error) :
                if isShowHud {
                    LoadingHudView.hideHud()
                }
                SSLog(error)
                //                NotificationCenter.default.post(name: Notification.Name.userChanged, object: false)
            }
        }
        
    }
    
    /// 多张图片上传 - 目前使用在上传公司营业执照
    ///
    /// - Parameters:
    ///   - urlStr: 地址
    ///   - fileName: 图片名字
    ///   - imagesArray: 图片
    ///   - params: 参数
    ///   - isShowHud: 是否显示HUD
    static func uploadMutileImage(urlStr: String, fileName: String, imagesArray: [UIImage],params: Eic,isShowHud:Bool,success: SSSuccessedClosure!, failed: SSFailedErrorClosure!, error: SSErrorCodeMessageClosure!)  {

        if isShowHud {
            LoadingHudView.showHud()
        }
        
        uploadSessionWorker.upload(multipartFormData: { (multiPart) in
            for p in params {
                multiPart.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
            }
            for image in imagesArray {
                if  let imageData = image.jpegData(compressionQuality: 1) {
                    multiPart.append(imageData, withName: fileName, fileName: "image.jpg", mimeType: "image/jpg")
                }
            }
        }, to: urlStr, method: .post, headers: nil) { (multiPartResult) in

            switch(multiPartResult) {
            case .success(let request, let streamingFromDisk, let streamFileURL):
                request.responseJSON(completionHandler: { (Response) in
                    SSLog("数据地址:\(urlStr) 方式：post 参数:\(params) 数据\(Response.result) 数据数据\(String(describing: Response.result.value))")
                    if isShowHud {
                        LoadingHudView.hideHud()
                    }
                    switch Response.result {
                    case .success:
                        guard let resp:[String:Any] = Response.result.value! as? [String:Any] else {
                            return
                        }
                        //                    let infoData = (resp["data"] as? [String: AnyObject])
                        
                        let statusCode = (resp["status"] as? Int) ?? -1
                        if statusCode == SSCode.SUCCESS.code {
                            if let block = success {
                                block(resp)
                            }
                            
                        }else if statusCode == SSCode.DEFAULT_ERROR_CODE_5000.code {
                            var message = ""
                            if let msg  = resp["message"]  {
                                message = (msg as? String) ?? ""
                            }
                            if let block = error {
                                block("\(statusCode)", message)
                            }
                        }else if statusCode == SSCode.ERROR_CODE_5009.code {
                            AppUtilities.makeToast("\(SSCode.ERROR_CODE_5009.msg)")
                            SSTool.delay(time: 2) {
                                NotificationCenter.default.post(name: NSNotification.Name.LoginResignEffect, object: nil)
                            }
                        }else {
                            var message = ""
                            if let msg  = resp["message"]  {
                                message = (msg as? String) ?? ""
                                
                                 //AppUtilities.makeToast("\(statusCode)\n\(message)")
                            }
                            if let block = error {
                                block("\(statusCode)", message)
                            }
                        }
                    case .failure(let error):
                        if let block = failed {
                            block(error as NSError)
                            SSLog("url:\(urlStr) error:\(error)")
                        }
                    }
                })
            case .failure(let error) :
                if isShowHud {
                    LoadingHudView.hideHud()
                }
                SSLog(error)
                //                NotificationCenter.default.post(name: Notification.Name.userChanged, object: false)
            }
        }
        
    }
    
    static func request(type: HTTPMethod, urlStr: String,sessionId:String?, params:Dic, isShowHud:Bool, success: SSSuccessedClosure!, failed: SSFailedErrorClosure!, error: SSErrorCodeMessageClosure!)  {
        //        SSTool.invokeInGlobalThread {
        
        if isShowHud {
            LoadingHudView.showHud()
        }
        
        let para = params == nil ? Eic() : params!
        
        let handle = createUrlAndHeaders(urlStr: urlStr)
        let URL = handle.url
        //            let headers = handle.headers
        let encoding:ParameterEncoding = (type.rawValue == HTTPMethod.get.rawValue) ? URLEncoding.default : URLEncoding.queryString
        
        let _ = worker.request(URL, method: type, parameters: para, encoding: encoding, headers: nil).responseJSON(completionHandler: { (Response) in
            SSLog("数据地址:\(urlStr) 方式：\(type) 参数:\(para) 数据\(Response.result) 数据数据\(String(describing: Response.result.value))")
            if isShowHud {
                LoadingHudView.hideHud()
            }
            switch Response.result {
            case .success:
                guard let resp:[String:Any] = Response.result.value! as? [String:Any] else {
                    return
                }
                //                    let infoData = (resp["data"] as? [String: AnyObject])
                
                let statusCode = (resp["status"] as? Int) ?? -1
                if statusCode == SSCode.SUCCESS.code {
                    if let block = success {
                        block(resp)
                    }
                    
                }else if statusCode == SSCode.DEFAULT_ERROR_CODE_5000.code {
                    var message = ""
                    if let msg  = resp["message"]  {
                        message = (msg as? String) ?? ""
                    }
                    if let block = error {
                        block("\(statusCode)", message)
                    }
                }else if statusCode == SSCode.ERROR_CODE_5009.code {
                    AppUtilities.makeToast("\(SSCode.ERROR_CODE_5009.msg)")
                    SSTool.delay(time: 2) {
                        NotificationCenter.default.post(name: NSNotification.Name.LoginResignEffect, object: nil)
                    }
                }else {
                    var message = ""
                    if let msg  = resp["message"]  {
                        message = (msg as? String) ?? ""
                        
                         //AppUtilities.makeToast("\(statusCode)\n\(message)")
                    }
                    if let block = error {
                        block("\(statusCode)", message)
                    }
                }
            case .failure(let error):
                if let block = failed {
                    block(error as NSError)
                    SSLog("url:\(urlStr) error:\(error)")
                }
            }
        })
        //return req
        //        }
    }
    
    static func request(type: HTTPMethod, urlStr: String, params:Dic,isShowHud:Bool,success: SSSuccessedClosure!, failed: SSFailedErrorClosure!, error: SSErrorCodeMessageClosure!) {
        request(type: type, urlStr: urlStr, sessionId: nil, params: params, isShowHud:isShowHud,success: success, failed: failed, error: error)
    }
    
}

extension SSNetworkTool {
    
    //  MARK:   --认证
    class SSOwnerIdentify: NSObject {
        
        ///搜索企业接口
        static func request_getESCompany(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSOwnerIdentifyURL.getESCompany)
            SSNetworkTool.request(type: .get,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        
        ///搜索企业大楼接口
        static func request_getESBuild(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSOwnerIdentifyURL.getESBuild)
            SSNetworkTool.request(type: .get,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        
        ///搜索网点接口
        static func request_getESBranch(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSOwnerIdentifyURL.getESBranch)
            SSNetworkTool.request(type: .get,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        ///进入申请加入查询管理员Id APP
        static func request_getApplyManagerMsg(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSOwnerIdentifyURL.getApplyManagerMsg)
            SSNetworkTool.request(type: .get,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        
        ///申请加入企业
       static func request_getApplyJoin(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
           let url = String.init(format: SSOwnerIdentifyURL.getApplyJoin)
           SSNetworkTool.request(type: .get,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
               success,failed:failure,error:error)
       }
        
        ///加入企业或者网点同意拒绝接口
        static func request_getUpdateAuditStatus(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSOwnerIdentifyURL.getUpdateAuditStatus)
            SSNetworkTool.request(type: .get,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }

        ///网点是否可以创建判断接口
        static func request_getIsCanCreatBranch(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSOwnerIdentifyURL.getIsCanCreatBranch)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        
        ///企业是否可以创建判断接口App
        static func request_getIsCanCreatCompany(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSOwnerIdentifyURL.getIsCanCreatCompany)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        
        ///用户选择身份
        static func request_getSelectIdentityTypeApp(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSOwnerIdentifyURL.getSelectIdentityTypeApp)
            SSNetworkTool.request(type: .get,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        
        ///添加公司认证APP
        static func request_companyIdentityApp(params: Eic, fczImagesArray: [UIImage], zlAgentImagesArray: [UIImage], success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSOwnerIdentifyURL.getUploadLicenceProprietorApp)
            SSNetworkTool.uploadMutileArrImage(urlStr: "\(SSAPI.SSApiHost)\(url)", fczfileName: "filePremisesPermit", fczImagesArray: fczImagesArray, zlAgentfileName: "fileContract", zlAgentImagesArray: zlAgentImagesArray, params: params, isShowHud: true, success:
            success,failed:failure,error:error)
        }
        
        ///添加共享办公认证APP
        static func request_jointIdentityApp(params: Eic, fczImagesArray: [UIImage], zlAgentImagesArray: [UIImage], success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSOwnerIdentifyURL.getUploadLicenceProprietorApp)
            SSNetworkTool.uploadMutileArrImage(urlStr: "\(SSAPI.SSApiHost)\(url)", fczfileName: "filePremisesPermit", fczImagesArray: fczImagesArray, zlAgentfileName: "fileContract", zlAgentImagesArray: zlAgentImagesArray, params: params, isShowHud: true, success:
            success,failed:failure,error:error)
        }
        
        ///添加个人认证APP
        static func request_personalIdentityApp(params: Eic, frontImage: [UIImage], reverseImage: [UIImage],fczImagesArray: [UIImage], zlAgentImagesArray: [UIImage], success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSOwnerIdentifyURL.getUploadLicenceProprietorApp)
            SSNetworkTool.uploadPersonalMutileArrImage(urlStr: "\(SSAPI.SSApiHost)\(url)", frontName: "fileIdFront", frontImage: frontImage, reverseName: "fileIdBack", reverseImage: reverseImage, fczfileName: "filePremisesPermit", fczImagesArray: fczImagesArray, zlAgentfileName: "fileContract", zlAgentImagesArray: zlAgentImagesArray, params: params, isShowHud: true, success:
            success,failed:failure,error:error)
        }
        
        ///创建公司接口 - 上传营业执照
        static func request_createCompanyApp(params: Eic, imagesArray: [UIImage] ,success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSOwnerIdentifyURL.getUploadLicenceProprietorApp)
            SSNetworkTool.uploadMutileImage(urlStr: "\(SSAPI.SSApiHost)\(url)", fileName: "fileBusinessLicense", imagesArray: imagesArray, params: params, isShowHud: true, success:
            success,failed:failure,error:error)
        }
        
        ///创建楼盘接口 - 上传封面图
        ///创建网点接口 - 上传封面图
        static func request_createBuildingApp(params: Eic, imagesArray: [UIImage] ,success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSOwnerIdentifyURL.getUploadLicenceProprietorApp)
            SSNetworkTool.uploadMutileImage(urlStr: "\(SSAPI.SSApiHost)\(url)", fileName: "fileMainPic", imagesArray: imagesArray, params: params, isShowHud: true, success:
            success,failed:failure,error:error)
        }
        
        ///图片删除接口
         static func request_getDeleteImgApp(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSOwnerIdentifyURL.deleteImgApp)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        
        ///自主撤销认证
        static func request_getDeleteUserLicenceApp(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSOwnerIdentifyURL.getDeleteUserLicenceApp)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        
        ///查询申请信息接口（普通员工申请加入之后查询页面数据）
        static func request_getQueryApplyLicenceProprietorApp(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
           let url = String.init(format: SSOwnerIdentifyURL.getQueryApplyLicenceProprietorApp)
           SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
               success,failed:failure,error:error)
       }
        
        ///房东和房东聊天列表调用接口
        static func request_getOwnerToOwnerchattedMsgAApp(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSOwnerIdentifyURL.getOwnerToOwnerchattedMsgAApp)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
    }
    class SSVersion:NSObject {
        static func request_version(success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure) {
            let url = String.init(format: SSMineURL.versionUpdate)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:["versioncode": SSTool.getVersion() as AnyObject], isShowHud: true,success:
                success,failed:failure,error:error)
        }
    }
    
    //  MARK:   --聊天
    class SSChat: NSObject {
        
        //交换手机微信号判断
        static func request_getExchangePhoneVerification(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSChatURL.getExchangePhoneVerification)
            SSNetworkTool.request(type: .get,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        
        //getUserChatInfoApp
        static func request_getUserChatInfoApp(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSChatURL.getUserChatInfoApp)
            SSNetworkTool.request(type: .get,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        
        //获取融云token
        static func request_getRongYunToken(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSChatURL.getRongYunToken)
            SSNetworkTool.request(type: .get,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        
        //创建和房东聊天接口
        static func request_getCreatFirstChatApp(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSChatURL.getCreatFirstChatApp)
            SSNetworkTool.request(type: .get,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: false,success:
                success,failed:failure,error:error)
        }
        
        //获取和房东聊天详情接口
        static func request_getChatFYDetailApp(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSChatURL.getChatMsgDetailApp)
            SSNetworkTool.request(type: .get,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        
        //保存微信
        static func request_getAddWxID(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSChatURL.addWxID)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        
        //租户房东第一次发消息
        static func request_addChatApp(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSChatURL.addChatApp)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        
    }
    
    //  MARK:   --行程
    class SSSchedule: NSObject {
        
        //看房行程
        static func request_getScheduleListApp(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSScheduleURL.getScheduleListApp)
            SSNetworkTool.request(type: .get,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        
        //看房记录
        static func request_getOldScheduleListApp(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSScheduleURL.getOldScheduleListApp)
            SSNetworkTool.request(type: .get,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        
        //看房行程详情
        static func request_getScheduleDetailApp(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSScheduleURL.getScheduleApp)
            SSNetworkTool.request(type: .get,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        
        //添加预约看房 - 租户像房东申请预约看房
        static func request_addRenterApp(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSScheduleURL.addRenterApp)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        
        //添加预约看房 - 房东像租户预约看房
        static func request_addProprietorApp(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSScheduleURL.addProprietorApp)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        
        //行程审核接口
        static func request_updateAuditStatusApp(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSScheduleURL.updateAuditStatusApp)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        
        
    }
    
    //  MARK:   收藏
    class SSCollect: NSObject {
        
        //添加收藏
        static func request_addCollection(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSCollectURL.addCollection)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        
        //获取收藏列表
        static func request_getFavoriteListAPP(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSCollectURL.getFavoriteListAPP)
            SSNetworkTool.request(type: .get,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        
    }
    
    
    //  MARK:   --搜索
    class SSSearch: NSObject {
        
        //全局搜索接口
        static func request_getsearchList(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSSearchURL.getsearchList)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: false,success:
                success,failed:failure,error:error)
        }
        
        //查询历史记录
        static func request_getHistorySearchKeywords(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSSearchURL.getgetSearchKeywords)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: false,success:
                success,failed:failure,error:error)
        }
        
        //MARK: 清除历史记录
        static func request_getClearHistorySearchKeywords(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSSearchURL.delSearchKeywords)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        //查询发现 - 热门关键字 - 字典接口
        
    }
    
    //  MARK:   详情
    class SSFYDetail: NSObject {
        
        //楼盘网点详情
        static func request_getBuildingDetailbyBuildingId(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSFYDetailURL.getBuildingDetailbyBuildingId)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        
        //楼盘-网点房源详情
        static func request_getBuildingFYDetailbyHouseId(params: Dic,success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure) {
            let url = String.init(format: SSFYDetailURL.getBuildingFYDetailbyHouseId)
            SSNetworkTool.request(type: .get,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        
        //楼盘-网点房源列表
        static func request_getBuildingFYList(params: Dic,success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure) {
            let url = String.init(format: SSFYDetailURL.getBuildingFYList)
            SSNetworkTool.request(type: .get,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        //点击分享 - 调用接口
        static func request_clickShareClick(params: Dic,success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure) {
            let url = String.init(format: SSFYDetailURL.clickShareClick)
            SSNetworkTool.request(type: .get,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
    }
    
    //  MARK:   首页
    class SSHome: NSObject {
        
        //请求banner
        static func request_getbannerListt(success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSHomeURL.getbannerListt)
            var params = [String:AnyObject]()
            params["type"] = NetworkParams.AppType as AnyObject?
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        
        //请求首页推荐列表
        static func request_getselectBuildingApp(params: Dic,success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure) {
            let url = String.init(format: SSHomeURL.getselectBuildingApp)
            SSNetworkTool.request(type: .get,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
    }
    
    
    class SSBasic:NSObject {
        
        //地铁线路接口
        static func request_getSubwayList(params: Dic,success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure) {
            let url = String.init(format:SSBasicURL.getSubwayList)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: false,success:
                success,failed:failure,error:error)
        }
        
        //区域商圈接口
        static func request_getDistrictList(params: Dic,success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure) {
            let url = String.init(format:SSBasicURL.getDistrictList)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: false,success:
                success,failed:failure,error:error)
        }
        
        //获取字典接口
        static func request_getDictionary(code: DictionaryCodeEnum,success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure) {
            var params = [String:AnyObject]()
            params["code"] = code.rawValue as AnyObject?
            let url = String.init(format:SSBasicURL.getDictionary)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: false,success:
                success,failed:failure,error:error)
        }
        
    }
    
    
    //  MARK:   登录
    class SSLogin: NSObject {
        
        //验证码
        static func request_getSmsCode(params: Dic,success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format:SSLoginURL.getSmsCode)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: false,success:
                success,failed:failure,error:error)
        }
        
        //短信登录
        static func request_loginWithCode(params: Dic,success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format:SSLoginURL.loginWithCode)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        
        //我想找接口
        static func request_addWantToFind(params: Dic,success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format:SSLoginURL.addWantToFind)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
    }
    //  MARK:   我的
    class SSMine: NSObject {
        
        ///绑定微信
        static func request_bindWeChat(params: Dic,success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSMineURL.bindWeChat)
            SSNetworkTool.request(type: .get,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: false,success:
                success,failed:failure,error:error)
        }
        
        ///切换身份
        static func request_roleChange(params: Dic,success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSMineURL.roleChange)
            SSNetworkTool.request(type: .get,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: false,success:
                success,failed:failure,error:error)
        }
        
        ///个人资料 - 租户
        static func request_getRenterUserMsg(params: Dic,success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSMineURL.getRenterUserMsg)
            SSNetworkTool.request(type: .get,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: false,success:
                success,failed:failure,error:error)
        }
        
        ///个人资料 - 房东
        static func request_getOwnerUserMsg(params: Dic,success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSMineURL.getOwnerUserMsg)
            SSNetworkTool.request(type: .get,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: false,success:
                success,failed:failure,error:error)
        }
        
        ///修改个人资料 - 不包含头像
        static func request_updateUserMessage(params: Dic,success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSMineURL.updateUserMessage)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        
        ///修改个人资料 -头像
        static func request_uploadAvatar(image: UIImage, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSMineURL.updateUserMessage)
            var params = [String:String]()
            params["token"] = UserTool.shared.user_token
            SSNetworkTool.uploadImage(urlStr: "\(SSAPI.SSApiHost)\(url)", image: image, params: params, isShowHud: true, success:
                success,failed:failure,error:error)
        }
        
        ///修改手机号
        static func request_changePhone(params: Dic,success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSMineURL.changePhone)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        
        ///修改微信
        static func request_changeWechat(params: Dic,success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSMineURL.changeWechat)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params, isShowHud: true,success:
                success,failed:failure,error:error)
        }
        
    }
    
}

struct NetworkParams {
    //1：H5，2：IOS，3：安卓
    static let AppType = "2"
    
}
