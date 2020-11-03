//
//  RenterScheduleDetailView.swift
//  OfficeGo
//
//  Created by mac on 2020/5/19.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterScheduleDetailView: UIView {
    
    ///拨打手机号
    @IBOutlet weak var phoneButton: UIButton!
    
    @IBOutlet weak var houseNameLabel: UILabel!
    @IBOutlet weak var userAvatarImg: BaseImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userCompanyLabel: UILabel!
    @IBOutlet weak var scheduleTimeLabel: UILabel!
    @IBOutlet weak var scheduleAddressLabel: UILabel!
    @IBOutlet weak var scheduleTrafficLabel: UILabel!
    
    @IBOutlet weak var addreddHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var trafficLabelTop: NSLayoutConstraint!

    @IBAction func clickToChat(_ sender: Any) {
    }
    
    @IBAction func clickToTelephone(_ sender: Any) {
        SSTool.callPhoneTelpro(phone: buildingViewModel?.phone ?? "")
    }
    
        var model: ScheduleListDetailModel? {
        didSet {
            if let buildingModel = model?.building {
                buildingViewModel = ScheduleListDetailBuildingViewModel.init(model: buildingModel)
            }
        }
    }

    var buildingViewModel: ScheduleListDetailBuildingViewModel? {
        didSet {
            
            ///行程审核状态 0预约待接受 1预约成功 2预约失败 3已看房
            if buildingViewModel?.auditStatus == 1 || buildingViewModel?.auditStatus == 3 {
                phoneButton.isHidden = false
            }else {
                phoneButton.isHidden = true
            }
            
            houseNameLabel.text = buildingViewModel?.schedulebuildingName
            userAvatarImg.setImage(with: buildingViewModel?.avatarString ?? "", placeholder: UIImage.init(named: "avatar"))
            userNameLabel.text = buildingViewModel?.contactNameString
            userCompanyLabel.text = buildingViewModel?.companyJobString
            scheduleTimeLabel.text = buildingViewModel?.dateTimeString
            scheduleAddressLabel.text = buildingViewModel?.addressString
            scheduleTrafficLabel.text = buildingViewModel?.trafficString ?? ""
            addreddHeightConstant.constant = buildingViewModel?.trafficHeight ?? 0
            trafficLabelTop.constant = buildingViewModel?.trafficTopConstant ?? 0
        }
    }
    override func draw(_ rect: CGRect) {

    }

}
