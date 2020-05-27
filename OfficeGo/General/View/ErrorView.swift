//
//  ErrorView.swift
//  OfficeGo
//
//  Created by keke on 10/19/18.
//  Copyright © 2018 RRTV. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ErrorView: UIView {
    public enum ViewType {
        case serverError
        case network
        case timeout
        
        func imageName() -> String? {
            switch self {
            case .serverError:
                return "pic_server"
            case .network, .timeout:
                return "pic_No network"
            }
        }
        
        func text() -> String? {
            switch self {
            case .serverError:
                return NSLocalizedString("服务器／系统错误～", comment: "")
            case .network:
                return NSLocalizedString("网络好像有点奇怪～", comment: "")
            case .timeout:
                return NSLocalizedString("连接超时，请稍后重试", comment: "")
            }
        }
    }
    
    var viewType: ViewType
    
    let disposeBag = DisposeBag()
    
    var retryBlock: (() -> Void)?
    
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
    
    lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(NSLocalizedString("刷新一下", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 12
        button.backgroundColor = kAppColor_FF9600
        button.rx.tap.subscribe(onNext: { [weak self] in
            self?.retryBlock?()
        }).disposed(by: disposeBag)
        return button
    }()
    
    init(type: ViewType) {
        viewType = type
        super.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: 100))
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(imageView)
        addSubview(label)
        addSubview(button)

        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        label.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        button.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(24)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        layoutIfNeeded()
    }
    
    public func displaySize() -> CGSize {
        return CGSize(width: kWidth, height: (imageView.image?.size.height ?? 0) + 20 + label.frame.height + 20 + button.frame.height)
    }
}
