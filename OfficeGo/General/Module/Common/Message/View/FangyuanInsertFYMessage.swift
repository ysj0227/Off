//
//  FangyuanInsertFYMessage.swift
//  OfficeGo
//
//  Created by mac on 2020/5/26.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class FangyuanInsertFYMessage: RCMessageContent, NSCoding {
    ///1:从楼盘进入返回building对象,2:从房源进入返回house对象
    var isBuildOrHouse : Int?
    ///1是办公楼，2是共享办公
    var btype : Int?
    var buildingId : Int?
    var houseId : Int?
    
    // 测试消息的内容
    var content: String = ""
    
    // 测试消息的附加信息
    var extraMessage: String?
    ///封面图
    var mainPic : String?
    var createTimeAndByWho : String?
    var isFavorite : Bool = false
    var buildingName : String?
    var houseName : String?
    ///2.1km | 徐汇区 · 漕河泾
    var distanceDistrictString: String?
    ///步行5分钟到 | 2号线 ·东昌路站
    var walkTimesubwayAndStationString: String?
    ///日租金
    var dayPriceString: String?
    //MARK: TODO: 只有插入消息 - 用字符串
    ///特色
    var tagsString: String?
    
    // 根据参数创建消息对象
    class func messageWithContent(content: String) -> FangyuanInsertFYMessage {
        let testMessage = FangyuanInsertFYMessage()
        testMessage.content = content
        return testMessage
    }
    
    // 返回消息的存储策略
    override class func persistentFlag() -> RCMessagePersistent {
        return RCMessagePersistent(rawValue: RCMessagePersistent.MessagePersistent_ISPERSISTED.rawValue | RCMessagePersistent.MessagePersistent_ISCOUNTED.rawValue) ?? RCMessagePersistent.MessagePersistent_ISCOUNTED
    }
    
    override init() {
        super.init()
    }
    
    // NSCoding
    required init(coder aDecoder: NSCoder) {
        super.init()
        isBuildOrHouse = aDecoder.decodeObject(forKey: "isBuildOrHouse") as? Int ?? 0
        btype = aDecoder.decodeObject(forKey: "btype") as? Int ?? 0
        buildingId = aDecoder.decodeObject(forKey: "buildingId") as? Int ?? 0
        houseId = aDecoder.decodeObject(forKey: "houseId") as? Int ?? 0
        content = aDecoder.decodeObject(forKey: "content") as? String ?? ""
        extraMessage = aDecoder.decodeObject(forKey: "extraMessage") as? String ?? ""
        mainPic = aDecoder.decodeObject(forKey: "mainPic") as? String ?? ""
        createTimeAndByWho = aDecoder.decodeObject(forKey: "createTimeAndByWho") as? String ?? ""
        isFavorite = aDecoder.decodeObject(forKey: "isFavorite") as? Bool ?? false
        buildingName = aDecoder.decodeObject(forKey: "buildingName") as? String ?? ""
        houseName = aDecoder.decodeObject(forKey: "houseName") as? String ?? ""
        distanceDistrictString = aDecoder.decodeObject(forKey: "distanceDistrictString") as? String ?? ""
        walkTimesubwayAndStationString = aDecoder.decodeObject(forKey: "walkTimesubwayAndStationString") as? String ?? ""
        dayPriceString = aDecoder.decodeObject(forKey: "dayPriceString") as? String ?? ""
        tagsString = aDecoder.decodeObject(forKey: "tagsString") as? String ?? ""
    }
    
    // NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(isBuildOrHouse, forKey: "isBuildOrHouse")
        aCoder.encode(btype, forKey: "btype")
        aCoder.encode(buildingId, forKey: "buildingId")
        aCoder.encode(houseId, forKey: "houseId")
        aCoder.encode(content, forKey: "content")
        aCoder.encode(extraMessage, forKey: "extraMessage")
        aCoder.encode(mainPic, forKey: "mainPic")
        aCoder.encode(createTimeAndByWho, forKey: "createTimeAndByWho")
        aCoder.encode(isFavorite, forKey: "isFavorite")
        aCoder.encode(buildingName, forKey: "buildingName")
        aCoder.encode(houseName, forKey: "houseName")
        aCoder.encode(distanceDistrictString, forKey: "distanceDistrictString")
        aCoder.encode(walkTimesubwayAndStationString, forKey: "walkTimesubwayAndStationString")
        aCoder.encode(dayPriceString, forKey: "dayPriceString")
        aCoder.encode(tagsString, forKey: "tagsString")
    }
    
    // 序列化，将消息内容编码成 json
    override func encode() -> Data! {
        var dataDict: [String : Any] = [:]
        
        if let isBuildOrHouse = isBuildOrHouse {
            dataDict["isBuildOrHouse"] = isBuildOrHouse
        }
        if let btype = btype {
            dataDict["btype"] = btype
        }
        if let buildingId = buildingId {
            dataDict["buildingId"] = buildingId
        }
        if let houseId = houseId {
            dataDict["houseId"] = houseId
        }
        dataDict["content"] = content
        
        if let extraMessage = extraMessage {
            dataDict["extraMessage"] = extraMessage
        }
        if let mainPic = mainPic {
            dataDict["mainPic"] = mainPic
        }
        if let createTimeAndByWho = createTimeAndByWho {
            dataDict["createTimeAndByWho"] = createTimeAndByWho
        }
        dataDict["isFavorite"] = isFavorite
        if let buildingName = buildingName {
            dataDict["buildingName"] = buildingName
        }
        if let houseName = houseName {
            dataDict["houseName"] = houseName
        }
        if let distanceDistrictString = distanceDistrictString {
            dataDict["distanceDistrictString"] = distanceDistrictString
        }
        if let walkTimesubwayAndStationString = walkTimesubwayAndStationString {
            dataDict["walkTimesubwayAndStationString"] = walkTimesubwayAndStationString
        }
        if let dayPriceString = dayPriceString {
            dataDict["dayPriceString"] = dayPriceString
        }
        if let tagsString = tagsString {
            dataDict["tagsString"] = tagsString
        }
        
        
        if let senderUserInfo = senderUserInfo {
            dataDict["user"] = self.encode(senderUserInfo)
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: dataDict, options: .prettyPrinted)
            return data
        } catch {
            SSLog(error)
            return Data()
        }
    }
    
    // 反序列化，解码生成可用的消息内容
    override func decode(with data: Data!) {
        do {
            let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
            isBuildOrHouse = dictionary["isBuildOrHouse"] as? Int ?? 0
            btype = dictionary["btype"] as? Int ?? 0
            buildingId = dictionary["buildingId"] as? Int ?? 0
            houseId = dictionary["houseId"] as? Int ?? 0
            content = dictionary["content"] as? String ?? ""
            extraMessage = dictionary["extraMessage"] as? String ?? ""
            mainPic = dictionary["mainPic"]as? String ?? ""
            createTimeAndByWho = dictionary["createTimeAndByWho"]as? String ?? ""
            isFavorite = dictionary["isFavorite"]as? Bool ?? false
            buildingName = dictionary["buildingName"]as? String ?? ""
            houseName = dictionary["houseName"]as? String ?? ""
            distanceDistrictString = dictionary["distanceDistrictString"]as? String ?? ""
            walkTimesubwayAndStationString = dictionary["walkTimesubwayAndStationString"]as? String ?? ""
            dayPriceString = dictionary["dayPriceString"]as? String ?? ""
            tagsString = dictionary["tagsString"]as? String ?? ""
            
            let userInfoDict = dictionary["user"] as? [String : Any] ?? [:]
            decodeUserInfo(userInfoDict)
        } catch {
            SSLog(error)
        }
    }
    
    // 显示的消息内容摘要
    override func conversationDigest() -> String! {
        return content
    }
    
    // 返回消息的类型名
    override class func getObjectName() -> String! {
        return AppKey.InsertFYMessageTypeIdentifier
    }
}

class FangyuanInsertFYMessageCell: RCMessageBaseCell {
    
    override init!(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kAppClearColor
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    //按钮点击方法
    var collectClick:((String) -> Void)?
    
    @objc func btnClick() {
        guard let blockk = collectClick else {
            return
        }
        blockk("selectedIndex")
    }
    
    lazy var bgcontentView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppWhiteColor
        return view
    }()
    lazy var houseMainImg: BaseImageView = {
        let view = BaseImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = button_cordious_2
        return view
    }()
    lazy var houseNameLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_13
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
        view.font = FONT_LIGHT_10
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
        view.font = FONT_LIGHT_10
        view.textColor = kAppColor_333333
        return view
    }()
    lazy var housePriceLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_SEMBLOD_13
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
        view.font = FONT_LIGHT_11
        view.textColor = kAppColor_666666
        return view
    }()
    /*
    lazy var collectBtn: UIButton = {
        let btn = UIButton.init()
        btn.setTitleColor(kAppColor_666666, for: .normal)
        btn.setTitleColor(kAppColor_666666, for: .selected)
        btn.setTitle("收藏", for: .normal)
        btn.setTitle("已收藏", for: .selected)
        btn.setImage(UIImage.init(named: "collectXinGray"), for: .normal)
        btn.setImage(UIImage.init(named: "collectXinBlue"), for: .selected)
        btn.titleLabel?.font = FONT_LIGHT_11
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        return btn
    }()*/
    
    override func setDataModel(_ model: RCMessageModel!) {
        super.setDataModel(model)
        setAutoLayout()
    }
    
    private func setAutoLayout() {
        
        let viewModel = model.content as? FangyuanInsertFYMessage

        houseMainImg.setImage(with: viewModel?.mainPic ?? "", placeholder: UIImage.init(named: Default_1x1))
        houseNameLabel.text = viewModel?.houseName ?? ""
        houseKmAndAddressLabel.text = viewModel?.distanceDistrictString ?? ""
        if viewModel?.walkTimesubwayAndStationString?.count ?? 0 > 0 {
            houseTrafficLabel.snp.remakeConstraints { (make) in
                make.leading.equalTo(houseNameLabel).offset(10 + 4)
                make.top.equalTo(houselocationIcon.snp.bottom)
                make.trailing.equalTo(houseNameLabel)
                make.height.equalTo(18 + 6)
            }
        }else {
            houseTrafficLabel.snp.remakeConstraints { (make) in
                make.leading.equalTo(houseNameLabel).offset(10 + 4)
                make.top.equalTo(houselocationIcon.snp.bottom)
                make.trailing.equalTo(houseNameLabel)
                make.height.equalTo(0)
            }
        }
        houseTrafficLabel.text = viewModel?.walkTimesubwayAndStationString ?? ""
        housePriceLabel.text = viewModel?.dayPriceString ?? ""
//        houseFeatureView.featureStringDetail = viewModel?.tagsString ?? ""
        if let str = viewModel?.tagsString {
            let arr = str.split{$0 == ","}.map(String.init)
            houseFeatureView.featureStringDetail = arr
        }
        msgStartDescLabel.text = viewModel?.createTimeAndByWho ?? ""
        /*
        /collectBtn.isSelected = true
        //            collectBtn.layoutButton(.imagePositionLeft, space: 10)*/
    }
    
    // 自定义消息 Cell 的 Size
    override class func size(for model: RCMessageModel!, withCollectionViewWidth collectionViewWidth: CGFloat, referenceExtraHeight extraHeight: CGFloat) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 188.0 + extraHeight)
    }
    
    /*!
      单击操作，跳转消息详情
      */
    @objc private func tapTextMessage(_ tap: UITapGestureRecognizer) {
        if let delegate = delegate {
            delegate.didTapMessageCell!(model)
        }
    }
    
    func initialize() {
        SSLog("----\\\\----\(UIScreen.main.bounds.size.width)")
        
        bgcontentView.frame = CGRect(x: 0, y:0, width: UIScreen.main.bounds.size.width, height: 188)

        baseContentView.addSubview(bgcontentView)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapTextMessage(_:)))
        singleTap.numberOfTapsRequired = 1
        bgcontentView.addGestureRecognizer(singleTap)
        
        bgcontentView.addSubview(houseMainImg)
        bgcontentView.addSubview(houseNameLabel)
        bgcontentView.addSubview(houselocationIcon)
        bgcontentView.addSubview(houseKmAndAddressLabel)
        bgcontentView.addSubview(houseTrafficIcon)
        bgcontentView.addSubview(houseTrafficLabel)
        bgcontentView.addSubview(housePriceLabel)
        bgcontentView.addSubview(houseFeatureView)
        bgcontentView.addSubview(lineView)
        bgcontentView.addSubview(msgStartDescLabel)
        /*
        bgcontentView.addSubview(collectBtn)*/
        houseMainImg.snp.makeConstraints { (make) in
            make.leading.top.equalTo(left_pending_space_17)
            make.size.equalTo(88)
        }
        houseNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(houseMainImg.snp.trailing).offset(6)
            make.trailing.equalToSuperview().offset(-left_pending_space_17)
            make.top.equalTo(houseMainImg)
        }
        houseKmAndAddressLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(houseNameLabel).offset(10 + 4)
            make.top.equalTo(houseNameLabel.snp.bottom)
            make.trailing.equalTo(houseNameLabel)
            make.height.equalTo(18 + 6)
        }
        houselocationIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(houseNameLabel)
            make.centerY.height.equalTo(houseKmAndAddressLabel)
            make.width.equalTo(10)
        }
        
        houseTrafficLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(houseNameLabel).offset(10 + 4)
            make.top.equalTo(houseKmAndAddressLabel.snp.bottom)
            make.trailing.equalTo(houseNameLabel)
        }
        houseTrafficIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(houseNameLabel)
            make.centerY.height.equalTo(houseTrafficLabel)
            make.width.equalTo(10)
        }
        
        housePriceLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(houseNameLabel)
            make.top.equalTo(houseTrafficIcon.snp.bottom).offset(2)
        }
        houseFeatureView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.top.equalTo(houseMainImg.snp.bottom).offset(9)
            make.height.equalTo(18)
        }
        lineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(houseFeatureView)
            make.top.equalTo(houseFeatureView.snp.bottom).offset(9)
            make.height.equalTo(1)
        }
        msgStartDescLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(houseFeatureView)
            make.trailing.equalTo(60)
            make.top.equalTo(lineView.snp.bottom).offset(9)
            make.height.equalTo(13 + 9)
        }
        /*
        collectBtn.snp.makeConstraints { (make) in
            make.centerY.height.equalTo(msgStartDescLabel)
            make.width.equalTo(60)
            make.trailing.equalToSuperview()
        }*/
    }
}
