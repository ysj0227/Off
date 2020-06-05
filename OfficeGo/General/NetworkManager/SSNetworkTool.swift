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
    
    private static let worker: SessionManager = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15  // seconds
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
    
    
    static func request(type: HTTPMethod, urlStr: String,sessionId:String?, params:Dic, success: SSSuccessedClosure!, failed: SSFailedErrorClosure!, error: SSErrorCodeMessageClosure!)  {
        SSTool.invokeInGlobalThread {
            var para = params == nil ? Eic() : params!
            
            let handle = createUrlAndHeaders(urlStr: urlStr)
            let URL = handle.url
            //            let headers = handle.headers
            let encoding:ParameterEncoding = (type.rawValue == HTTPMethod.get.rawValue) ? URLEncoding.default : URLEncoding.queryString
            
            let _ = worker.request(URL, method: type, parameters: para, encoding: encoding, headers: nil).responseJSON(completionHandler: { (Response) in
                SSLog("数据地址:\(urlStr) 参数:\(para) 数据\(Response.result) 数据数据\(String(describing: Response.result.value))")
                
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
                    }else {
                        var message = ""
                        if let msg  = resp["message"]  {
                            message = (msg as? String) ?? ""
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
        }
    }
    
    static func request(type: HTTPMethod, urlStr: String, params:Dic,success: SSSuccessedClosure!, failed: SSFailedErrorClosure!, error: SSErrorCodeMessageClosure!) {
        request(type: type, urlStr: urlStr, sessionId: nil, params: params, success: success, failed: failed, error: error)
    }
    
    static func requestVersion(type: HTTPMethod, urlStr: String, params:Dic,success: SSSuccessedClosure!, failed: SSFailedErrorClosure!, error: SSErrorCodeMessageClosure!) {
        SSTool.invokeInGlobalThread {
            var para = params == nil ? Eic() : params!
            para["appVersion"] = Device.appVersion as AnyObject
            para["deviceType"] = Device.modelName as AnyObject
            para["systemVersion"] = Device.sysVersion as AnyObject
            para["deviceUUID"] = Device.deviceUUID as AnyObject
            para["system"] =  "iOS" as AnyObject
            let handle = createUrlAndHeaders(urlStr: urlStr)
            let URL = handle.url
            let headers = handle.headers
            let encoding:ParameterEncoding = (type.rawValue == HTTPMethod.get.rawValue) ? URLEncoding.default : JSONEncoding.default
            
            let _ = worker.request(URL, method: type, parameters: para, encoding: encoding, headers: headers).responseJSON(completionHandler: { (Response) in
                SSLog("数据地址:\(urlStr) 参数:\(para) 数据\(Response.result) 数据数据\(String(describing: Response.result.value))")
                
                switch Response.result {
                case .success:
                    guard let resp:[String:Any] = Response.result.value! as? [String:Any] else {
                        return
                    }
                    let infoData = (resp["data"] as? [String: AnyObject])
                    
                    let statusCode = (resp["status"] as? Int) ?? -1
                    if statusCode == SSCode.SUCCESS.code {
                        if let block = success {
                            block(infoData ?? [:])
                        }
                    }else if statusCode == SSCode.DEFAULT_ERROR_CODE_5000.code {
                        var message = ""
                        if let msg  = resp["message"]  {
                            message = (msg as? String) ?? ""
                        }
                        if let block = error {
                            block("\(statusCode)", message)
                        }
                    }else {
                        var message = ""
                        if let msg  = resp["message"]  {
                            message = (msg as? String) ?? ""
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
        }
        
    }
    
}

extension SSNetworkTool {
    
    class SSVersion:NSObject {
        static func request_version(params: Dic,success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure) {
            let url = String.init(format:SSLoginURL.loginWithCode)
            SSNetworkTool.requestVersion(type: .post,urlStr:"\(SSAPI.SSApiHost)\(url)", params:params,success:success,failed:failure,error:error)
        }
    }
    
    //  MARK:   收藏
    class SSCollect: NSObject {
        
        //添加收藏
        static func request_addCollection(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSCollectURL.addCollection)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params,success:
                success,failed:failure,error:error)
        }
        
        //获取收藏列表
        static func request_getFavoriteListAPP(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSCollectURL.getFavoriteListAPP)
            SSNetworkTool.request(type: .get,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params,success:
                success,failed:failure,error:error)
        }
        
    }
    
    
    //  MARK:   --搜索
    class SSSearch: NSObject {
        
        //全局搜索接口
        static func request_getsearchList(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSSearchURL.getsearchList)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params,success:
                success,failed:failure,error:error)
        }
        
        //查询历史记录
        static func request_getHistorySearchKeywords(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSSearchURL.getgetSearchKeywords)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params,success:
                success,failed:failure,error:error)
        }
        
        //查询发现 - 热门关键字 - 字典接口
        
    }
    
    //  MARK:   详情
    class SSFYDetail: NSObject {
        
        //楼盘网点详情
        static func request_getBuildingDetailbyBuildingId(params: Dic, success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSFYDetailURL.getBuildingDetailbyBuildingId)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params,success:
                success,failed:failure,error:error)
        }
        
        //楼盘-网点房源详情
        static func request_getBuildingFYDetailbyHouseId(params: Dic,success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure) {
            let url = String.init(format: SSFYDetailURL.getBuildingFYDetailbyHouseId)
            SSNetworkTool.request(type: .get,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params,success:
                success,failed:failure,error:error)
        }
        
        //楼盘-网点房源列表
        static func request_getBuildingFYList(params: Dic,success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure) {
            let url = String.init(format: SSFYDetailURL.getBuildingFYList)
            SSNetworkTool.request(type: .get,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params,success:
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
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params,success:
                success,failed:failure,error:error)
        }
        
        //请求首页推荐列表
        static func request_getselectBuildingApp(params: Dic,success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure) {
            let url = String.init(format: SSHomeURL.getselectBuildingApp)
            SSNetworkTool.request(type: .get,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params,success:
                success,failed:failure,error:error)
        }
    }
    
    
    class SSBasic:NSObject {
        
        //地铁线路接口
        static func request_getSubwayList(params: Dic,success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure) {
            let url = String.init(format:SSBasicURL.getSubwayList)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params,success:
                success,failed:failure,error:error)
        }
        
        //区域商圈接口
        static func request_getDistrictList(params: Dic,success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure) {
            let url = String.init(format:SSBasicURL.getDistrictList)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params,success:
                success,failed:failure,error:error)
        }
        
        //获取字典接口
        static func request_getDictionary(code: DictionaryCodeEnum,success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure) {
            var params = [String:AnyObject]()
            params["code"] = code.rawValue as AnyObject?
            let url = String.init(format:SSBasicURL.getDictionary)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params,success:
                success,failed:failure,error:error)
        }
        
    }
    
    
    //  MARK:   登录
    class SSLogin: NSObject {
        
        //验证码
        static func request_getSmsCode(params: Dic,success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format:SSLoginURL.getSmsCode)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params,success:
                success,failed:failure,error:error)
        }
        
        //短信登录
        static func request_loginWithCode(params: Dic,success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format:SSLoginURL.loginWithCode)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params,success:
                success,failed:failure,error:error)
        }
        
        //我想找接口
        static func request_addWantToFind(params: Dic,success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format:SSLoginURL.addWantToFind)
            SSNetworkTool.request(type: .post,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params,success:
                success,failed:failure,error:error)
        }
    }
    //  MARK:   我的
    class SSMine: NSObject {
        
        //绑定微信
        static func request_bindWeChat(params: Dic,success: @escaping SSSuccessedClosure,failure: @escaping SSFailedErrorClosure,error: @escaping SSErrorCodeMessageClosure)  {
            let url = String.init(format: SSMineURL.bindWeChat)
            SSNetworkTool.request(type: .get,urlStr: "\(SSAPI.SSApiHost)\(url)", params:params,success:
                success,failed:failure,error:error)
        }
    }
    
}



struct NetworkParams {
    //1：H5，2：IOS，3：安卓
    static let AppType = "2"
    
}
