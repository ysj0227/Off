//
//  OwnerNoIdentifyShowView.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/10/20.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

//MARK:  添加房源第一次弹框
class OWnerAddFYFirstAlertView: UIView {
    
    lazy var blackAlphabgView: UIButton = {
        let button = UIButton.init()
        button.backgroundColor = kAppAlphaWhite0_alpha_7
        return button
    }()
    
    lazy var imageView : BaseImageView = {
        let imageView = BaseImageView()
        imageView.image = UIImage.init(named: "identifyPassAlert")
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = kAppWhiteColor
        view.textAlignment = .center
        view.text = "审核通过，可立即添加房源"
        view.font = FONT_14
        return view
    }()
    
    lazy var identifyBtn: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = button_cordious_15
        button.backgroundColor = kAppBlueColor
        button.setTitle("我知道了", for: .normal)
        button.titleLabel?.font = FONT_MEDIUM_14
        button.addTarget(self, action: #selector(clickIdentify), for: .touchUpInside)
        return button
    }()
    
    @objc func clickIdentify() {
        UserTool.shared.isShowAddFYGuide = true
        self.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        addSubview(blackAlphabgView)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(identifyBtn)
        blackAlphabgView.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.top.equalTo(kNavigationHeight - 20)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview()
        }
        identifyBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(27)
            make.size.equalTo(CGSize(width: 130, height: 30))
        }
    }
    
    // MARK: - 弹出view显示 - 排序
    func ShowOWnerAddFYFirstAlertView(clearButtonCallBack: @escaping (() -> Void), sureHouseSortButtonCallBack: @escaping (() -> Void)) -> Void {
        UIApplication.shared.keyWindow?.subviews.forEach({ (view) in
            if view.isKind(of: OWnerAddFYFirstAlertView.self) {
                view.removeFromSuperview()
            }
        })
        
        self.frame = CGRect(x: 0.0, y: 0, width: kWidth, height: kHeight)
        UIApplication.shared.keyWindow?.addSubview(self)
    }
}


class BuildingStautsCell: UIView {
    
    lazy var topLineView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    lazy var timeIcon: BaseImageView = {
        let view = BaseImageView.init()
        return view
    }()
    lazy var bottomLineView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var statusLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_13
        view.textColor = kAppColor_333333
        return view
    }()
    
    lazy var timeLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_11
        view.textColor = kAppColor_666666
        return view
    }()
    
    lazy var identifyBtn: UIButton = {
        let view = UIButton.init()
        view.isHidden = true
        view.setTitle("重新认证", for: .normal)
        view.clipsToBounds = true
        view.layer.borderWidth = 0.7
        view.layer.borderColor = kAppBlueColor.cgColor
        view.layer.cornerRadius = button_cordious_4
        view.setTitleColor(kAppBlueColor, for: .normal)
        view.titleLabel?.font = FONT_13
        view.addTarget(self, action: #selector(identifyClick), for: .touchUpInside)
        return view
    }()
    
    
    var identifyClickBlock: (() -> Void)?
    
    @objc func identifyClick() {
        guard let blockk = identifyClickBlock else {
            return
        }
        blockk()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupViews()
    }
    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupViews()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    class func rowHeight() -> CGFloat {
        return 27 + 45
    }
    
    func setupViews() {

        self.addSubview(topLineView)
        self.addSubview(bottomLineView)
        self.addSubview(timeIcon)
        self.addSubview(statusLabel)
        self.addSubview(timeLabel)
        self.addSubview(identifyBtn)

        timeIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.top.equalTo(23)
            make.size.equalTo(28)
        }
        topLineView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalTo(timeIcon)
            make.bottom.equalTo(timeIcon.snp.top)
            make.width.equalTo(2.0)
        }
        bottomLineView.snp.makeConstraints { (make) in
            make.top.equalTo(timeIcon.snp.bottom)
            make.centerX.equalTo(timeIcon)
            make.bottom.equalToSuperview()
            make.width.equalTo(2.0)
        }
        statusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(timeIcon)
            make.leading.equalTo(timeIcon.snp.trailing).offset(10)
            make.width.equalTo(kWidth - left_pending_space_17 - 28 - 10 - 100)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(statusLabel)
            make.top.equalTo(statusLabel.snp.bottom).offset(3)
        }
        identifyBtn.snp.makeConstraints{ (make) in
            make.trailing.equalToSuperview().inset(left_pending_space_17)
            make.size.equalTo(CGSize(width: 68, height: 26))
            make.centerY.equalTo(timeIcon)
        }
        
    }
    
}

//MARK:  楼盘认证状态
class OWnerIdentifyStatusView: UIView {
    
    lazy var topView : BuildingStautsCell = {
        let view = BuildingStautsCell()
        view.bottomLineView.image = UIImage.init(named: "greenLine")
        return view
    }()
    
    lazy var mediumView : BuildingStautsCell = {
        let view = BuildingStautsCell()
        return view
    }()
    
    lazy var bottomView : BuildingStautsCell = {
        let view = BuildingStautsCell()
        return view
    }()
    
    
    ///驳回原因
    lazy var rejectReasonLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textColor = kAppRedColor
//        view.backgroundColor = kAppRedColor
        view.font = FONT_13
        return view
    }()
    
    lazy var rejectBg : UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = button_cordious_4
        view.backgroundColor = kAppLightRedColor
        return view
    }()
    
    var sureIdentifyButtonCallBack:(() -> Void)?
    
    @objc func clickIdentify() {
        guard let blockk = sureIdentifyButtonCallBack else {
            return
        }
        blockk()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        addSubview(topView)
        addSubview(mediumView)
        addSubview(bottomView)
        addSubview(rejectBg)
        rejectBg.addSubview(rejectReasonLabel)
        
        topView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(72)
        }
        mediumView.snp.makeConstraints { (make) in
            make.height.leading.trailing.equalTo(topView)
            make.top.equalTo(topView.snp.bottom)
        }
        bottomView.snp.makeConstraints { (make) in
            make.height.leading.trailing.equalTo(mediumView)
            make.top.equalTo(mediumView.snp.bottom)
        }
        
        bottomView.identifyClickBlock = { [weak self] in
            self?.clickIdentify()
        }
    
    }
    ///根据楼盘状态展示
    var buildingListViewModel : OwnerBuildingListViewModel? {
        didSet {
            ///根据楼盘状态展示样式设置楼盘样式
            ///-1:不是管理员 暂无权限编辑楼盘(临时楼盘),0: 下架(未发布),1: 上架(已发布) ;2:资料待完善 ,3: 置顶推荐;4:已售完;5:删除;6待审核7已驳回 注意：（IsTemp为1时，status状态标记 1:待审核 -转6 ,2:已驳回 -转7 ）
            if buildingListViewModel?.isTemp == true {
                
            }
            /*
             1: 上架(已发布)
            待审核： status"= 6 ｜｜  isTemp": = 1
            资料待完善 status = 2:资料待完善
            status 7已驳回*/
            
            if buildingListViewModel?.status == 1 || buildingListViewModel?.status == 2 {
                
                //提交认证 绿
                //审核 绿
                //审核通过 绿
                topView.timeIcon.image = UIImage.init(named: "identifyGreen")
                topView.statusLabel.text = "提交认证"
                topView.timeLabel.text = buildingListViewModel?.startTimeString

                mediumView.timeIcon.image = UIImage.init(named: "identifyGreen")
                mediumView.statusLabel.text = "审核"
                mediumView.timeLabel.text = ""
                mediumView.topLineView.image = UIImage.init(named: "greenLine")
                mediumView.bottomLineView.image = UIImage.init(named: "greenLine")

                bottomView.timeIcon.image = UIImage.init(named: "identifyGreen")
                bottomView.statusLabel.text = "审核通过"
                bottomView.timeLabel.text = buildingListViewModel?.endTimeString
                bottomView.topLineView.image = UIImage.init(named: "greenLine")
                //bottomView.bottomLineView.image = UIImage.init(named: "greenLine")

                bottomView.statusLabel.textColor = kAppColor_333333

                bottomView.identifyBtn.isHidden = true

                rejectBg.isHidden = true

            }else if buildingListViewModel?.status == 7 {
                
                //提交认证 绿
                //审核 绿
                //认证未通过 红
                topView.timeIcon.image = UIImage.init(named: "identifyGreen")
                topView.statusLabel.text = "提交认证"
                topView.timeLabel.text = buildingListViewModel?.startTimeString

                mediumView.timeIcon.image = UIImage.init(named: "identifyGreen")
                mediumView.statusLabel.text = "审核"
                mediumView.timeLabel.text = ""
                mediumView.topLineView.image = UIImage.init(named: "greenLine")
                mediumView.bottomLineView.image = UIImage.init(named: "greenLine")
                
                bottomView.timeIcon.image = UIImage.init(named: "identifyRed")
                bottomView.statusLabel.text = "认证未通过"
                bottomView.timeLabel.text = buildingListViewModel?.endTimeString
                bottomView.topLineView.image = UIImage.init(named: "greenLine")
//                bottomView.bottomLineView.image = UIImage.init(named: "greenLine")

                bottomView.identifyBtn.isHidden = false

                bottomView.statusLabel.textColor = kAppColor_333333

                if let remark = buildingListViewModel?.remarkString {
                    
                    rejectBg.isHidden = false

                    rejectReasonLabel.text = remark

                    let size = rejectReasonLabel.text?.boundingRect(with: CGSize(width: kWidth - (left_pending_space_17 + 8) * 2, height: 8000), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : FONT_13], context: nil)
                    
                    var height: CGFloat = 0
                    height = size?.height ?? 0
                    
                    rejectBg.snp.remakeConstraints { (make) in
                        make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
                        make.top.equalTo(bottomView.snp.bottom)
                        make.height.equalTo(height + 8 * 2)
                    }
                    
                    rejectReasonLabel.snp.remakeConstraints { (make) in
                        make.top.bottom.leading.trailing.equalToSuperview().inset(8)
                    }
                    
                }

            }else if buildingListViewModel?.status == 6 || buildingListViewModel?.isTemp == true {
                //提交认证 绿
                //审核 橙
                //审核通过 灰
                
                topView.timeIcon.image = UIImage.init(named: "identifyGreen")
                topView.statusLabel.text = "提交认证"
                topView.timeLabel.text = buildingListViewModel?.startTimeString

                mediumView.timeIcon.image = UIImage.init(named: "identifyOrange")
                mediumView.statusLabel.text = "审核中"
                mediumView.timeLabel.text = ""
                mediumView.topLineView.image = UIImage.init(named: "greenLine")
                mediumView.bottomLineView.image = UIImage.init(named: "grayLine")

                bottomView.timeIcon.image = UIImage.init(named: "identifyGray")
                bottomView.statusLabel.text = "审核通过"
                bottomView.timeLabel.text = ""
                bottomView.topLineView.image = UIImage.init(named: "grayLine")
//                mediumView.bottomLineView.image = UIImage.init(named: "grayLine")
                bottomView.statusLabel.textColor = kAppColor_666666

                bottomView.identifyBtn.isHidden = true

                rejectBg.isHidden = true

            }
            
        }
    }
    
}


//MARK:  未认证-去认证
class OWnerToIdentifyView: UIView {
    
//    lazy var topIconImageView : BaseImageView = {
//        let imageView = BaseImageView()
//        imageView.image = UIImage.init(named: "iconBg")
//        imageView.backgroundColor = kAppWhiteColor
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()
    
    lazy var imageView : BaseImageView = {
        let imageView = BaseImageView()
        imageView.image = UIImage.init(named: "toIdentify")
        imageView.backgroundColor = kAppWhiteColor
        return imageView
    }()
    
    lazy var identifyBtn: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = button_cordious_15
        button.backgroundColor = kAppBlueColor
        button.setTitle("去认证", for: .normal)
        button.titleLabel?.font = FONT_MEDIUM_15
        button.addTarget(self, action: #selector(clickIdentify), for: .touchUpInside)
        return button
    }()
    
    var sureIdentifyButtonCallBack:(() -> Void)?
    
    @objc func clickIdentify() {
        guard let blockk = sureIdentifyButtonCallBack else {
            return
        }
        blockk()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
//        addSubview(topIconImageView)
        addSubview(imageView)
        addSubview(identifyBtn)
//        topIconImageView.snp.makeConstraints { (make) in
//            make.top.leading.trailing.equalToSuperview()
//            make.height.equalTo(74)
//        }
        imageView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.top.equalToSuperview()
            make.height.equalTo(kWidth - left_pending_space_17 * 2)
        }
        identifyBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(37)
            make.size.equalTo(CGSize(width: 130, height: 30))
        }
    }
}


//MARK:  未认证-弹框
class OwnerNoIdentifyShowView: UIView {
        
    lazy var blackAlphabgView: UIButton = {
        let button = UIButton.init(frame: self.frame)
        button.backgroundColor = kAppAlphaWhite0_alpha_7
        button.addTarget(self, action: #selector(clickRemoveFromSuperview), for: .touchUpInside)
        return button
    }()
    
    lazy var bgView : UIView = {
        let view = UIView()
        view.frame = CGRect(x: (kWidth - 300) / 2.0, y: (kHeight - 300) / 2.0, width: 300, height: 350)
        view.backgroundColor = kAppWhiteColor
        view.clipsToBounds = true
        view.layer.cornerRadius = button_cordious_15
        return view
    }()
    
    lazy var closeBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: (kWidth - 300) / 2.0 + 300 - 40, y: (kHeight - 300) / 2.0, width: 40, height: 40))
        button.setImage(UIImage.init(named: "closeGray"), for: .normal)
        button.addTarget(self, action: #selector(clickRemoveFromSuperview), for: .touchUpInside)
        return button
    }()
    
    
    lazy var cycleView:CycleView = {
        let cycleview = CycleView(frame: CGRect(x: (kWidth - 300) / 2.0, y: (kHeight - 280) / 2.0 + 40, width: 300, height: 200 + 80))
        cycleview.invalidateTimer()
        cycleview.mode = .scaleAspectFit
        cycleview.isAlert = true
        cycleview.pageColor = kAppLightBlueColor
        cycleview.currentPageColor = kAppBlueColor
        cycleview.imageURLStringArr = ["noIdentify1", "noIdentify2", "noIdentify3", "noIdentify4"]
        cycleview.titleArr = ["成为房东，房源全网触达", "720 VR全方位呈现房源", "与客户线上直接沟通", "交易数据保密，无中介费"]
        return cycleview
    }()
    
    
    lazy var identifyBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: (kWidth - 130) / 2.0 , y: (kHeight - 300) / 2.0 + 40 + 220, width: 130, height: 30))
        button.clipsToBounds = true
        button.layer.cornerRadius = button_cordious_15
        button.backgroundColor = kAppBlueColor
        button.setTitle("去认证", for: .normal)
        button.titleLabel?.font = FONT_MEDIUM_15
        button.addTarget(self, action: #selector(clickIdentify), for: .touchUpInside)
        return button
    }()
    
    // MARK: - block
    fileprivate var clearButtonCallBack:(() -> Void)?
    
    fileprivate var sureIdentifyButtonCallBack:(() -> Void)?
                
    @objc func clickRemoveFromSuperview() {
        guard let blockk = clearButtonCallBack else {
            return
        }
        blockk()
        selfRemove()
    }
    
    @objc func clickIdentify() {
        guard let blockk = sureIdentifyButtonCallBack else {
            return
        }
        blockk()
        selfRemove()
    }
    
    func selfRemove() {
        self.removeFromSuperview()
    }
    
    
    // MARK: - 弹出view显示 - 排序
    func ShowOwnerNoIdentifyShowView(clearButtonCallBack: @escaping (() -> Void), sureHouseSortButtonCallBack: @escaping (() -> Void)) -> Void {
        UIApplication.shared.keyWindow?.subviews.forEach({ (view) in
            if view.isKind(of: OwnerNoIdentifyShowView.self) {
                view.removeFromSuperview()
            }
        })
        
        self.frame = CGRect(x: 0.0, y: 0, width: kWidth, height: kHeight)
        self.clearButtonCallBack = clearButtonCallBack
        self.sureIdentifyButtonCallBack = sureHouseSortButtonCallBack
        UIApplication.shared.keyWindow?.addSubview(self)
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setUpSubviews()
    }
    
    func setUpSubviews() {
        addSubview(blackAlphabgView)
        addSubview(bgView)
        addSubview(closeBtn)
        addSubview(cycleView)
        addSubview(identifyBtn)
    }
}

