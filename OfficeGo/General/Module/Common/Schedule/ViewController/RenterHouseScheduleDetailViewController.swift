//
//  RenterHouseScheduleDetailViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/5/19.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterHouseScheduleDetailViewController: BaseViewController {
    
    let topview: UIView = {
        let view = UIView()
        view.backgroundColor = kAppBlueColor
        return view
    }()
    
    let msgView: RenterScheduleDetailView = {
        let view = Bundle.main.loadNibNamed("RenterScheduleDetailView", owner: nil, options: nil)?.first as! RenterScheduleDetailView
//        view.shadow()
        view.setCornerRadius(cornerRadius: 12)
        view.layer.borderColor = UIColor.init(white: 0.9, alpha: 0.3).cgColor
        view.layer.borderWidth = 5.0
        return view
    }()
    
    var scheduleId: Int?
    
    var scheduleListDetailModel: ScheduleListDetailModel?
    
    var scheduleListDetailViewModel: ScheduleListDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        
        refreshData()
    }
    
    func refreshData() {
        
        var params = [String:AnyObject]()
        params["token"] = UserTool.shared.user_token as AnyObject?
        params["scheduleId"] = scheduleId as AnyObject?

        SSNetworkTool.SSSchedule.request_getScheduleDetailApp(params: params, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let model = ScheduleListDetailModel.deserialize(from: response, designatedPath: "data") {

                weakSelf.scheduleListDetailModel = model
                weakSelf.scheduleListDetailViewModel = ScheduleListDetailViewModel.init(model: model)

                weakSelf.setViewModel()
            }
            
            }, failure: { (error) in
                
        }) { (code, message) in
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
}

extension RenterHouseScheduleDetailViewController {
    
    func setView() {
        
        titleview = ThorNavigationView.init(type: .HouseScheduleHeaderView)
        titleview?.titleLabel.text = "已完成"
        titleview?.titleLabel.textAlignment = .left
        titleview?.leftButtonCallBack = { [weak self] in
            self?.leftBtnClick()
        }
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .HouseScheduleHeaderView))
        
        self.view.addSubview(msgView)
        msgView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.top.equalTo(kNavigationHeight + 47)
            make.height.equalTo(202)
        }
    }
    
    func setViewModel() {
        
        titleview?.titleLabel.text = scheduleListDetailViewModel?.buildingViewModel?.auditStatusString

        let height = self.scheduleListDetailViewModel?.buildingViewModel?.trafficHeight ?? 30
        SSTool.invokeInMainThread {[weak self] in
            self?.msgView.snp.remakeConstraints { (make) in
                make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
                make.top.equalTo(kNavigationHeight + 47)
                make.height.equalTo(202 - 30 + height)
            }
            self?.msgView.buildingViewModel = self?.scheduleListDetailViewModel?.buildingViewModel
        }
    }
    
}
