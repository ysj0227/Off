//
//  CustomNavigationView.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import SnapKit

public enum NavgationTitleViewType {
    case none
    case backTitleRight
    case backTitleRightBlueBgclolor
    case locationSearchClear
    case homeSearchRightBlue                //搜索- 搜索框- 取消按钮
    case homeBackSearchRightBlue            //搜索结果- 返回- 搜索框- 地图按钮（暂时没有）
    case titleSearchBlueMessage
    case titleSearchViewBlueMessage
    case leftTitleRightBlueMessage
    case backMoreRightClear
    case collectTitleSearchBtn          //收藏列表 - 标题 - 搜索按钮
    case homeTitleViewSearchBtn         //首页滑动列表 - 标题切换 - 搜索按钮
    case HouseScheduleHeaderView        //预约房源详情- 标题- 返回- 下面标题 - 蓝色
    case messageTitleSearchBarSearchBtn //消息列表 - 标题 - -搜索框 搜索按钮
    
}

@objcMembers class ThorNavigationView: UIView {
    
    var leftButtonCallBack:(() -> Void)?
    
    var rightBtnClickBlock: (() -> Void)?
    
    //空白
    lazy var noneView: UIView = {
        let sepView = UIView()
        sepView.backgroundColor = kAppWhiteColor
        return sepView
    }()
    
    //返回 标题 右边按钮
    lazy var backTitleRightView: UIView = {
        let sepView = UIView()
        sepView.backgroundColor = kAppClearColor
        return sepView
    }()
    
    //首页定位搜索 定位按钮 搜索框
    lazy var locationSearchClearView: UIView = {
        let sepView = UIView()
        sepView.backgroundColor = kAppClearColor
        return sepView
    }()
    
    //搜索- 搜索框- 取消按钮
    lazy var homeSearchRightBlueView: UIView = {
        let sepView = UIView()
        sepView.backgroundColor = kAppBlueColor
        return sepView
    }()
    
    //搜索结果- 返回- 搜索框- 地图按钮（暂时没有）
    lazy var homeBackSearchRightBlueView: UIView = {
        let sepView = UIView()
        return sepView
    }()
    
    //消息 - 左文字 右搜索按钮
    lazy var titleSearchBlueMessageView: UIView = {
        let sepView = UIView()
        sepView.backgroundColor = kAppBlueColor
        return sepView
    }()
    //消息搜索- 左文字 右搜索框
    lazy var titleSearchViewBlueMessageView: UIView = {
        let sepView = UIView()
        sepView.backgroundColor = kAppColor_line_D8D8D8
        return sepView
    }()
    
    //消息 - 聊天页面- 返回-主标题 副标题 右
    lazy var leftTitleRightBlueMessageView: UIView = {
        let sepView = UIView()
        sepView.backgroundColor = kAppBlueColor
        return sepView
    }()
    
    //详情页面 - 返回- 收藏/聊天/分享
    lazy var backMoreRightClearView: UIView = {
        let sepView = UIView()
        sepView.backgroundColor = kAppClearColor
        return sepView
    }()
    
    //收藏列表 - 标题 - 搜索按钮
    lazy var collectTitleSearchBtnView: UIView = {
        let sepView = UIView()
        sepView.backgroundColor = kAppBlueColor
        return sepView
    }()
    
    //消息列表 - 标题 - -搜索框 搜索按钮
    lazy var messageTitleSearchBarSearchBtnView: UIView = {
        let sepView = UIView()
        sepView.backgroundColor = kAppBlueColor
        return sepView
    }()
    
    
    //首页滑动列表 - 标题切换 - 搜索按钮
    lazy var homeTitleViewSearchBtnView: UIView = {
        let sepView = UIView()
        sepView.backgroundColor = kAppBlueColor
        return sepView
    }()
    
    lazy var HouseScheduleHeaderView: UIView = {
        let sepView = UIView()
        return sepView
    }()
    
    
    lazy var leftButton: BaseButton = {
        let leftBtton = BaseButton()
        leftBtton.backgroundColor = kAppClearColor
        leftBtton.addTarget(self, action: #selector(leftBtnClick), for: .touchUpInside)
        return leftBtton
    }()
    lazy var rightButton: BaseButton = {
        let leftBtton = BaseButton()
        leftBtton.backgroundColor = kAppClearColor
        leftBtton.addTarget(self, action: #selector(rightBtnClick), for: .touchUpInside)
        return leftBtton
    }()
    lazy var titleLabel: BaseLabel = {
        let lab = BaseLabel()
        lab.font = FONT_MEDIUM_17
        lab.textAlignment = .center
        lab.backgroundColor = kAppClearColor
        return lab
    }()
    lazy var bottonLine: UIView = {
        let sepView = UIView()
        sepView.backgroundColor = kAppClearColor
        return sepView
    }()
    
    
    //定位按钮
    lazy var locationBtn: UIButton = {
        let btn = UIButton.init()
        btn.backgroundColor = kAppClearColor
        btn.addTarget(self, action: #selector(leftBtnClick), for: .touchUpInside)
        return btn
    }()
    
    //首页搜索框按钮
    lazy var searchBarBtnView: UIButton = {
        let btn = UIButton.init()
        btn.backgroundColor = kAppWhiteColor
        btn.addTarget(self, action: #selector(rightBtnClick), for: .touchUpInside)
        return btn
    }()
    
    //搜索框
    //    lazy var searchBarView: UISearchBar = {
    //        let view = UISearchBar.init()
    //        view.searchBarStyle = .minimal
    //        //        view.searchTextField.isUserInteractionEnabled = false
    //        view.backgroundColor = kAppClearColor
    //        //        view.searchTextField.textColor = kAppBlackColor
    //        //        view.searchTextField.font = FONT_15
    //        return view
    //    }()
    lazy var searchBarView: CustomerSearchBarview = {
        let view = CustomerSearchBarview.init(frame: CGRect(x: 80, y: kStatusBarHeight + (44 - 32) / 2.0, width: kWidth - 80 - left_pending_space_17, height: 32))
        return view
    }()
    lazy var alertButton: BaseButton = {
        let view = BaseButton()
        view.backgroundColor = kAppClearColor
        view.setImage(UIImage(named: "alertWhite"), for: .normal)
        return view
    }()
    lazy var messageButton: BaseButton = {
        let view = BaseButton()
        view.backgroundColor = kAppClearColor
        view.setImage(UIImage(named: "messageWhite"), for: .normal)
        return view
    }()
    lazy var shareButton: BaseButton = {
        let view = BaseButton()
        view.backgroundColor = kAppClearColor
        view.setImage(UIImage(named: "shareWhite"), for: .normal)
        return view
    }()
    
    var searchBarBtnTitleLabel: UILabel?
    
    var segHead: ButtonSelectItemView?
    
    var titleViewType: NavgationTitleViewType = .none
    
    init(type: NavgationTitleViewType) {
        super.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: kNavigationHeight))
        
        self.titleViewType = type
        setupView()
    }
    
    @objc func leftBtnClick() {
        guard let blockk = leftButtonCallBack else {
            return
        }
        blockk()
    }
    @objc func rightBtnClick() {
        guard let blockk = rightBtnClickBlock else {
            return
        }
        blockk()
    }
    
    private func setupView() {
        
        switch self.titleViewType {
        case .none:
            self.addSubview(noneView)
        case .backTitleRight:
            self.addSubview(backTitleRightView)
            backTitleRightView.snp.makeConstraints { (make) in
                make.leading.trailing.bottom.equalToSuperview()
                make.top.equalTo(kStatusBarHeight)
            }
            backTitleRightView.addSubview(leftButton)
            backTitleRightView.addSubview(rightButton)
            backTitleRightView.addSubview(titleLabel)
            backTitleRightView.addSubview(bottonLine)
            rightButton.isHidden = true
            self.leftButton.setImage(UIImage.init(named: "ic_back_b"), for: .normal)
            rightButton.titleLabel?.textAlignment = .center
            rightButton.clipsToBounds = true
            rightButton.layer.cornerRadius = button_cordious_2
            rightButton.titleLabel?.font = FONT_13
            backTitleRightView.backgroundColor = kAppWhiteColor
            titleLabel.textColor = kAppColor_333333
            
            leftButton.snp.makeConstraints { (make) in
                make.leading.equalToSuperview()
                make.height.equalTo(44)
                make.width.equalTo(52)
                make.bottom.equalToSuperview()
            }
            titleLabel.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(44)
            }
            rightButton.snp.makeConstraints { (make) in
                make.trailing.equalToSuperview().offset(-left_pending_space_17)
                make.height.equalTo(26)
                make.width.equalTo(52)
                make.centerY.equalTo(leftButton)
            }
            rightButton.clipsToBounds = true
            rightButton.layer.cornerRadius = 13
            bottonLine.snp.makeConstraints { (make) in
                make.leading.trailing.bottom.equalToSuperview()
                make.height.equalTo(1)
            }
        case .backTitleRightBlueBgclolor:
            self.backgroundColor = kAppBlueColor
            self.addSubview(backTitleRightView)
            backTitleRightView.snp.makeConstraints { (make) in
                make.leading.trailing.bottom.equalToSuperview()
                make.top.equalTo(kStatusBarHeight)
            }
            backTitleRightView.addSubview(leftButton)
            backTitleRightView.addSubview(rightButton)
            backTitleRightView.addSubview(titleLabel)
            backTitleRightView.addSubview(bottonLine)
            rightButton.isHidden = true
            self.leftButton.setImage(UIImage.init(named: "backWhite"), for: .normal)
            backTitleRightView.backgroundColor = kAppBlueColor
            titleLabel.textColor = kAppWhiteColor
            
            leftButton.snp.makeConstraints { (make) in
                make.leading.equalToSuperview()
                make.height.equalTo(44)
                make.width.equalTo(52)
                make.bottom.equalToSuperview()
            }
            titleLabel.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(44)
            }
            rightButton.snp.makeConstraints { (make) in
                make.trailing.equalToSuperview()
                make.height.equalTo(44)
                make.width.equalTo(52)
                make.bottom.equalToSuperview()
            }
            bottonLine.snp.makeConstraints { (make) in
                make.leading.trailing.bottom.equalToSuperview()
                make.height.equalTo(1)
            }
        case .locationSearchClear:
            self.addSubview(locationSearchClearView)
            locationSearchClearView.snp.makeConstraints { (make) in
                make.leading.trailing.bottom.equalToSuperview()
                make.top.equalTo(kStatusBarHeight)
            }
            locationBtn.setImage(UIImage(named: "locationWhite"), for: .normal)
            locationSearchClearView.addSubview(locationBtn)
            locationBtn.setTitleColor(kAppWhiteColor, for: .normal)
            locationBtn.snp.makeConstraints { (make) in
                make.leading.equalToSuperview()
                make.size.equalTo(CGSize(width: 80, height: 50))
                make.bottom.equalToSuperview()
            }
            locationSearchClearView.addSubview(searchBarBtnView)
            searchBarBtnView.clipsToBounds = true
            searchBarBtnView.layer.cornerRadius = 16
            searchBarBtnView.snp.makeConstraints { (make) in
                make.height.equalTo(32)
                make.leading.equalToSuperview().offset(80)
                make.centerY.equalTo(locationBtn.snp.centerY)
                make.trailing.equalToSuperview().offset(-left_pending_space_17)
            }
            
            let img = UIImageView.init(image: UIImage.init(named: "searchGray"))
            let searchLab = UILabel.init()
            searchLab.textColor = kAppColor_999999
            searchLab.text = "搜索"
            searchLab.font = FONT_15
            searchBarBtnView.addSubview(img)
            searchBarBtnView.addSubview(searchLab)
            img.snp.makeConstraints { (make) in
                make.leading.equalTo(13)
                make.centerY.equalToSuperview()
            }
            searchLab.snp.makeConstraints { (make) in
                make.leading.equalTo(img.snp.trailing).offset(3)
                //                make.trailing.equalToSuperview()
                make.centerY.equalToSuperview()
            }
        //搜索- 搜索框- 取消按钮
        case .homeSearchRightBlue:
            self.backgroundColor = kAppBlueColor
            homeSearchRightBlueView.backgroundColor = kAppClearColor
            self.addSubview(homeSearchRightBlueView)
            
            homeSearchRightBlueView.snp.makeConstraints { (make) in
                make.leading.trailing.bottom.equalToSuperview()
                make.top.equalTo(kStatusBarHeight)
            }
            
            searchBarView.searchTextfiled.placeholder = "Search"
            homeSearchRightBlueView.addSubview(searchBarView)
            
            rightButton.setTitle("取消", for: .normal)
            rightButton.setTitleColor(kAppWhiteColor, for: .normal)
            rightButton.titleLabel?.font = FONT_15
            homeSearchRightBlueView.addSubview(rightButton)
            rightButton.snp.makeConstraints { (make) in
                make.trailing.equalToSuperview()
                make.centerY.equalToSuperview()
                make.width.equalTo(52)
            }
            
            searchBarView.snp.makeConstraints { (make) in
                make.height.equalTo(32)
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().offset(left_pending_space_17)
                make.trailing.equalTo(rightButton.snp.leading)
            }
            
        //搜索结果- 返回- 搜索框-
        case .homeBackSearchRightBlue:
            self.backgroundColor = kAppBlueColor
            homeBackSearchRightBlueView.backgroundColor = kAppClearColor
            self.addSubview(homeBackSearchRightBlueView)
            homeBackSearchRightBlueView.snp.makeConstraints { (make) in
                make.leading.trailing.bottom.equalToSuperview()
                make.top.equalTo(kStatusBarHeight)
            }
            homeBackSearchRightBlueView.addSubview(leftButton)
            self.leftButton.setImage(UIImage.init(named: "backWhite"), for: .normal)
            leftButton.snp.makeConstraints { (make) in
                make.leading.equalToSuperview()
                make.height.equalTo(44)
                make.width.equalTo(52)
                make.bottom.equalToSuperview()
            }
            homeBackSearchRightBlueView.addSubview(searchBarBtnView)
            searchBarBtnView.clipsToBounds = true
            searchBarBtnView.layer.cornerRadius = 16
            searchBarBtnView.snp.makeConstraints { (make) in
                make.height.equalTo(32)
                make.leading.equalTo(leftButton.snp.trailing)
                make.centerY.equalTo(leftButton.snp.centerY)
                make.trailing.equalToSuperview().offset(-left_pending_space_17)
            }
            
            let img = UIImageView.init(image: UIImage.init(named: "searchGray"))
            searchBarBtnView.addSubview(img)
            
            searchBarBtnTitleLabel = UILabel.init()
            searchBarBtnTitleLabel?.textColor = kAppColor_999999
            searchBarBtnTitleLabel?.text = ""
            searchBarBtnTitleLabel?.font = FONT_15
            searchBarBtnView.addSubview(searchBarBtnTitleLabel ?? UILabel())
            img.snp.makeConstraints { (make) in
                make.leading.equalTo(13)
                make.centerY.equalToSuperview()
            }
            searchBarBtnTitleLabel?.snp.makeConstraints { (make) in
                make.leading.equalTo(img.snp.trailing).offset(3)
                //                make.trailing.equalToSuperview()
                make.centerY.equalToSuperview()
            }
        case .titleSearchBlueMessage:
            self.addSubview(titleSearchBlueMessageView)
            titleSearchBlueMessageView.snp.makeConstraints { (make) in
                make.leading.trailing.bottom.equalToSuperview()
                make.top.equalTo(kStatusBarHeight)
            }
        case .titleSearchViewBlueMessage:
            self.addSubview(titleSearchViewBlueMessageView)
            titleSearchViewBlueMessageView.snp.makeConstraints { (make) in
                make.leading.trailing.bottom.equalToSuperview()
                make.top.equalTo(kStatusBarHeight)
            }
        case .leftTitleRightBlueMessage:
            self.addSubview(leftTitleRightBlueMessageView)
            leftTitleRightBlueMessageView.snp.makeConstraints { (make) in
                make.leading.trailing.bottom.equalToSuperview()
                make.top.equalTo(kStatusBarHeight)
            }
        case .backMoreRightClear:
            self.backgroundColor = kAppClearColor
            backMoreRightClearView.backgroundColor = kAppClearColor
            self.addSubview(backMoreRightClearView)
            backMoreRightClearView.snp.makeConstraints { (make) in
                make.leading.trailing.bottom.equalToSuperview()
                make.top.equalTo(kStatusBarHeight)
            }
            
            backMoreRightClearView.addSubview(leftButton)
            backMoreRightClearView.addSubview(alertButton)
            backMoreRightClearView.addSubview(messageButton)
            backMoreRightClearView.addSubview(shareButton)
            self.leftButton.setImage(UIImage.init(named: "backWhite"), for: .normal)
            leftButton.snp.makeConstraints { (make) in
                make.leading.equalToSuperview()
                make.height.equalTo(44)
                make.width.equalTo(52)
                make.bottom.equalToSuperview()
            }
            
            shareButton.snp.makeConstraints { (make) in
                make.trailing.equalToSuperview().offset(-left_pending_space_17)
                make.height.equalTo(44)
                make.width.equalTo(52)
                make.centerY.equalTo(leftButton)
            }
            messageButton.snp.makeConstraints { (make) in
                make.trailing.equalTo(shareButton.snp.leading).offset(left_pending_space_17)
                make.height.equalTo(44)
                make.width.equalTo(52)
                make.centerY.equalTo(leftButton)
            }
            alertButton.snp.makeConstraints { (make) in
                make.trailing.equalTo(messageButton.snp.leading).offset(left_pending_space_17)
                make.height.equalTo(44)
                make.width.equalTo(52)
                make.centerY.equalTo(leftButton)
            }
        case .collectTitleSearchBtn:
            self.backgroundColor = kAppBlueColor
            collectTitleSearchBtnView.backgroundColor = kAppClearColor
            self.addSubview(collectTitleSearchBtnView)
            collectTitleSearchBtnView.snp.makeConstraints { (make) in
                make.leading.trailing.bottom.equalToSuperview()
                make.top.equalTo(kStatusBarHeight)
            }
            collectTitleSearchBtnView.addSubview(titleLabel)
            titleLabel.textAlignment = .left
            titleLabel.textColor = kAppWhiteColor
            titleLabel.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.trailing.equalToSuperview().inset(44)
                make.leading.equalToSuperview().inset(17)
            }
            collectTitleSearchBtnView.addSubview(rightButton)
            rightButton.setImage(UIImage.init(named: "searchWhite"), for: .normal)
            rightButton.snp.makeConstraints { (make) in
                make.trailing.equalToSuperview()
                make.height.equalTo(44)
                make.width.equalTo(52)
                make.bottom.equalToSuperview()
            }
        case .messageTitleSearchBarSearchBtn:
            self.backgroundColor = kAppBlueColor
            messageTitleSearchBarSearchBtnView.backgroundColor = kAppClearColor
            self.addSubview(messageTitleSearchBarSearchBtnView)
            messageTitleSearchBarSearchBtnView.snp.makeConstraints { (make) in
                make.leading.trailing.bottom.equalToSuperview()
                make.top.equalTo(kStatusBarHeight)
            }
            messageTitleSearchBarSearchBtnView.addSubview(titleLabel)
            titleLabel.text = "消息"
            titleLabel.textAlignment = .left
            titleLabel.textColor = kAppWhiteColor
            titleLabel.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.width.equalTo(56)
                make.leading.equalToSuperview().inset(17)
            }
            messageTitleSearchBarSearchBtnView.addSubview(rightButton)
            rightButton.setImage(UIImage.init(named: "searchWhite"), for: .normal)
            rightButton.snp.makeConstraints { (make) in
                make.trailing.equalToSuperview()
                make.height.equalTo(44)
                make.width.equalTo(52)
                make.centerY.equalToSuperview()
            }
            
            messageTitleSearchBarSearchBtnView.addSubview(searchBarView)
            searchBarView.snp.makeConstraints { (make) in
                make.trailing.equalToSuperview().offset(-left_pending_space_17)
                make.height.equalTo(32)
                make.centerY.equalToSuperview()
                make.leading.equalTo(titleLabel.snp.trailing)
            }
            
        case .homeTitleViewSearchBtn:
            self.backgroundColor = kAppBlueColor
            self.addSubview(homeTitleViewSearchBtnView)
            homeTitleViewSearchBtnView.snp.makeConstraints { (make) in
                make.leading.trailing.bottom.equalToSuperview()
                make.top.equalTo(kStatusBarHeight)
            }            
            homeTitleViewSearchBtnView.addSubview(rightButton)
            rightButton.setImage(UIImage.init(named: "searchWhite"), for: .normal)
            rightButton.snp.makeConstraints { (make) in
                make.trailing.equalToSuperview()
                make.height.equalTo(44)
                make.width.equalTo(52)
                make.bottom.equalToSuperview()
            }
            
            let segHeadFrame = CGRect.init(x: 10, y: kNavigationHeight, width: self.width - rightButton.width - 50, height: 58)
            
            segHead = ButtonSelectItemView.init(frame: segHeadFrame)
            homeTitleViewSearchBtnView.addSubview(segHead ?? ButtonSelectItemView.init(frame: segHeadFrame))
            segHead?.snp.makeConstraints { (make) in
                make.leading.equalToSuperview().offset(10)
                make.height.equalTo(58)
                make.trailing.equalTo(rightButton.snp.leading).offset(-10)
                make.centerY.equalTo(rightButton)
            }
        case .HouseScheduleHeaderView:
            self.frame = CGRect(x: 0, y: 0, width: kWidth, height: 241)
            self.backgroundColor = kAppBlueColor
            self.addSubview(HouseScheduleHeaderView)
            HouseScheduleHeaderView.snp.makeConstraints { (make) in
                make.top.leading.trailing.bottom.equalToSuperview()
            }
            HouseScheduleHeaderView.addSubview(leftButton)
            HouseScheduleHeaderView.addSubview(titleLabel)
            rightButton.isHidden = true
            self.leftButton.setImage(UIImage.init(named: "backWhite"), for: .normal)
            titleLabel.textColor = kAppWhiteColor
            
            leftButton.snp.makeConstraints { (make) in
                make.leading.equalToSuperview()
                make.height.equalTo(44)
                make.width.equalTo(52)
                make.top.equalTo(kStatusBarHeight)
            }
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(leftButton.snp.bottom)
                make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
                make.height.equalTo(40)
            }
        }
        
        //        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
