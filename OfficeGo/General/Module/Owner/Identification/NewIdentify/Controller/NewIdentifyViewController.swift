//
//  NewIdentifyViewController.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/11/17.
//  Copyright © 2020 Senwei. All rights reserved.
//

import CLImagePickerTool

class NewIdentifyViewController: BaseViewController {
    
    ///是否来自于添加
    var isAdd: Bool? {
        didSet {
            if isAdd == true {
                titleview?.titleLabel.text = "添加楼盘/网点"
            }
        }
    }
    
    //用户第一个认证的楼：1 后面添加的楼：2
    var isFrist : String?
    
    var buildingId : String?

    var isOpen: Bool? = true {
        didSet {
            loadCollectionSectionData(section: 0)
        }
    }
    
    var visitingCardView: OwnerVisitingCardView?
    
    var identifyUserModel: OwnerIdentifyUserModel?
    
    var userModel: LoginUserModel? {
        didSet {
            judgeShowVisitingCardview()
        }
    }
    
    //楼盘名称搜索结果vc
    var buildingNameSearchResultVC: OwnerBuildingNameESearchResultListViewController?
        
    var buildingName: String? {
        didSet {
            let rect = headerCollectionView.layoutAttributesForItem(at: IndexPath.init(row: 0, section: 0))
            let cellRect = rect?.frame ?? CGRect.zero
            let cellFrame = headerCollectionView.convert(cellRect, to: self.view)
            if buildingName?.isBlankString == true {
                buildingNameSearchResultVC?.view.isHidden = true
                buildingNameSearchResultVC?.keywords = ""
            }else {
                buildingNameSearchResultVC?.view.isHidden = false
                buildingNameSearchResultVC?.keywords = buildingName
            }
            buildingNameSearchResultVC?.view.snp.remakeConstraints({ (make) in
                make.top.equalTo(cellFrame.minY + cell_height_58 + cell_height_58 + 1)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
            })
        }
    }

    var headerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = kAppWhiteColor
        return view
    }()
    var typeSourceArray:[[OwnerNewIedntifyConfigureModel]] = {
        var arr = [[OwnerNewIedntifyConfigureModel]]()
        arr.append([OwnerNewIedntifyConfigureModel.init(types: .OwnerNewIdentifyTypeBuildingName)])
        
        arr.append([OwnerNewIedntifyConfigureModel.init(types: .OwnerNewIdentifyTypeUploadFangchanzheng)])
        
        arr.append([OwnerNewIedntifyConfigureModel.init(types: .OwnerNewIdentifyTypeQuanLiRenType)])

        arr.append([OwnerNewIedntifyConfigureModel.init(types: .OwnerNewIdentifyTypeYinYeOrIdCard)])

        arr.append([OwnerNewIedntifyConfigureModel.init(types: .OwnerNewIdentifyTypeAddtional)])
        
        return arr
    }()
    
    var commitBtn: UIButton {
        let btn = UIButton.init(frame: CGRect(x: left_pending_space_17, y: 0, width: kWidth - left_pending_space_17 * 2, height: btnHeight_44))
        btn.backgroundColor = kAppBlueColor
        btn.clipsToBounds = true
        btn.layer.cornerRadius = button_cordious_2
        btn.setTitle("提交认证", for: .normal)
        btn.setTitleColor(kAppWhiteColor, for: .normal)
        btn.titleLabel?.font = FONT_15
        btn.addTarget(self, action: #selector(logotClick), for: .touchUpInside)
        return btn
    }
    
    var LogotView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kWidth, height: btnHeight_44 + bottomMargin()))
        return view
    }()
    
    ///选择弹框
    lazy var ownerFYMoreSettingView: OwnerFYMoreSettingView = {
        let view = OwnerFYMoreSettingView.init(frame: CGRect(x: 0.0, y: 0, width: kWidth, height: kHeight))
        view.titleString = "房产类型"
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserTool.shared.user_owner_identifytype = 1
        setUpView()
        addNotify()
        requestUserMessage()
        requestCompanyIdentifyDetail()
    }
    
    func addNotify() {
        
        //公司认证 - 创建楼盘通知
        NotificationCenter.default.addObserver(forName: NSNotification.Name.OwnerCreateBuilding, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            let model = noti.object as? OwnerIdentifyUserModel
            
            
            ///说明楼盘名称有编辑
            self?.identifyUserModel?.buildingAddRemarkIsIdentify = true
            
            self?.identifyUserModel?.isCreateBuilding = "1"
            self?.identifyUserModel?.btype = model?.btype
            self?.identifyUserModel?.buildingName = model?.buildingName
            self?.identifyUserModel?.address = model?.address
            self?.identifyUserModel?.districtId = model?.districtId
            self?.identifyUserModel?.businessDistrict = model?.businessDistrict
            self?.identifyUserModel?.districtIdName = model?.districtIdName
            self?.identifyUserModel?.businessDistrictName = model?.businessDistrictName
            self?.identifyUserModel?.mainPicBannermodel = model?.mainPicBannermodel
            self?.identifyUserModel?.buildId = nil
            self?.buildingName = ""

            if self?.identifyUserModel?.btype == "1" {
                if self?.identifyUserModel?.isHolder == 1 {
                    UserTool.shared.user_owner_identifytype = 0
                }else {
                    UserTool.shared.user_owner_identifytype = 1
                }
            }else {
                UserTool.shared.user_owner_identifytype = 2
            }
            
            self?.buildingNameSearchResultVC?.view.isHidden = true
            self?.headerCollectionView.endEditing(true)
            self?.loadCollectionSectionDatas(indexSet: [0, 2, 3])
        }
        
        
    }
    ///左上角按钮
    func showLeaveAlert() {
        self.headerCollectionView.endEditing(true)
        let alert = SureAlertView(frame: self.view.frame)
        alert.bottomBtnView.rightSelectBtn.setTitle("离开", for: .normal)
        alert.ShowAlertView(withalertType: AlertType.AlertTypeMessageAlert, title: "信息尚未提交，是否确认离开？", descMsg: "", cancelButtonCallClick: {
            
        }) { [weak self] in
            
            self?.leftBtnClick()
        }
    }
    
}

extension NewIdentifyViewController {
    
    func detailDataShow() {
        
        if identifyUserModel?.buildId != nil && identifyUserModel?.buildId?.isBlankString != true && identifyUserModel?.buildId != "0" {
            identifyUserModel?.isCreateBuilding = "2"
        }else {
            identifyUserModel?.isCreateBuilding = "1"
        }
        
        if identifyUserModel?.btype == nil || identifyUserModel?.btype?.isBlankString == true {
            identifyUserModel?.btype = "1"
        }
        
        if let remarkArr = identifyUserModel?.remark {
            if remarkArr.count > 0 {
                identifyUserModel?.remarkString = "驳回原因："
                for model in remarkArr {
                    
                    identifyUserModel?.remarkString?.append(model.dictCname ?? "")
                                    
                    let index = remarkArr.firstIndex(of: model)
                    
                    if index == remarkArr.count - 1 {
                        identifyUserModel?.remarkString?.append("")
                    }else {
                        identifyUserModel?.remarkString?.append("\n")
                    }
                    
                    if model.dictValue == 1 || model.dictValue == 2 {
                        identifyUserModel?.buildingAddRemark = true
                    }else if model.dictValue == 3 || model.dictValue == 4 {
                        identifyUserModel?.fczRemark = true
                        identifyUserModel?.premisesPermit = nil
                    }else if model.dictValue == 5 || model.dictValue == 6 {
                        identifyUserModel?.businessRemark = true
                        identifyUserModel?.businessLicense = nil
                    }else if model.dictValue == 7 || model.dictValue == 8 {
                        identifyUserModel?.idCardRemark = true
                        identifyUserModel?.idFront = nil
                        identifyUserModel?.idBack = nil
                    }else if model.dictValue == 9 || model.dictValue == 10 {
                        identifyUserModel?.addtionalRemark = true
                        identifyUserModel?.materials = nil
                    }
                }
            }

        }
        
        ///房产证被驳回
        ///添加新的房产证数据
        if let premisesPermit = identifyUserModel?.premisesPermit {
            
            for str in premisesPermit {
                let fczBannerModel = BannerModel()
                fczBannerModel.imgUrl = str
                fczBannerModel.isLocal = false
                identifyUserModel?.fczLocalLocalImgArr.append(fczBannerModel)
            }
        }
        
        ///添加新的营业执照数据
        if let contract = identifyUserModel?.businessLicense{
            
            for str in contract {
                let fczBannerModel = BannerModel()
                fczBannerModel.imgUrl = str
                fczBannerModel.isLocal = false
                identifyUserModel?.businessLicenseLocalImgArr.append(fczBannerModel)
            }
        }
        
        ///添加新的补充材料数据
        if let contract = identifyUserModel?.materials {
            for str in contract {
                let fczBannerModel = BannerModel()
                fczBannerModel.imgUrl = str
                fczBannerModel.isLocal = false
                identifyUserModel?.addtionalLocalImgArr.append(fczBannerModel)
            }
        }
        
        ///身份证正
        identifyUserModel?.frontBannerModel = BannerModel()
        if let str = identifyUserModel?.idFront {
            identifyUserModel?.frontBannerModel?.imgUrl = str
            identifyUserModel?.frontBannerModel?.isLocal = false
        }
        
        ///身份证反
        identifyUserModel?.reverseBannerModel = BannerModel()
        if let str = identifyUserModel?.idBack {
            identifyUserModel?.reverseBannerModel?.imgUrl = str
            identifyUserModel?.reverseBannerModel?.isLocal = false
        }

        
        ///封面图
        identifyUserModel?.mainPicBannermodel = BannerModel()
        if let str = identifyUserModel?.mainPic {
            identifyUserModel?.mainPicBannermodel?.imgUrl = str
            identifyUserModel?.mainPicBannermodel?.isLocal = false
        }

        if identifyUserModel?.btype == "1" {
            if identifyUserModel?.isHolder == 1 {
                UserTool.shared.user_owner_identifytype = 0
            }else {
                UserTool.shared.user_owner_identifytype = 1
            }
        }else {
            UserTool.shared.user_owner_identifytype = 2
        }
        
        loadCollectionData()
    }
    
    @objc func requestUserMessage() {
        
        SSNetworkTool.SSMine.request_getOwnerUserMsg(success: {[weak self] (response) in

            guard let weakSelf = self else {return}
            
            if let model = LoginUserModel.deserialize(from: response, designatedPath: "data") {
                
                weakSelf.userModel = model
            }
            
            }, failure: { (error) in
                
        }) { (code, message) in
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    ///获取信息
    func requestCompanyIdentifyDetail() {
        
        if buildingId == nil || buildingId?.isBlankString == true {
            
            setUpData()
            loadCollectionData()
            return
        }
        
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        
        params["buildingId"] = buildingId as AnyObject?
        
        
        SSNetworkTool.SSOwnerIdentify.request_getNewIdentifyMsg(params: params, success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
            
            if let model = OwnerIdentifyUserModel.deserialize(from: response, designatedPath: "data") {
                weakSelf.identifyUserModel = model
                weakSelf.detailDataShow()
                
            }else {
                weakSelf.setUpData()
                weakSelf.loadCollectionData()
            }
            
            }, failure: {[weak self] (error) in
                
                guard let weakSelf = self else {return}
                
                weakSelf.setUpData()
                weakSelf.loadCollectionData()
                
        }) {[weak self] (code, message) in
            
            guard let weakSelf = self else {return}
            
            weakSelf.setUpData()
            weakSelf.loadCollectionData()
            //只有5000 提示给用户 - 失效原因
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" || code == "\(SSCode.ERROR_CODE_7016.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    ///提交认证
    func requestCompanyIdentify() {
        
        ///buildid是否为空判断是否是关联的
        
        if identifyUserModel?.buildingName == nil || identifyUserModel?.buildingName?.isBlankString == true{
            AppUtilities.makeToast("请选择或创建楼盘")
            return
        }
        
        ///当为驳回，并且楼盘信息没有修改时，提示用户修改楼盘信息
        if identifyUserModel?.buildingAddRemark == true && identifyUserModel?.buildingAddRemarkIsIdentify == false {
            AppUtilities.makeToast("请修改楼盘/网点信息")
            return
        }
        
        if identifyUserModel?.fczLocalLocalImgArr.count ?? 0 <= 0 {
            AppUtilities.makeToast("请上传房产证")
            return
        }
        
        
        if identifyUserModel?.btype == "1" {
            if identifyUserModel?.isHolder == nil {
                AppUtilities.makeToast("请选择权利人类型")
                return
            }
        }
        
        ///如果是个人，需要上传身份证正反面
        if identifyUserModel?.btype == "1" && identifyUserModel?.isHolder == 1 {
            if identifyUserModel?.frontBannerModel?.imgUrl == nil || identifyUserModel?.frontBannerModel?.imgUrl?.isBlankString == true {
                AppUtilities.makeToast("请上传身份证")
                return
            }
            
            if identifyUserModel?.reverseBannerModel?.imgUrl == nil || identifyUserModel?.reverseBannerModel?.imgUrl?.isBlankString == true {
                AppUtilities.makeToast("请上传身份证")
                return
            }
        }else {
            if identifyUserModel?.businessLicenseLocalImgArr.count ?? 0 <= 0 {
                AppUtilities.makeToast("请上传营业执照")
                return
            }
        }


        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        params["btype"] = identifyUserModel?.btype as AnyObject?

        params["buildingName"] = identifyUserModel?.buildingName as AnyObject?
        
        params["mainPic"] = identifyUserModel?.mainPicBannermodel?.imgUrl as AnyObject?
        
        ///楼id
        ///关联的。- 覆盖 - 两种
        ///有值必传无值无须传值 关联楼id
        if identifyUserModel?.buildId != nil {
            params["buildId"] = identifyUserModel?.buildId as AnyObject?
        }
        
        //关联 - 楼盘，名字和地址都要给
        params["buildingId"] = identifyUserModel?.buildingId as AnyObject?
        
        params["districtId"] = identifyUserModel?.districtId as AnyObject?

        params["businessDistrict"] = identifyUserModel?.businessDistrict as AnyObject?

        params["address"] = identifyUserModel?.address as AnyObject?

        if identifyUserModel?.btype == "1" {
            params["isHolder"] = identifyUserModel?.isHolder as AnyObject?
        }

        params["isFrist"] = isFrist as AnyObject?
        
        //premisesPermit    是    String    房产证
        if let fczLocalLocalImgArr = identifyUserModel?.fczLocalLocalImgArr {
            var deleteArr: [String] = []
            for model in fczLocalLocalImgArr {
                deleteArr.append(model.imgUrl ?? "")
            }
            params["premisesPermit"] = deleteArr.joined(separator: ",") as AnyObject?
        }
        
        //个人
        if identifyUserModel?.btype == "1" && identifyUserModel?.isHolder == 1 {
            
            //idFront    是    String    身份证正面
            if let idFront = identifyUserModel?.frontBannerModel?.imgUrl {
                params["idFront"] = idFront as AnyObject?
            }
            
            //idBack    是    String    身份证反面
            if let idBack = identifyUserModel?.reverseBannerModel?.imgUrl {
                params["idBack"] = idBack as AnyObject?
            }
            
        }else {
            //businessLicense    是    String    营业执照
            if let businessLicenseLocalImgArr = identifyUserModel?.businessLicenseLocalImgArr {
                var deleteArr: [String] = []
                for model in businessLicenseLocalImgArr {
                    deleteArr.append(model.imgUrl ?? "")
                }
                params["businessLicense"] = deleteArr.joined(separator: ",") as AnyObject?
            }

        }

        //materials    是    String    补充资料
        if let addtionalLocalImgArr = identifyUserModel?.addtionalLocalImgArr {
            var deleteArr: [String] = []
            for model in addtionalLocalImgArr {
                deleteArr.append(model.imgUrl ?? "")
            }
            params["materials"] = deleteArr.joined(separator: ",") as AnyObject?
        }else {
            params["materials"] = "" as AnyObject?
        }
        

        setCommitEnables(isUserinterface: false)

        SSNetworkTool.SSOwnerIdentify.request_addNewIdentityApp(params: params, success: {[weak self] (response) in

            guard let weakSelf = self else {return}

            weakSelf.setCommitEnables(isUserinterface: false)

            weakSelf.showCommitAlertview()

            }, failure: {[weak self] (error) in

                self?.setCommitEnables(isUserinterface: false)
        }) {[weak self] (code, message) in

            self?.setCommitEnables(isUserinterface: false)

            //只有5000 提示给用户 - 失效原因
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" || code == "\(SSCode.ERROR_CODE_7016.code)" {
                AppUtilities.makeToast(message)
            }
        }
        

    }
    
    func setCommitEnables(isUserinterface: Bool) {
        commitBtn.isUserInteractionEnabled = false
    }
        
}

extension NewIdentifyViewController {
    
    @objc func logotClick() {
        self.headerCollectionView.endEditing(true)
        requestCompanyIdentify()
    }
    func setUpData() {
        identifyUserModel = OwnerIdentifyUserModel()
        identifyUserModel?.frontBannerModel = BannerModel()
        identifyUserModel?.reverseBannerModel = BannerModel()
        identifyUserModel?.mainPicBannermodel = BannerModel()
    }
    func setUpView() {
        
        titleview = ThorNavigationView.init(type: .backTitleRightBlueBgclolor)
        titleview?.titleLabel.text = "房东认证"
        if isAdd == true {
            titleview?.titleLabel.text = "添加楼盘/网点"
        }
        titleview?.rightButton.isHidden = true
        titleview?.leftButtonCallBack = { [weak self] in
            self?.showLeaveAlert()
        }
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .backTitleRight))
        
        self.view.addSubview(headerCollectionView)
        headerCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(kNavigationHeight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-(bottomMargin() + btnHeight_44))
        }
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
        self.view.addSubview(LogotView)
        LogotView.addSubview(commitBtn)
        LogotView.snp.remakeConstraints { (make) in
            make.height.equalTo(bottomMargin() + btnHeight_44)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        headerCollectionView.register(OwnerNewIdentifyRejectViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "OwnerNewIdentifyRejectViewHeader")

        ///楼盘名字地址展示cell
        headerCollectionView.register(OwnerNewIdentifyCell.self, forCellWithReuseIdentifier: OwnerNewIdentifyCell.reuseIdentifierStr)
        ///权利人cell
        headerCollectionView.register(OwnerCompanyIdentifyCell.self, forCellWithReuseIdentifier: OwnerCompanyIdentifyCell.reuseIdentifierStr)
        ///房产证 营业执照 补充材料
        headerCollectionView.register(OwnerNewIdentifyImgCell.self, forCellWithReuseIdentifier: OwnerNewIdentifyImgCell.reuseIdentifierStr)
        ///身份证
        headerCollectionView.register(OwnerNewPersonIDCardIdentifyImgCell.self, forCellWithReuseIdentifier: "OwnerNewPersonIDCardIdentifyImgCell.reuseIdentifierStr")
        //楼盘
        buildingNameSearchResultVC = OwnerBuildingNameESearchResultListViewController.init()
        buildingNameSearchResultVC?.view.isHidden = true
        self.view.addSubview(buildingNameSearchResultVC?.view ?? UIView())
        
        // 传递闭包 当点击’搜索结果‘的cell调用
        buildingNameSearchResultVC?.buildingCallBack = {[weak self] (model) in
            // 搜索完成 关闭resultVC
            
            //判断楼盘是关联的还是自己创建的
            self?.identifyUserModel?.isCreateBuilding = "2"
            
            self?.identifyUserModel?.btype = "\(model.buildType ?? 0)"
            self?.identifyUserModel?.buildId = model.bid
            self?.identifyUserModel?.buildingName = model.buildingAttributedName?.string
            self?.identifyUserModel?.address = model.addressString?.string
            
            
            if self?.identifyUserModel?.btype == "1" {
                if self?.identifyUserModel?.isHolder == 1 {
                    UserTool.shared.user_owner_identifytype = 0
                }else {
                    UserTool.shared.user_owner_identifytype = 1
                }
            }else {
                UserTool.shared.user_owner_identifytype = 2
            }
            self?.buildingNameSearchResultVC?.view.isHidden = true
            self?.loadCollectionSectionDatas(indexSet: [0, 2, 3])
        }
        
        // 创建按钮 - 隐藏 - 创建楼盘
        buildingNameSearchResultVC?.creatButtonCallClick = {[weak self] in
            let vc = OwnerCreateBuildingViewController()
            let userModel = OwnerIdentifyUserModel()
            userModel.buildingId = self?.identifyUserModel?.buildingId
            userModel.buildingName = self?.buildingName
            userModel.address = ""
            userModel.btype = nil
            userModel.mainPic = ""
            userModel.districtId = ""
            userModel.businessDistrict = ""
            userModel.districtIdName = ""
            userModel.businessDistrictName = ""
            vc.userModel = userModel
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        // 关闭按钮 - 隐藏页面
        buildingNameSearchResultVC?.closeButtonCallClick = {[weak self] in
            self?.buildingNameSearchResultVC?.view.isHidden = true
        }
        
    }
    
    func judgeShowVisitingCardview() {
        
        if userModel?.avatar?.count ?? 0 <= 0 || userModel?.nickname?.count ?? 0 <= 0 || userModel?.job?.count ?? 0 <= 0 {
            visitingCardView = OwnerVisitingCardView()
            visitingCardView?.userModel = userModel
            visitingCardView?.ShowOwnerVisitingCardView(moreClickBlock: { [weak self] in
                
                let vc = OwnerUserMsgViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
                self?.visitingCardView?.view.removeFromSuperview()
            }, commitClickBlock: { [weak self] in
                self?.visitingCardView?.view.removeFromSuperview()
                self?.requestEditUserMessage()
            })
        }
        
    }
    
    func requestEditUserMessage() {
        
        var params = [String:AnyObject]()
        params["nickname"] = UserTool.shared.user_nickname as AnyObject?
        params["job"] = UserTool.shared.user_job as AnyObject?
        params["avatar"] = UserTool.shared.user_avatars as AnyObject?
        params["sex"] = UserTool.shared.user_sex as AnyObject?
        params["token"] = UserTool.shared.user_token as AnyObject?
        params["wxId"] = UserTool.shared.user_wechat as AnyObject?
        params["company"] = UserTool.shared.user_company as AnyObject?
        SSNetworkTool.SSMine.request_updateUserMessage(params: params, success: { (response) in
                        
            }, failure: { (error) in
        }) { (code, message) in
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    func loadCollectionData() {
        headerCollectionView.reloadData()
    }
    
    func loadCollectionSectionData(section: Int) {
        headerCollectionView.reloadSections(NSIndexSet.init(index: section) as IndexSet)
    }
    func loadCollectionSectionDatas(indexSet: IndexSet) {
        headerCollectionView.reloadSections(NSIndexSet.init(indexSet: indexSet) as IndexSet)
    }
    
    func showCommitAlertview() {
        
        if isFrist != "1" {
            NotificationCenter.default.post(name: NSNotification.Name.OwnerIdentifySuccess, object: nil)
        }

        let alert = SureAlertView(frame: self.view.frame)
        alert.isHiddenVersionCancel = true
        alert.ShowAlertView(withalertType: AlertType.AlertTypeMessageAlert, title: "提交成功", descMsg: "我们会在1-2个工作日完成审核", cancelButtonCallClick: {
            
        }) {[weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
}

extension NewIdentifyViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OwnerNewIdentifyCell.reuseIdentifierStr, for: indexPath as IndexPath) as? OwnerNewIdentifyCell
            cell?.userModel = self.identifyUserModel
            cell?.model = typeSourceArray[indexPath.section][indexPath.item]
            cell?.buildingNameClickClouse = { [weak self] (buildingName) in
                //清除 公司名字 字段改为空
                self?.identifyUserModel?.isCreateBuilding = ""
                
                self?.identifyUserModel?.buildingName = ""
                self?.identifyUserModel?.address = ""
                self?.buildingName = buildingName
            }
            cell?.editClickBack = { [weak self] (type) in
                //楼盘编辑
                if type == OwnerNewIdentifyType.OwnerNewIdentifyTypeBuildingName {
                    let vc = OwnerCreateBuildingViewController()
                    vc.userModel = self?.identifyUserModel
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            cell?.closeClickBack = { [weak self] (type) in
                ///说明楼盘名称有编辑
                self?.identifyUserModel?.buildingAddRemarkIsIdentify = true
                //公司编辑
                if type == .OwnerNewIdentifyTypeBuildingName {
                    //清除 楼盘名字地址 字段改为空
                    self?.identifyUserModel?.isCreateBuilding = ""
                    
                    self?.identifyUserModel?.buildingName = ""
                    self?.identifyUserModel?.address = ""
                    
                    self?.buildingName = ""
                }
            }
            return cell ?? OwnerNewIdentifyCell()
        }else if indexPath.section == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OwnerCompanyIdentifyCell.reuseIdentifierStr, for: indexPath as IndexPath) as? OwnerCompanyIdentifyCell
            cell?.userModel = identifyUserModel
            let model = typeSourceArray[indexPath.section][indexPath.item]
            cell?.titleLabel.attributedText = model.getNameFormType(type: model.type ?? .OwnerNewIdentifyTypeQuanLiRenType)
            cell?.numDescTF.placeholder = model.getDescFormType(type: model.type ?? .OwnerNewIdentifyTypeQuanLiRenType)
            if identifyUserModel?.isHolder == 1 {
                cell?.numDescTF.text = "个人"
            }else if identifyUserModel?.isHolder == 2 {
                cell?.numDescTF.text = "公司"
            }
            cell?.editBtn.isHidden = true
            cell?.closeBtn.isHidden = true
            cell?.numDescTF.isUserInteractionEnabled = false
            return cell ?? OwnerCompanyIdentifyCell()
        }else {
            
            if indexPath.section == 3 {
                
                if UserTool.shared.user_owner_identifytype == 0 {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OwnerNewPersonIDCardIdentifyImgCell.reuseIdentifierStr", for: indexPath as IndexPath) as? OwnerNewPersonIDCardIdentifyImgCell
                    cell?.presentVC = self
                    cell?.userModel = identifyUserModel
                    cell?.model = typeSourceArray[indexPath.section][indexPath.item]
                    return cell ?? OwnerNewPersonIDCardIdentifyImgCell()
                }else {
                    
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OwnerNewIdentifyImgCell.reuseIdentifierStr, for: indexPath) as? OwnerNewIdentifyImgCell
                    cell?.presentVC = self
                    cell?.userModel = identifyUserModel ?? OwnerIdentifyUserModel()
                    cell?.model = typeSourceArray[indexPath.section][indexPath.item]
                    cell?.imgSelectClickBlock = { [weak self] (usermodel) in
                        self?.identifyUserModel = usermodel
                        self?.loadCollectionSectionData(section: indexPath.section)
                    }
                    return cell ?? OwnerNewIdentifyImgCell.init(frame: .zero)
                    
                }
            }else {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OwnerNewIdentifyImgCell.reuseIdentifierStr, for: indexPath) as? OwnerNewIdentifyImgCell
                cell?.presentVC = self
                cell?.userModel = identifyUserModel ?? OwnerIdentifyUserModel()
                cell?.model = typeSourceArray[indexPath.section][indexPath.item]
                cell?.imgSelectClickBlock = { [weak self] (usermodel) in
                    self?.identifyUserModel = usermodel
                    self?.loadCollectionSectionData(section: indexPath.section)
                }
                return cell ?? OwnerNewIdentifyImgCell.init(frame: .zero)
                
            }
            
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 5
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        ///楼盘名
        if section == 0 {
            return 1
        }
        ///房产证
        else if section == 1 {
            return 1
        }
        ///权利人类型 - 只有楼盘和个人有
        else if section == 2 {
            ///身份类型0个人1企业2联合
            if UserTool.shared.user_owner_identifytype == 0 {
                return 1
            }else if UserTool.shared.user_owner_identifytype == 1 {
                return 1
            }else if UserTool.shared.user_owner_identifytype == 2 {
                return 0
            }else {
                return 0
            }
        }
        ///营业执照 - 只有楼盘和网点有
        ///身份证 - 个人
        else if section == 3 {
            ///身份类型0个人1企业2联合
            if UserTool.shared.user_owner_identifytype == 0 {
                return 1
            }else if UserTool.shared.user_owner_identifytype == 1 {
                return 1
            }else if UserTool.shared.user_owner_identifytype == 2 {
                return 1
            }else {
                return 0
            }
        }else {
            return 1
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (kWidth - left_pending_space_17 * 2) / 3.0 - 1

        if indexPath.section == 0 {
            if identifyUserModel?.buildingName != nil {
                return CGSize(width: kWidth, height: cell_height_58 * 2)
            }else {
                return CGSize(width: kWidth, height: cell_height_58 * 2)
            }
        }else if indexPath.section == 1 {
            if let count = identifyUserModel?.fczLocalLocalImgArr.count {
                return CGSize(width: kWidth, height: CGFloat((count + 3) / 3) * CGFloat(width + 5) + 68)
            }else {
                return CGSize(width: kWidth, height: width + 68)
            }

        }else if indexPath.section == 2 {
            ///身份类型0个人1企业2联合
            if UserTool.shared.user_owner_identifytype == 0 {
                return CGSize(width: kWidth - left_pending_space_17 * 2, height: cell_height_58)
            }else if UserTool.shared.user_owner_identifytype == 1 {
                return CGSize(width: kWidth - left_pending_space_17 * 2, height: cell_height_58)
            }else if UserTool.shared.user_owner_identifytype == 2 {
                return CGSize(width: 0, height: 0)
            }else {
                return CGSize(width: 0, height: 0)
            }
        }else if indexPath.section == 3 {
            if UserTool.shared.user_owner_identifytype == 0 {
                return CGSize(width: kWidth, height: OwnerNewPersonIDCardIdentifyImgCell.rowHeight())
            }else {
                if let count = identifyUserModel?.businessLicenseLocalImgArr.count {
                    return CGSize(width: kWidth, height: CGFloat((count + 3) / 3) * CGFloat(width + 5) + 68)
                }else {
                    return CGSize(width: kWidth, height: width + 68)
                }
            }
            
        }else {
            if let count = identifyUserModel?.addtionalLocalImgArr.count {
                return CGSize(width: kWidth, height: CGFloat((count + 3) / 3) * CGFloat(width + 5) + 68)
            }else {
                return CGSize(width: kWidth, height: width + 68)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 || section == 2 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        }else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if indexPath.item == 0 {
                
                ownerFYMoreSettingView.ShowOwnerSettingView(datasource: ["公司", "个人"], clearButtonCallBack: {
                    
                }) {[weak self] (settingEnumIndex) in
                    if settingEnumIndex == 0 {
                        self?.identifyUserModel?.isHolder = 2
                        UserTool.shared.user_owner_identifytype = 1
                        self?.loadCollectionData()
                    }else if settingEnumIndex == 1 {
                        self?.identifyUserModel?.isHolder = 1
                        UserTool.shared.user_owner_identifytype = 0
                        self?.loadCollectionData()
                    }
                }
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "OwnerNewIdentifyRejectViewHeader", for: indexPath) as? OwnerNewIdentifyRejectViewHeader
            header?.backgroundColor = kAppColor_line_EEEEEE
            
            if indexPath.section == 0 {
                header?.backgroundColor = kAppLightRedColor
                header?.isOpenBlock = { [weak self] (isOpen) in
                    self?.isOpen = isOpen
                }
                header?.isOpen = isOpen
                header?.openBtn.isHidden = false
                header?.rejectReasonLabel.text = identifyUserModel?.remarkString
                
            }else if indexPath.section == 2 {
                header?.rejectReasonLabel.text = ""
                header?.openBtn.isHidden = true
                header?.backgroundColor = kAppColor_line_EEEEEE
            }else {
                header?.backgroundColor = kAppWhiteColor
            }
            return header ?? UICollectionReusableView()
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 0 {
            
            if identifyUserModel?.remark?.count ?? 0 <= 0 {
                return CGSize.zero
            }else {
                let str = identifyUserModel?.remarkString

                let size = str?.boundingRect(with: CGSize(width: kWidth - left_pending_space_17 - 44, height: 8000), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : FONT_13], context: nil)
                
                var height: CGFloat = 0
                if let hh = size?.height {
                    height = hh + 24
                }
                
                if isOpen == true {
                    
                    return CGSize(width: kWidth, height: height + 1)
                    
                }else {
                    return CGSize(width: kWidth, height: 42)
                }
            }
            
        }else if section == 2 {
            return CGSize(width: kWidth, height: 12)
        }
        return CGSize.zero
    }
    //这个是两行cell之间的间距（上下行cell的间距）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    ////两个cell之间的间距（同一行的cell的间距）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

class OwnerNewIdentifyCell: BaseCollectionViewCell {
    
    lazy var rejectImg: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.font = FONT_14
        view.textColor = kAppColor_999999
        return view
    }()
    lazy var numDescTF: UITextField = {
        let view = UITextField()
        view.textAlignment = .left
        view.font = FONT_14
        view.delegate = self
        view.textColor = kAppColor_333333
        return view
    }()
    lazy var buildingMsgView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var tagView: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = FONT_MEDIUM_10
        view.textColor = kAppWhiteColor
        view.backgroundColor = kAppBlueColor
        view.clipsToBounds = true
        view.layer.cornerRadius = button_cordious_2
        return view
    }()
    lazy var buildingNameLabel: UILabel = {
        let view = UILabel()
        view.font = FONT_14
        view.textColor = kAppColor_333333
        return view
    }()
    lazy var houselocationIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "locationGray")
        view.contentMode = .scaleAspectFit
        return view
    }()
    lazy var houseAddressLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_LIGHT_11
        view.textColor = kAppColor_333333
        return view
    }()
    lazy var editBtn: UIButton = {
        let btn = UIButton.init()
        btn.setImage(UIImage.init(named: "identifyEdit_gray"), for: .normal)
        btn.addTarget(self, action: #selector(editClick), for: .touchUpInside)
        return btn
    }()
    lazy var closeBtn: UIButton = {
        let btn = UIButton.init()
        btn.setImage(UIImage.init(named: "identifyClose_gray"), for: .normal)
        btn.addTarget(self, action: #selector(closeClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
    
    //按钮点击方法
    var editClickBack:((OwnerNewIdentifyType) -> Void)?
    
    @objc func editClick() {
        guard let blockk = editClickBack else {
            return
        }
        blockk(OwnerNewIdentifyType.OwnerNewIdentifyTypeBuildingName)
    }
    
    var closeClickBack:((OwnerNewIdentifyType) -> Void)?
    
    @objc func closeClick() {
        editBtn.isHidden = true
        numDescTF.isHidden = false
        buildingMsgView.isHidden = true
        numDescTF.text = ""
        numDescTF.becomeFirstResponder()
        guard let blockk = self.closeClickBack else {
            return
        }
        blockk(OwnerNewIdentifyType.OwnerNewIdentifyTypeBuildingName)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func rowHeight() -> CGFloat {
        return cell_height_58
    }
    //公司名字
    @objc var companyNameClickClouse: IdentifyEditingClickClouse?
    
    //大楼名称
    @objc var buildingNameClickClouse: IdentifyEditingClickClouse?
    
    //楼盘地址
    var buildingAddresEndEditingMessageCell:((String) -> Void)?
    
    //楼盘名称址
    var buildingNameEndEditingMessageCell:((String) -> Void)?
    
    //模拟认证模型
    var userModel: OwnerIdentifyUserModel?
    
    var model: OwnerNewIedntifyConfigureModel = OwnerNewIedntifyConfigureModel(types: .OwnerNewIdentifyTypeBuildingName) {
        didSet {
                        
            titleLabel.attributedText = model.getNameFormType(type: model.type ?? .OwnerNewIdentifyTypeBuildingName)
            numDescTF.placeholder = model.getDescFormType(type: model.type ?? .OwnerNewIdentifyTypeBuildingName)
            
            if userModel?.buildingAddRemark == true {
                rejectImg.image = UIImage.init(named: "redLine")
            }else {
                rejectImg.image = UIImage.init(named: "")
            }
            
            if userModel?.btype == "1" {
                tagView.text = "楼盘"
                tagView.backgroundColor = kAppBlueDeepColor
            }else {
                tagView.text = "网点"
                tagView.backgroundColor = kAppPurpleDeepColor
            }
            closeBtn.isHidden = false
            //0 空   无定义     1创建  2关联吗
            //就是自己创建
            if userModel?.isCreateBuilding == "1" {
                //1的就是自己创建
                //不能输入框修改
                //有编辑按钮
                //有清空
                numDescTF.isHidden = true
                editBtn.isHidden = false
                buildingMsgView.isHidden = false
                buildingNameLabel.text = userModel?.buildingName
                houseAddressLabel.text = "\(userModel?.districtIdName ?? "")\(userModel?.businessDistrictName ?? "")\(userModel?.address ?? "")"
            }else if userModel?.isCreateBuilding == "2" {
                //0 就是关联的公司
                //不能输入框修改
                //无编辑按钮
                //有清空
                numDescTF.isHidden = true
                editBtn.isHidden = true
                buildingMsgView.isHidden = false
                buildingNameLabel.text = userModel?.buildingName
                houseAddressLabel.text = "\(userModel?.districtIdName ?? "")\(userModel?.businessDistrictName ?? "")\(userModel?.address ?? "")"
            }else {
                //如果没有提交过，应该返回一个""
                //"" 没有提交过
                //能输入框修改
                //无编辑按钮
                //有清空
                numDescTF.isHidden = false
                editBtn.isHidden = true
                buildingMsgView.isHidden = true
            }
        }
    }
    func setupViews() {

        self.backgroundColor = kAppWhiteColor
  
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(numDescTF)
        self.contentView.addSubview(buildingMsgView)
        self.contentView.addSubview(lineView)
        self.contentView.addSubview(rejectImg)

        buildingMsgView.addSubview(tagView)
        buildingMsgView.addSubview(buildingNameLabel)
        buildingMsgView.addSubview(houselocationIcon)
        buildingMsgView.addSubview(houseAddressLabel)
        buildingMsgView.addSubview(editBtn)
        buildingMsgView.addSubview(closeBtn)
        
        rejectImg.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(10)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.top.equalToSuperview()
            make.height.equalTo(cell_height_58)
        }
        
        numDescTF.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        buildingMsgView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalTo(titleLabel)
            make.bottom.equalToSuperview()
        }

        buildingNameLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(38)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(-50)
        }
        tagView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.centerY.equalTo(buildingNameLabel)
            make.size.equalTo(CGSize(width: 30, height: 16))
        }
        houseAddressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(buildingNameLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(14)
            make.trailing.equalToSuperview()
        }
        houselocationIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(tagView)
            make.centerY.height.equalTo(houseAddressLabel)
            make.width.equalTo(12)
        }
        
        closeBtn.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.width.equalTo(25)
            make.centerY.equalTo(buildingNameLabel)
            make.height.equalTo(25)
        }
        editBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(closeBtn.snp.leading).offset(-3)
            make.width.equalTo(25)
            make.centerY.equalTo(buildingNameLabel)
            make.height.equalTo(25)
        }
        lineView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        numDescTF.addTarget(self, action: #selector(valueDidChange), for: .editingChanged)
        
    }
    @objc func valueDidChange() {
        
        if model.type == .OwnerNewIdentifyTypeBuildingName {
            guard let blockk = self.buildingNameClickClouse else {
                return
            }
            let textNum = numDescTF.text?.count
            
            //截取
            if textNum! > ownerMaxBuildingnameNumber_20 {
                let index = numDescTF.text?.index((numDescTF.text?.startIndex)!, offsetBy: ownerMaxBuildingnameNumber_20)
                let str = numDescTF.text?.substring(to: index!)
                numDescTF.text = str
            }
            
            blockk(numDescTF.text ?? "")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}

extension OwnerNewIdentifyCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        //只有楼盘名称要在编辑结束的时候传过去
        if model.type == .OwnerNewIdentifyTypeBuildingName {
            guard let blockk = self.buildingNameEndEditingMessageCell else {
                return
            }
            blockk(textField.text ?? "")
        }
    }
}
