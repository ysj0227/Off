//
//  EmptyContentView.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class EmptyContentView: UIView {
    
    public enum ViewType {
        
        case normal
        case goldHistory
        case coinHistory
        case message
        case serverError
        case network
        case searchHistory
        case searchResult
        
        func imageName() -> String? {
            switch self {
            case .goldHistory:
                return "pic_No content"
            case .coinHistory:
                return "pic_No content"
            case .message:
                return "pic_news"
            case .serverError:
                return "pic_server"
            case .network:
                return "pic_No network"
            case .searchHistory:
                return "pic_No content"
            case .searchResult:
                return "pic_No content"
            default:
                return "pic_No content"
            }
        }
        
        func text() -> String? {
            switch self {
            case .goldHistory:
                return MissionsLocalizedString("暂无收益", comment: "")
            case .coinHistory:
                return MissionsLocalizedString("暂无收益", comment: "")
            case .message:
                return NSLocalizedString("还没有消息内容～", comment: "")
            case .serverError:
                return NSLocalizedString("服务器／系统错误～")
            case .network:
                return NSLocalizedString("网络好像有点奇怪～")
            case .searchHistory:
                return NSLocalizedString("暂无搜索记录~")
            case .searchResult:
                return NSLocalizedString("没有可用的内容")
            default:
                return NSLocalizedString("无数据")
            }
        }
    }
    
    var viewType: ViewType
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        if let imageName = viewType.imageName() {
            view.image = UIImage(named: imageName)
        }
        return view
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = kAppColor_C8C8C8
        label.text = viewType.text()
        return label
    }()
    
    init(type: ViewType) {
        viewType = type
        super.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: 100))
        setupView()
        isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(imageView)
        addSubview(label)
        imageView.snp.makeConstraints { (make) in
            make.bottom.equalTo(label.snp.top).offset(-20)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        label.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        layoutIfNeeded()
    }
    
    public func displaySize() -> CGSize {
        return CGSize(width: kWidth, height: (imageView.image?.size.height ?? 0) + 20 + label.frame.height)
    }
}
