//
//  OwnerBuildingCreateViewController.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/9/28.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

class OwnerBuildingCreateViewController: BaseTableViewController {
    
    var typeSourceArray:[OwnerBuildingEditConfigureModel] = [OwnerBuildingEditConfigureModel]()

    var companyModel: OwnerIdentifyUserModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpData()
        
        setUpView()
    }
    
    func setUpData() {
        
        ///楼盘类型
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeBuildingTypew))
        ///写字楼名称
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeBuildingName))
        ///所在区域
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeDisctict))
        ///详细地址
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeDetailAddress))
        ///总楼层
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeTotalFloor))
        ///竣工时间
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeCompelteTime))
        ///翻新时间
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeRenovationTime))
        ///建筑面积
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeArea))
        ///净高
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeClearHeight))
        ///层高
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeFloorHeight))
        ///物业公司
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypePropertyCompany))
        ///物业费
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypePropertyCoast))
        ///车位数
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeParkingNum))
        ///车位费
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeParkingCoast))
        ///空调类型
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeAirConditionType))
        ///空调费
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeAirConditionCoast))
        ///电梯数 - 客梯
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypePassengerNum))
        ///电梯数 - 货梯
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeFloorCargoNum))
        ///网络
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeNetwork))
        ///入驻企业
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeEnterCompany))
        ///详细介绍
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeDetailIntroduction))
        ///特色
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeFeature))
        ///上传楼盘图片
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeBuildingImage))
        
        if companyModel != nil {
            
        }else {
            companyModel = OwnerIdentifyUserModel()
        }
        
        self.tableView.reloadData()
    }
}

extension OwnerBuildingCreateViewController {
    
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
        titleview?.rightButton.setImage(UIImage.init(named: "scanIcon"), for: .normal)
        titleview?.leftButton.isHidden = false
        titleview?.rightButton.isHidden = false
        titleview?.titleLabel.text = "编辑写字楼"
        titleview?.leftButtonCallBack = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        titleview?.rightBtnClickBlock = { [weak self] in
            let vc = OwnerBuildingCreateViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .backTitleRight))
        
        requestSet()
    }
    
    func requestSet() {
        
        isShowRefreshHeader = false
        
        self.view.backgroundColor = kAppColor_bgcolor_F7F7F7
        
        self.tableView.backgroundColor = kAppColor_bgcolor_F7F7F7
        
        ///选择cell
        self.tableView.register(OwnerBuildingClickCell.self, forCellReuseIdentifier: OwnerBuildingClickCell.reuseIdentifierStr)

        ///文本输入cell
        self.tableView.register(OwnerBuildingInputCell.self, forCellReuseIdentifier: OwnerBuildingInputCell.reuseIdentifierStr)

        ///数字文本输入cell
        self.tableView.register(OwnerBuildingNumInputCell.self, forCellReuseIdentifier: OwnerBuildingNumInputCell.reuseIdentifierStr)

        ///带框文本输入cell
        self.tableView.register(OwnerBuildingBorderInputCell.self, forCellReuseIdentifier: OwnerBuildingBorderInputCell.reuseIdentifierStr)

        
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(kNavigationHeight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-bottomMargin())
        }
        
        refreshData()
        
    }
    
    
}

extension OwnerBuildingCreateViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model:OwnerBuildingEditConfigureModel = typeSourceArray[indexPath.row]
        
        switch model.type {
        ///选择cell
        ///楼盘类型
        ///所在区域
        ///竣工时间
        ///翻新时间
        ///空调类型
        case .OwnerBuildingEditTypeBuildingTypew, .OwnerBuildingEditTypeDisctict, .OwnerBuildingEditTypeCompelteTime, .OwnerBuildingEditTypeRenovationTime, .OwnerBuildingEditTypeAirConditionType:
            
            ///点击cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingClickCell.reuseIdentifierStr) as? OwnerBuildingClickCell
            cell?.selectionStyle = .none
            cell?.model = model
            return cell ?? OwnerBuildingClickCell.init(frame: .zero)
            
            
        ///文本输入cell
        ///写字楼名称
        ///详细地址
        ///物业公司
        case .OwnerBuildingEditTypeBuildingName, .OwnerBuildingEditTypeDetailAddress, .OwnerBuildingEditTypePropertyCompany:
            
            ///文本输入cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingInputCell.reuseIdentifierStr) as? OwnerBuildingInputCell
            cell?.selectionStyle = .none
            cell?.model = model
            return cell ?? OwnerBuildingInputCell.init(frame: .zero)
            
            
            
        ///数字文本输入cell
        ///总楼层
        ///建筑面积
        ///净高
        ///层高
        ///物业费
        ///车位数
        case .OwnerBuildingEditTypeTotalFloor, .OwnerBuildingEditTypeArea, .OwnerBuildingEditTypeClearHeight, .OwnerBuildingEditTypeFloorHeight, .OwnerBuildingEditTypePropertyCoast, .OwnerBuildingEditTypeParkingNum:
            
            ///数字文本输入cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingNumInputCell.reuseIdentifierStr) as? OwnerBuildingNumInputCell
            cell?.selectionStyle = .none
            cell?.model = model
            return cell ?? OwnerBuildingNumInputCell.init(frame: .zero)
                
            
            
        ///有框框文本输入cell
        ///车位费
        ///电梯数 - 客梯
        ///电梯数 - 客、货梯
        case .OwnerBuildingEditTypeParkingCoast, .OwnerBuildingEditTypePassengerNum, .OwnerBuildingEditTypeFloorCargoNum:
           
            ///有框框文本输入cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingBorderInputCell.reuseIdentifierStr) as? OwnerBuildingBorderInputCell
            cell?.selectionStyle = .none
            cell?.model = model
            return cell ?? OwnerBuildingBorderInputCell.init(frame: .zero)
             
            
            
        ///空调费
        case .OwnerBuildingEditTypeAirConditionCoast:
            return UITableViewCell.init(frame: .zero)
            
        ///网络
        case .OwnerBuildingEditTypeNetwork:
            return UITableViewCell.init(frame: .zero)

        ///入驻企业
        case .OwnerBuildingEditTypeEnterCompany:
            return UITableViewCell.init(frame: .zero)

        ///详细介绍
        case .OwnerBuildingEditTypeDetailIntroduction:
            return UITableViewCell.init(frame: .zero)

        ///特色
        case .OwnerBuildingEditTypeFeature:
            return UITableViewCell.init(frame: .zero)

        ///上传楼盘图片
        case .OwnerBuildingEditTypeBuildingImage:
            return UITableViewCell.init(frame: .zero)

        ///上传楼盘视频
        case .OwnerBuildingEditTypeBuildingVideo:
            return UITableViewCell.init(frame: .zero)

        ///上传楼盘vr
        case .OwnerBuildingEditTypeBuildingVR:
            return UITableViewCell.init(frame: .zero)

        case .none:
            return UITableViewCell.init(frame: .zero)
            break
        }
        
        return UITableViewCell.init(frame: .zero)

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeSourceArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return BaseEditCell.rowHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.dataSource.count <= 0 {
            return
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



