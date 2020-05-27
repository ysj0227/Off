//
//  OfficeGoPlayerMediaControlInfoView.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

enum ThorPlayerMediaControlType {
    case volume
    case brightness
    case seekForward
    case seekBackward
    func icon() -> UIImage? {
        switch self {
        case .volume:
            return UIImage.init(named: "ic_video_volume")
        case .brightness:
            return UIImage.init(named:"ic_video_liangdu")
        case .seekForward:
            return UIImage.init(named:"ic_video_kuaijin")
        case .seekBackward:
            return UIImage.init(named:"ic_video_kuaitui")
        }
    }
}

class ThorPlayerMediaControlInfoView: UIView {

    var type:ThorPlayerMediaControlType? {
        didSet {
            iconView.image = type?.icon()
        }
    }
    var tip: String? {
        didSet {
            tipLabel.text = tip
        }
    }
    fileprivate var containerView = UIView()
    fileprivate var iconView = UIImageView()
    fileprivate var tipLabel = BaseLabel.init(localTitle: nil, textColor: .white, textFont: .appBold(14))
    convenience init (type: ThorPlayerMediaControlType, tip: String?) {
        self.init()
        self.addSubview(containerView)
        self.layer.cornerRadius = 8
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.7)
        containerView.addSubview(iconView)
        containerView.addSubview(tipLabel)
        containerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
        }
        iconView.snp.makeConstraints { (make) in
            make.centerX.top.equalToSuperview()
            make.size.equalTo(40)
        }
        tipLabel.snp.makeConstraints { (make) in
            make.centerX.bottom.equalToSuperview()
            make.top.equalTo(iconView.snp.bottom).offset(10)
            make.height.equalTo(20)
        }
        self.type = type
        self.tip = tip
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
