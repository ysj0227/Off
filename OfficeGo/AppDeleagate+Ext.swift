//
//  AppDeleaget+Ext.swift
//  OfficeGo
//
//  Created by Asun on 2020/6/3.
//  Copyright © 2020 Senwei. All rights reserved.
//

#if DEBUG
import CocoaDebug
#endif

extension AppDelegate {
    
    public func InstallCocoaDebug() {
        #if DEBUG
//        监听网址Host  自己写
//        CocoaDebug.onlyURLs = [APIHost.BaseUrl,APIHost.H5PageUrl]
//        CocoaDebug.serverURL = APIHost.BaseUrl
        CocoaDebug.enable()
        #endif
    }
    
}
