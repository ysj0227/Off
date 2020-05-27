//
//  AnimateRefreshFooter.swift
//  OfficeGo
//
//  Created by keke on 11/1/18.
//  Copyright © 2018 RRTV. All rights reserved.
//

import UIKit
import MJRefresh

class AnimateRefreshFooter: MJRefreshAutoStateFooter {
    override func prepare() {
        super.prepare()
        stateLabel?.font = .appRegular(12)
        stateLabel?.textColor = kAppColor_C8C8C8
        self.setTitle(NSLocalizedString("MJRefreshAutoFooterIdleText", comment: ""), for: .idle)
        self.setTitle(NSLocalizedString("MJRefreshAutoFooterRefreshingText", comment: ""), for: .refreshing)
        self.setTitle(NSLocalizedString("MJRefreshAutoFooterNoMoreDataText", comment: ""), for: .noMoreData)
    }
}
