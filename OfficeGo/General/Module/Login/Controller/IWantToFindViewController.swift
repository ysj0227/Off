//
//  IWantToFindViewController.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/27.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

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
        
        shaixuanView.ShowHouseShaixuanView(issubView:true, model: self.selectModel, clearButtonCallBack: {
            
        }, sureHouseShaixuanButtonCallBack: { [weak self] (_ selectModel: HouseSelectModel) -> Void in
            self?.selectModel = selectModel
        })
        
    }
    
    override func leftBtnClick() {
        UIApplication.shared.keyWindow?.subviews.forEach({ (view) in
            if view.isKind(of: HouseShaixuanSelectView.self) {
                view.removeFromSuperview()
            }
        })
        self.navigationController?.popViewController(animated: true)
    }
    
    override func rightBtnClick() {
        UIApplication.shared.keyWindow?.subviews.forEach({ (view) in
            if view.isKind(of: HouseShaixuanSelectView.self) {
                view.removeFromSuperview()
            }
        })
        NotificationCenter.default.post(name: NSNotification.Name.UserLogined, object: nil)
    }
}


extension IWantToFindViewController {
    func setDataModel() {
        //装修类型数据源模拟
        let documentModel = HouseFeatureModel()
        documentModel.title = "11"
        documentModel.id = "1"
        let documentModel2 = HouseFeatureModel()
        documentModel2.title = "22"
        documentModel2.id = "2"
        let ddocumentModel = HouseFeatureModel()
        ddocumentModel.title = "交通方便"
        ddocumentModel.id = "13"
        let ddocumentModel2 = HouseFeatureModel()
        ddocumentModel2.title = "商圈环绕"
        ddocumentModel2.id = "25"
        selectModel.shaixuanModel.documentTypeModelArr.append(documentModel)
        selectModel.shaixuanModel.documentTypeModelArr.append(documentModel2)
        selectModel.shaixuanModel.documentTypeModelArr.append(ddocumentModel)
        selectModel.shaixuanModel.documentTypeModelArr.append(ddocumentModel2)
        
        //房源特色数据源模拟
        let fdocumentModel = HouseFeatureModel()
        fdocumentModel.title = "交通方便"
        fdocumentModel.id = "9"
        let fdocumentModel2 = HouseFeatureModel()
        fdocumentModel2.title = "商圈环绕"
        fdocumentModel2.id = "299"
        selectModel.shaixuanModel.featureModelArr.append(fdocumentModel)
        selectModel.shaixuanModel.featureModelArr.append(fdocumentModel2)
        selectModel.shaixuanModel.featureModelArr.append(fdocumentModel)
        selectModel.shaixuanModel.featureModelArr.append(fdocumentModel2)
        selectModel.shaixuanModel.featureModelArr.append(fdocumentModel)
        selectModel.shaixuanModel.featureModelArr.append(fdocumentModel2)
        selectModel.shaixuanModel.featureModelArr.append(fdocumentModel)
        selectModel.shaixuanModel.featureModelArr.append(fdocumentModel2)
    }
}
