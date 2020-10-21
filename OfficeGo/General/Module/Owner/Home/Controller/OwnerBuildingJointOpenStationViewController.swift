//
//  OwnerBuildingJointOpenStationViewController.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/10/16.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

class OwnerBuildingJointOpenStationViewController: BaseTableViewController {
        
    ///来自编辑还是添加
    var isFromAdd: Bool?
    
    ///选择弹框
    lazy var ownerFYMoreSettingView: OwnerFYMoreSettingView = {
        let view = OwnerFYMoreSettingView.init(frame: CGRect(x: 0.0, y: 0, width: kWidth, height: kHeight))
        view.titleString = "请选择"
        return view
    }()
    
    //记录是否已经点了关闭pc按钮
    var isClose: Bool?
    
    ///类型数据源
    var typeSourceArray:[OwnerBuildingJointOpenStationConfigureModel] = [OwnerBuildingJointOpenStationConfigureModel]()
    
    ///
    var buildingModel: FangYuanBuildingEditDetailModel?
    
    lazy var saveBtn: UIButton = {
        let button = UIButton.init()
        button.clipsToBounds = true
        button.layer.cornerRadius = button_cordious_2
        button.backgroundColor = kAppBlueColor
        button.titleLabel?.font = FONT_MEDIUM_16
        button.setTitleColor(kAppWhiteColor, for: .normal)
        button.setTitle("下一步", for: .normal)
        button.addTarget(self, action: #selector(saveClick), for: .touchUpInside)
        return button
    }()
    
    lazy var pcEditBtn: UIButton = {
        let button = UIButton.init()
        button.clipsToBounds = true
        button.layer.cornerRadius = button_cordious_2
        button.layer.borderColor = kAppBlueColor.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = kAppWhiteColor
        button.titleLabel?.font = FONT_MEDIUM_16
        button.setTitleColor(kAppBlueColor, for: .normal)
        button.setTitle("在电脑上编辑", for: .normal)
        button.addTarget(self, action: #selector(pcEditClick), for: .touchUpInside)
        return button
    }()
    
    lazy var closePcEditBtn: UIButton = {
        let button = UIButton.init()
        button.setImage(UIImage.init(named: "closeBlue"), for: .normal)
        button.addTarget(self, action: #selector(closePcEditClick), for: .touchUpInside)
        return button
    }()
    
    @objc func saveClick() {
        let vc = OwnerBuildingCreateVideoVRViewController()
        vc.isClose = isClose
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func pcEditClick() {
        clickToQCode()
    }
    
    @objc func closePcEditClick() {
        isClose = true
        pcEditBtn.snp.remakeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.bottom.equalToSuperview().offset(-(bottomMargin()))
            make.height.equalTo(0)
        }
        closePcEditBtn.isHidden = true
    }
    ///跳转二维码页面页面
    func clickToQCode() {
        //设置扫码区域参数
        var style = LBXScanViewStyle()
        style.centerUpOffset = 44
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Inner
        style.photoframeLineW = 2
        style.photoframeAngleW = 18
        style.photoframeAngleH = 18
        style.isNeedShowRetangle = false
        
        style.anmiationStyle = LBXScanViewAnimationStyle.LineMove
        
        style.colorAngle = UIColor(red: 0.0/255, green: 200.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_Scan_weixin_Line")
        
        
        let vc = LBXScanViewController()
        vc.scanStyle = style
        vc.isOpenInterestRect = true
        let nav = BaseNavigationViewController.init(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        //TODO: 这块弹出要设置
        self.present(nav, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpData()
        
        setUpView()
    }
    
    func setUpData() {
        
        ///工位数 *
        typeSourceArray.append(OwnerBuildingJointOpenStationConfigureModel.init(types: .OwnerBuildingJointOpenStationTypeSeats))
        
        ///租金 *
        typeSourceArray.append(OwnerBuildingJointOpenStationConfigureModel.init(types: .OwnerBuildingJointOpenStationTypePrice))
        
        ///所在楼层 *
        typeSourceArray.append(OwnerBuildingJointOpenStationConfigureModel.init(types: .OwnerBuildingJointOpenStationTypeTotalFloor))
        
        ///最短租期 *
        typeSourceArray.append(OwnerBuildingJointOpenStationConfigureModel.init(types: .OwnerBuildingJointOpenStationTypeMinRentalPeriod))
        
        ///免租期 *
        typeSourceArray.append(OwnerBuildingJointOpenStationConfigureModel.init(types: .OwnerBuildingJointOpenStationTypeRentFreePeriod))
        
        ///上传办公室图片 *
        typeSourceArray.append(OwnerBuildingJointOpenStationConfigureModel.init(types: .OwnerBuildingJointOpenStationTypeBuildingImage))
        
        
        if buildingModel != nil {
            
        }else {
            buildingModel = FangYuanBuildingEditDetailModel()
        }
        
    }
    
    ///点击问好弹出的弹框
    func showLeaveAlert(index: Int) {
        let alert = SureAlertView(frame: self.view.frame)
        alert.isHiddenVersionCancel = true
        alert.bottomBtnView.rightSelectBtn.setTitle("我知道了", for: .normal)
        if index == 1 {
            alert.ShowAlertView(withalertType: AlertType.AlertTypeMessageAlert, title: "\n 可置工位根据面积生成，可修改 \n", descMsg: "", cancelButtonCallClick: {
                
            }) {
                
            }
        }else {
            alert.ShowAlertView(withalertType: AlertType.AlertTypeMessageAlert, title: "\n 总价根据单价生成，可修改", descMsg: "总价计算规则：单价X面积X天数 \n 总价：0.3万元/月（1元 X 100㎡ X 30天）", cancelButtonCallClick: {
                
            }) {
                
            }
        }
        
    }
}

extension OwnerBuildingJointOpenStationViewController {
    
    func setUpView() {
        
        titleview = ThorNavigationView.init(type: .backTitleRight)
        //设置背景颜色为蓝色 文字白色 -
        titleview?.backgroundColor = kAppBlueColor
        titleview?.backTitleRightView.backgroundColor = kAppClearColor
        titleview?.titleLabel.textColor = kAppWhiteColor
        titleview?.rightButton.setTitleColor(kAppWhiteColor, for: .normal)
        titleview?.rightButton.snp.remakeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.width.equalTo(65)
            make.top.bottom.equalToSuperview()
        }
        
        titleview?.leftButton.setImage(UIImage.init(named: "backWhite"), for: .normal)
        //        titleview?.rightButton.setImage(UIImage.init(named: "scanIcon"), for: .normal)
        titleview?.leftButton.isHidden = false
        titleview?.rightButton.isHidden = true
        if isFromAdd == true {
            titleview?.titleLabel.text = "添加开放工位"
        }else {
            titleview?.titleLabel.text = "编辑开放工位"
        }
        titleview?.leftButtonCallBack = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        titleview?.rightBtnClickBlock = { [weak self] in
            let vc = OwnerBuildingJointOpenStationViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .backTitleRight))
        
        
        self.view.addSubview(pcEditBtn)
        self.view.addSubview(closePcEditBtn)
        self.view.addSubview(saveBtn)
        
        pcEditBtn.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.bottom.equalToSuperview().offset(-(bottomMargin() + 20))
            make.height.equalTo(40)
        }
        closePcEditBtn.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.bottom.equalTo(pcEditBtn.snp.top).offset(20)
            make.size.equalTo(40)
        }
        saveBtn.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.bottom.equalTo(pcEditBtn.snp.top).offset(-20)
            make.height.equalTo(40)
        }
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(kNavigationHeight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(saveBtn.snp.top)
        }
        
        requestSet()
    }
    
    func requestSet() {
        
        isShowRefreshHeader = true
        
        ///选择cell
        ///所在楼层
        ///免租期
        self.tableView.register(OwnerBuildingClickCell.self, forCellReuseIdentifier: OwnerBuildingClickCell.reuseIdentifierStr)
        
        ///所在楼层
        self.tableView.register(OwnerBuildingFYFloorCell.self, forCellReuseIdentifier: OwnerBuildingFYFloorCell.reuseIdentifierStr)
        
        ///正数字文本输入cell
        ///工位数
        ///最短租期
        self.tableView.register(OwnerBuildingNumInputCell.self, forCellReuseIdentifier: OwnerBuildingNumInputCell.reuseIdentifierStr)
        
        ///数字 - 一位小数点文本输入cell
        ///租金
        self.tableView.register(OwnerBuildingDecimalNumInputCell.self, forCellReuseIdentifier: OwnerBuildingDecimalNumInputCell.reuseIdentifierStr)
        
        ///图片选择
        self.tableView.register(OwnerBuildingImgCell.self, forCellReuseIdentifier: OwnerBuildingImgCell.reuseIdentifierStr)
        
        refreshData()
        
    }
    
    func loadSecion(section: Int) {
        tableView.reloadSections(NSIndexSet.init(index: section) as IndexSet, with: UITableView.RowAnimation.none)
    }
    
    func loadSections(indexSet: IndexSet) {
        tableView.reloadSections(NSIndexSet.init(indexSet: indexSet) as IndexSet, with: UITableView.RowAnimation.none)
    }
}

extension OwnerBuildingJointOpenStationViewController {
    
    func loadTableview() {
        tableView.reloadData()
    }
}

extension OwnerBuildingJointOpenStationViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return typeSourceArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        ///所在楼层
        if typeSourceArray[section].type == .OwnerBuildingJointOpenStationTypeTotalFloor {
            return 2
        }else {
            return 1
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model:OwnerBuildingJointOpenStationConfigureModel = typeSourceArray[indexPath.section]
        
        switch model.type {
            ///选择cell
            
        case .OwnerBuildingJointOpenStationTypeRentFreePeriod:
            
            ///免租期
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingClickCell.reuseIdentifierStr) as? OwnerBuildingClickCell
            cell?.selectionStyle = .none
            cell?.buildingModel = buildingModel ?? FangYuanBuildingEditDetailModel()
            cell?.jointOpenStationModel = model
            return cell ?? OwnerBuildingClickCell.init(frame: .zero)
            
        ///所在楼层
        case .OwnerBuildingJointOpenStationTypeTotalFloor:
            if indexPath.row == 0 {
                ///点击cell
                let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingClickCell.reuseIdentifierStr) as? OwnerBuildingClickCell
                cell?.selectionStyle = .none
                cell?.buildingModel = buildingModel ?? FangYuanBuildingEditDetailModel()
                cell?.jointOpenStationModel = model
                return cell ?? OwnerBuildingClickCell.init(frame: .zero)
            }else {
                
                ///文本输入cell
                let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingFYFloorCell.reuseIdentifierStr) as? OwnerBuildingFYFloorCell
                cell?.selectionStyle = .none
                cell?.buildingModel = buildingModel ?? FangYuanBuildingEditDetailModel()
                cell?.jointOpenStationModel = model
                return cell ?? OwnerBuildingFYFloorCell.init(frame: .zero)
                
            }
            
        ///正数字文本输入cell
        case .OwnerBuildingJointOpenStationTypeSeats, .OwnerBuildingJointOpenStationTypeMinRentalPeriod:
            
            ///工位数
            ///最短租期
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingNumInputCell.reuseIdentifierStr) as? OwnerBuildingNumInputCell
            cell?.selectionStyle = .none
            cell?.buildingModel = buildingModel ?? FangYuanBuildingEditDetailModel()
            cell?.jointOpenStationModel = model
            return cell ?? OwnerBuildingNumInputCell.init(frame: .zero)
            
            
            ///数字 - 一位小数点文本输入cell
        ///租金
        case .OwnerBuildingJointOpenStationTypePrice:
            
            ///数字文本输入cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingDecimalNumInputCell.reuseIdentifierStr) as? OwnerBuildingDecimalNumInputCell
            cell?.selectionStyle = .none
            cell?.buildingModel = buildingModel ?? FangYuanBuildingEditDetailModel()
            cell?.jointOpenStationModel = model
            return cell ?? OwnerBuildingDecimalNumInputCell.init(frame: .zero)
            
            
        ///上传楼盘图片
        case .OwnerBuildingJointOpenStationTypeBuildingImage:
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingImgCell.reuseIdentifierStr) as? OwnerBuildingImgCell
            cell?.selectionStyle = .none
            cell?.jointOpenStationModel = model
            cell?.buildingModel = self.buildingModel ?? FangYuanBuildingEditDetailModel()
            return cell ?? OwnerBuildingImgCell.init(frame: .zero)
            
        case .none:
            return UITableViewCell.init(frame: .zero)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch typeSourceArray[indexPath.section].type {
            
            ///选择cell
        case .OwnerBuildingJointOpenStationTypeRentFreePeriod:
            
            ///免租期
            return BaseEditCell.rowHeight()
            
        ///所在楼层
        case .OwnerBuildingJointOpenStationTypeTotalFloor:
            
            if indexPath.row == 0 {
                return BaseEditCell.rowHeight()
            }else {
                if buildingModel?.floorType == "1" || buildingModel?.floorType == "2" {
                    return OwnerBuildingFYFloorCell.rowHeight()
                }else {
                    return 0
                }
            }
            
        ///正数字文本输入cell
        case .OwnerBuildingJointOpenStationTypeSeats, .OwnerBuildingJointOpenStationTypeMinRentalPeriod:
            
            ///工位数
            ///最短租期
            return BaseEditCell.rowHeight()
            
            
            ///数字 - 一位小数点文本输入cell
        ///租金
        case .OwnerBuildingJointOpenStationTypePrice:
            
            ///数字文本输入cell
            return BaseEditCell.rowHeight()
                        
        ///上传楼盘图片
        case .OwnerBuildingJointOpenStationTypeBuildingImage:
            return ((kWidth - left_pending_space_17 * 2 - 5 * 2) / 3.0 + 10) * 4 + 68

        case .none:
            return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.typeSourceArray.count <= 0 {
            return
        }
        
        switch typeSourceArray[indexPath.section].type {
            
            ///选择cell
        case .OwnerBuildingJointOpenStationTypeRentFreePeriod:
            
            ///免租期
            SSLog(typeSourceArray[indexPath.section].type)
            
            endEdting()
            
            ownerFYMoreSettingView.ShowOwnerFYMoreSettingView(datasource: [OwnerRentFreePeriodType.OwnerRentFreePeriodTypeDefault.rawValue,
                                                                           OwnerRentFreePeriodType.OwnerRentFreePeriodTypeMonth1.rawValue,
                                                                           OwnerRentFreePeriodType.OwnerRentFreePeriodTypeMonth2.rawValue,
                                                                           OwnerRentFreePeriodType.OwnerRentFreePeriodTypeMonth3.rawValue,
                                                                           OwnerRentFreePeriodType.OwnerRentFreePeriodTypeMonth4.rawValue,
                                                                           OwnerRentFreePeriodType.OwnerRentFreePeriodTypeMonth5.rawValue,
                                                                           OwnerRentFreePeriodType.OwnerRentFreePeriodTypeMonth6.rawValue,
                                                                           OwnerRentFreePeriodType.OwnerRentFreePeriodTypeMonth7.rawValue,
                                                                           OwnerRentFreePeriodType.OwnerRentFreePeriodTypeMonth8.rawValue,
                                                                           OwnerRentFreePeriodType.OwnerRentFreePeriodTypeMonth9.rawValue,
                                                                           OwnerRentFreePeriodType.OwnerRentFreePeriodTypeMonth10.rawValue,
                                                                           OwnerRentFreePeriodType.OwnerRentFreePeriodTypeMonth11.rawValue,
                                                                           OwnerRentFreePeriodType.OwnerRentFreePeriodTypeMonth12.rawValue], clearButtonCallBack: {
                                                                            
            }) {[weak self] (settingEnumIndex) in
                //单层1 多层2
                self?.loadSections(indexSet: [indexPath.section])
            }
            
        ///所在楼层
        case .OwnerBuildingJointOpenStationTypeTotalFloor:
            
            if indexPath.row == 0 {
                
                endEdting()
                
                ownerFYMoreSettingView.ShowOwnerFYMoreSettingView(datasource: [OwnerBuildingTotalFloorType.OwnerBuildingTotalFloorTypeOne.rawValue, OwnerBuildingTotalFloorType.OwnerBuildingTotalFloorTypeMore.rawValue], clearButtonCallBack: {
                    
                }) {[weak self] (settingEnumIndex) in
                    //单层1 多层2
                    if settingEnumIndex == 0 {
                        self?.buildingModel?.floorType = "1"
                    }else if settingEnumIndex == 1 {
                        self?.buildingModel?.floorType = "2"
                    }
                    self?.loadSections(indexSet: [indexPath.section])
                }
                
            }
            
        ///正数字文本输入cell
        case .OwnerBuildingJointOpenStationTypeSeats, .OwnerBuildingJointOpenStationTypeMinRentalPeriod:
            
            ///工位数
            ///最短租期
            SSLog(typeSourceArray[indexPath.section].type)

            
            ///数字 - 一位小数点文本输入cell
        ///租金
        case .OwnerBuildingJointOpenStationTypePrice:
            
            ///数字文本输入cell
            SSLog(typeSourceArray[indexPath.section].type)

        ///上传楼盘图片
        case .OwnerBuildingJointOpenStationTypeBuildingImage:
            SSLog(typeSourceArray[indexPath.section].type)

        case .none:
            SSLog(typeSourceArray[indexPath.section].type)

        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = kAppWhiteColor
        return view
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0
    }
}



