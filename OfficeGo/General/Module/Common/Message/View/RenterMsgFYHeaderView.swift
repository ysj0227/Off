//
//  RenterMsgFYHeaderView.swift
//  OfficeGo
//
//  Created by mac on 2020/5/25.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterMsgFYHeaderView: UICollectionReusableView {
    
    deinit {
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.backgroundColor = kAppClearColor
        setupViews()
    }
    
    //按钮点击方法
    var collectClick:((String) -> Void)?
    
    @objc func btnClick() {
        guard let blockk = collectClick else {
            return
        }
        blockk("selectedIndex")
    }
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppWhiteColor
        return view
    }()
    lazy var houseMainImg: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = button_cordious_2
        return view
    }()
    lazy var houseNameLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_11
        view.textColor = kAppColor_333333
        return view
    }()
    lazy var houselocationIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "locationGray")
        view.contentMode = .scaleAspectFit
        return view
    }()
    lazy var houseKmAndAddressLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_LIGHT_9
        view.textColor = kAppColor_333333
        return view
    }()
    lazy var houseTrafficIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "trafficIcon")
        view.contentMode = .scaleAspectFit
        return view
    }()
    lazy var houseTrafficLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_LIGHT_9
        view.textColor = kAppColor_333333
        return view
    }()
    lazy var housePriceLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_SEMBLOD_11
        view.textColor = kAppBlueColor
        return view
    }()
    lazy var houseFeatureView: FeatureView = {
        let view = FeatureView(frame: CGRect(x: 0, y: 0, width: self.width - left_pending_space_17 * 2, height: 18))
        //        view.featureString = "免费停车,近地铁,近地铁1"
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
    
    lazy var msgStartDescLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_LIGHT_9
        view.textColor = kAppColor_666666
        return view
    }()
    lazy var collectBtn: UIButton = {
        let btn = UIButton.init()
        btn.setTitleColor(kAppColor_666666, for: .normal)
        btn.setTitleColor(kAppColor_666666, for: .selected)
        btn.setTitle("收藏", for: .normal)
        btn.setTitle("已收藏", for: .selected)
        btn.setImage(UIImage.init(named: "collect"), for: .normal)
        btn.setImage(UIImage.init(named: "collectSel"), for: .selected)
        btn.titleLabel?.font = FONT_LIGHT_9
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        return btn
    }()
    
    func updatelayout() {
        
    }
    func setupViews() {
        addSubview(contentView)
        contentView.addSubview(houseMainImg)
        contentView.addSubview(houseNameLabel)
        contentView.addSubview(houselocationIcon)
        contentView.addSubview(houseKmAndAddressLabel)
        contentView.addSubview(houseTrafficIcon)
        contentView.addSubview(houseTrafficLabel)
        contentView.addSubview(housePriceLabel)
        contentView.addSubview(houseFeatureView)
        contentView.addSubview(lineView)
        contentView.addSubview(msgStartDescLabel)
        contentView.addSubview(collectBtn)
        contentView.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview().inset(10)
        }
        houseMainImg.snp.makeConstraints { (make) in
            make.leading.top.equalTo(left_pending_space_17)
            make.size.equalTo(71)
        }
        houseNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(houseMainImg.snp.trailing).offset(6)
            make.trailing.equalToSuperview().offset(-left_pending_space_17)
            make.top.equalTo(houseMainImg)
        }
        houselocationIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(houseNameLabel)
            make.top.equalTo(houseNameLabel.snp.bottom)
            make.height.equalTo(15)
            make.width.equalTo(10)
        }
        houseKmAndAddressLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(houselocationIcon.snp.trailing).offset(4)
            make.centerY.equalTo(houselocationIcon)
            make.trailing.equalTo(houseNameLabel)
        }
        houseTrafficIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(houseNameLabel)
            make.top.equalTo(houselocationIcon.snp.bottom)
            make.height.equalTo(15)
            make.width.equalTo(10)
        }
        houseTrafficLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(houseTrafficIcon.snp.trailing).offset(4)
            make.centerY.equalTo(houseTrafficIcon)
            make.trailing.equalTo(houseNameLabel)
        }
        housePriceLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(houseNameLabel)
            make.top.equalTo(houseTrafficIcon.snp.bottom)
        }
        houseFeatureView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.top.equalTo(houseMainImg.snp.bottom).offset(7)
            make.height.equalTo(18)
        }
        lineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(houseFeatureView)
            make.top.equalTo(houseFeatureView.snp.bottom).offset(7)
            make.height.equalTo(1)
        }
        msgStartDescLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(houseFeatureView)
            make.trailing.equalTo(60)
            make.top.equalTo(lineView.snp.bottom).offset(7)
            make.height.equalTo(13 + 9*2)
        }
        collectBtn.snp.makeConstraints { (make) in
            make.centerY.height.equalTo(msgStartDescLabel)
            make.leading.equalTo(msgStartDescLabel.snp.trailing)
            make.trailing.equalToSuperview()
        }
//        collectBtn.layoutButton(.imagePositionLeft, space: 8)
    }
}


class RenterMsgBtnView: UIView {
    
    var selectModel: HouseSelectModel?
    
    var phoneChangeBtn: UIButton = {
        let button = UIButton.init()
        button.setTitle("换电话", for: .normal)
        button.tag = 1
        button.setImage(UIImage(named: "phoneGray"), for: .normal)
        button.setImage(UIImage(named: "phoneBlue"), for: .selected)
        button.setTitleColor(kAppColor_666666, for: .normal)
        button.titleLabel?.font = FONT_10
        return button
    }()
    
    var wechatChangeBtn: UIButton = {
        let button = UIButton.init()
        button.setTitle("换微信", for: .normal)
        button.tag = 2
        button.setImage(UIImage(named: "wechatGary"), for: .normal)
        button.setImage(UIImage(named: "wechatBlue"), for: .selected)
        button.setTitleColor(kAppColor_666666, for: .normal)
        button.titleLabel?.font = FONT_10
        button.setTitleColor(kAppColor_666666, for: .normal)
        return button
    }()
    var scheduleFyBtn: UIButton = {
        let button = UIButton.init()
        button.setTitle("预约看房", for: .normal)
        button.tag = 3
        button.setImage(UIImage(named: "scheduleBlue"), for: .normal)
        button.setTitleColor(kAppColor_666666, for: .normal)
        button.titleLabel?.font = FONT_10
        return button
    }()
    var alertBtn: UIButton = {
        let button = UIButton.init()
        button.setTitle("举报", for: .normal)
        button.tag = 4
        button.setImage(UIImage(named: "alertBlue"), for: .normal)
        button.setTitleColor(kAppColor_666666, for: .normal)
        button.titleLabel?.font = FONT_10
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    var itemSelectCallBack:((Int) -> Void)?
    
    
    private func setupView() {
        
        self.backgroundColor = kAppWhiteColor
        
        addSubview(phoneChangeBtn)
        addSubview(wechatChangeBtn)
        addSubview(scheduleFyBtn)
        /*
        addSubview(alertBtn)*/
        
        let width = self.width / 3.0
        
        phoneChangeBtn.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(width)
        }
        wechatChangeBtn.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(width)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(width)
        }
        scheduleFyBtn.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(width * 2)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(width)
        }
        /*
        alertBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(width)
        }*/
        
        phoneChangeBtn.layoutButton(.imagePositionTop, space: 10)
        wechatChangeBtn.layoutButton(.imagePositionTop, space: 10)
        scheduleFyBtn.layoutButton(.imagePositionTop, space: 10)
        /*
        alertBtn.layoutButton(.imagePositionTop, space: 10)*/

        phoneChangeBtn.addTarget(self, action: #selector(showSortSelectView(btn:)), for: .touchUpInside)
        wechatChangeBtn.addTarget(self, action: #selector(showSortSelectView(btn:)), for: .touchUpInside)
        scheduleFyBtn.addTarget(self, action: #selector(showSortSelectView(btn:)), for: .touchUpInside)
        alertBtn.addTarget(self, action: #selector(showSortSelectView(btn:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func showSortSelectView(btn: UIButton) {
        guard let blockk = itemSelectCallBack else {
            return
        }
        blockk(btn.tag)
    }
    
}


class RenterMsgScheduleAlertView: UIButton {
        
    var timeIcon: BaseImageView = {
        let view = BaseImageView.init()
        view.image = UIImage(named: "scheduleBlueM")
        return view
    }()
    
    var label: UILabel = {
        let view = UILabel.init()
        view.text = "你有一个看房邀约待接受"
        view.textColor = kAppColor_333333
        view.font = FONT_11
        return view
    }()
    var lookLabel: UILabel = {
        let view = UILabel.init()
        view.text = "查看"
        view.textColor = kAppBlueColor
        view.font = FONT_11
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    var itemSelectCallBack:((Int) -> Void)?
    
    
    private func setupView() {
        
        self.isUserInteractionEnabled = true
        self.backgroundColor = kAppWhiteColor
        
        addSubview(timeIcon)
        addSubview(label)
        addSubview(lookLabel)
        
        
        timeIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(12)
            make.centerY.equalToSuperview()
        }
        label.snp.makeConstraints { (make) in
            make.leading.equalTo(timeIcon.snp.trailing).offset(7)
            make.centerY.equalToSuperview()
        }
        lookLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-left_pending_space_17)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
}
