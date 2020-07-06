//
//  IWantToFindViewController.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/27.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

class IWantToFindViewController: BaseViewController {
    
    lazy var shaixuanView: HouseShaixuanSelectView = {
        let view = HouseShaixuanSelectView.init(frame: CGRect(x: 0, y: kNavigationHeight, width: kWidth, height: self.view.height - bottomMargin() - kNavigationHeight))
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = FONT_LIGHT_13
        label.text = "为了便于我们帮你推荐合适的房源请完成以下选项"
        label.textColor = kAppColor_999999
        return label
    }()
    
    var selectModel:HouseSelectModel = HouseSelectModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleview = ThorNavigationView.init(type: .backTitleRight)
        titleview?.titleLabel.text = "我想找"
        titleview?.rightButton.isHidden = false
        titleview?.rightButton.setTitle("跳过", for: .normal)
        titleview?.rightButton.backgroundColor = kAppBlueColor
        titleview?.rightButton.setTitleColor(kAppWhiteColor, for: .normal)
        titleview?.leftButton.addTarget(self, action: #selector(leftBtnClick), for: .touchUpInside)
        titleview?.rightButton.addTarget(self, action: #selector(rightBtnClick), for: .touchUpInside)
        
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .backTitleRight))
        
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleview?.snp.bottom ?? kNavigationHeight)
            make.leading.equalToSuperview().offset(left_pending_space_17)
            make.trailing.equalToSuperview().offset(-left_pending_space_17)
            make.height.equalTo(50)
        }
        
        setDataModel()
        
    }
    
    override func leftBtnClick() {
        UIApplication.shared.keyWindow?.subviews.forEach({ (view) in
            if view.isKind(of: HouseShaixuanSelectView.self) {
                view.removeFromSuperview()
            }
        })
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setModelShow()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.keyWindow?.subviews.forEach({ (view) in
            if view.isKind(of: HouseShaixuanSelectView.self) {
                view.removeFromSuperview()
            }
        })
    }
    
    override func rightBtnClick() {
        
        //都是跳转到tabbar
        //NotificationCenter.default.post(name: NSNotification.Name.SetRenterTabbarViewController, object: nil)
    }
}

//MARK:-  API调用接口
extension IWantToFindViewController {
    
    //MARK:-  装修类型
    func requestGetDecorate() {
        
        SSNetworkTool.SSBasic.request_getDictionary(code: .codeEnumdecoratedType, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<HouseFeatureModel>.deserializeModelArrayFrom(json: JSON(response).rawString() ?? "", designatedPath: "data") {
                for model in decoratedArray {
                    weakSelf.selectModel.shaixuanModel.documentTypeModelArr.append(model ?? HouseFeatureModel())
                }
            }
            weakSelf.shaixuanView.selectModel = weakSelf.selectModel
            
            }, failure: {[weak self] (error) in
                self?.shaixuanView.selectModel = self?.selectModel ?? HouseSelectModel()
                
        }) {[weak self] (code, message) in
            self?.shaixuanView.selectModel = self?.selectModel ?? HouseSelectModel()
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    //MARK:-  装修特色
    func requestGetFeature() {
        
        SSNetworkTool.SSBasic.request_getDictionary(code: .codeEnumbranchUnique, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<HouseFeatureModel>.deserializeModelArrayFrom(json: JSON(response).rawString() ?? "", designatedPath: "data") {
                for model in decoratedArray {
                    weakSelf.selectModel.shaixuanModel.featureModelArr.append(model ?? HouseFeatureModel())
                }
            }
            weakSelf.requestGetDecorate()
            
            }, failure: {[weak self] (error) in
                self?.requestGetDecorate()
        }) {[weak self] (code, message) in
            self?.requestGetDecorate()
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    //MARK:-  页面显示
    func setModelShow() {
        shaixuanView.ShowHouseShaixuanView(issubView:true, model: self.selectModel, clearButtonCallBack: { [weak self] (_ selectModel: HouseSelectModel) -> Void in
            self?.selectModel = selectModel
            self?.request_addWantToFind()
        }, sureHouseShaixuanButtonCallBack: { [weak self] (_ selectModel: HouseSelectModel) -> Void in
            self?.selectModel = selectModel
            self?.request_addWantToFind()
        })
    }
    
    //MARK:-  添加我想找接口
    func request_addWantToFind() {
        //调用登录接口 - 成功跳转登录
        var params = [String:AnyObject]()
        
        var btype: Int? //类型,1:楼盘 写字楼,2:网点 联合办公
        if selectModel.typeModel.type == .officeBuildingEnum {
            btype = 1
        }else {
            btype = 2
        }
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        params["btype"] = btype as AnyObject?
        
        //工位 - 两者都有
        var gongweiExtentStr: String?
        
        //租金 - 两者都有
        var zujinExtentStr: String?
        /*
        //房源特色 - 两者都有
        var featureArr: [String] = []*/
        
        
        //联合办公
        if btype == 2 {
            
            if self.selectModel.shaixuanModel.gongweijointOfficeExtentModel.highValue == self.selectModel.shaixuanModel.gongweijointOfficeExtentModel.maximumValue {
                gongweiExtentStr = String(format: "%.0f", self.selectModel.shaixuanModel.gongweijointOfficeExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.selectModel.shaixuanModel.gongweijointOfficeExtentModel.noLimitNum)
            }else {
                gongweiExtentStr = String(format: "%.0f", self.selectModel.shaixuanModel.gongweijointOfficeExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.selectModel.shaixuanModel.gongweijointOfficeExtentModel.highValue ?? 0)
            }
            
            params["seats"] = gongweiExtentStr as AnyObject?
            
            if self.selectModel.shaixuanModel.zujinjointOfficeExtentModel.highValue == self.selectModel.shaixuanModel.zujinjointOfficeExtentModel.maximumValue {
                zujinExtentStr = String(format: "%.0f", self.selectModel.shaixuanModel.zujinjointOfficeExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.selectModel.shaixuanModel.zujinjointOfficeExtentModel.noLimitNum)
            }else {
                zujinExtentStr = String(format: "%.0f", self.selectModel.shaixuanModel.zujinjointOfficeExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.selectModel.shaixuanModel.zujinjointOfficeExtentModel.highValue ?? 0)
            }
            /*
            //房源特色 - 两者都有
            for model in self.selectModel.shaixuanModel.featureModelArr {
                if model.isOfficejointOfficeSelected {
                    featureArr.append("\(model.dictValue ?? 0)")
                }
            }*/
            
        }else if btype == 1 {
            
            if self.selectModel.shaixuanModel.zujinofficeBuildingExtentModel.highValue == self.selectModel.shaixuanModel.zujinofficeBuildingExtentModel.maximumValue {
                zujinExtentStr = String(format: "%.0f", self.selectModel.shaixuanModel.zujinofficeBuildingExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.selectModel.shaixuanModel.zujinofficeBuildingExtentModel.noLimitNum)
            }else {
                zujinExtentStr = String(format: "%.0f", self.selectModel.shaixuanModel.zujinofficeBuildingExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.selectModel.shaixuanModel.zujinofficeBuildingExtentModel.highValue ?? 0)
            }
            
            //办公室 - 面积传值
            var mianjiStr: String?
            if self.selectModel.shaixuanModel.mianjiofficeBuildingExtentModel.highValue == self.selectModel.shaixuanModel.mianjiofficeBuildingExtentModel.maximumValue {
                mianjiStr = String(format: "%.0f", self.selectModel.shaixuanModel.mianjiofficeBuildingExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.selectModel.shaixuanModel.mianjiofficeBuildingExtentModel.noLimitNum)
            }else {
                mianjiStr = String(format: "%.0f", self.selectModel.shaixuanModel.mianjiofficeBuildingExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.selectModel.shaixuanModel.mianjiofficeBuildingExtentModel.highValue ?? 0)
            }
            
            params["area"] = mianjiStr as AnyObject?
            
            //办公室 - 装修类型传值
            var documentArr: [String] = []
            for model in self.selectModel.shaixuanModel.documentTypeModelArr {
                if model.isDocumentSelected {
                    documentArr.append("\(model.dictValue ?? 0)")
                }
            }
            let documentStr: String = documentArr.joined(separator: ",")
            params["decoration"] = documentStr as AnyObject?
            /*
            //房源特色 - 两者都有
            for model in self.selectModel.shaixuanModel.featureModelArr {
                if model.isOfficeBuildingSelected {
                    featureArr.append("\(model.dictValue ?? 0)")
                }
            }*/
        }
        
        params["dayPrice"] = zujinExtentStr as AnyObject?
        /*
        //房源特色 - 两者都有
        let featureStr: String = featureArr.joined(separator: ",")
        params["houseTags"] = featureStr as AnyObject?*/
        
        SSNetworkTool.SSLogin.request_addWantToFind(params: params, success: { [weak self] (response) in
            self?.rightBtnClick()
            
            }, failure: { (error) in
                
        }) { (code, message) in
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
            
        }
    }
    
    //MARK:-  设置状态数据
    func setDataModel() {
        
        requestGetFeature()
    }
}
