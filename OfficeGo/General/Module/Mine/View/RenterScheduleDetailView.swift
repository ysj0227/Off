//
//  RenterScheduleDetailView.swift
//  OfficeGo
//
//  Created by mac on 2020/5/19.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterScheduleDetailView: UIView {
    
    @IBOutlet weak var houseNameLabel: UILabel!
    @IBOutlet weak var userAvatarImg: BaseImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userCompanyLabel: UILabel!
    @IBOutlet weak var scheduleTimeLabel: UILabel!
    @IBOutlet weak var scheduleAddressLabel: UILabel!
    @IBOutlet weak var scheduleTrafficLabel: UILabel!
    
    @IBOutlet weak var addreddHeightConstant: NSLayoutConstraint!
    @IBAction func clickToChat(_ sender: Any) {
    }
    
    @IBAction func clickToTelephone(_ sender: Any) {
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
            houseNameLabel.text = buildingViewModel?.schedulebuildingName
            userAvatarImg.setImage(with: buildingViewModel?.avatarString ?? "", placeholder: UIImage.init(named: "avatar"))
            userNameLabel.text = buildingViewModel?.contactNameString
            userCompanyLabel.text = buildingViewModel?.companyJobString
            scheduleTimeLabel.text = buildingViewModel?.dateTimeString
            scheduleAddressLabel.text = buildingViewModel?.addressString
            scheduleTrafficLabel.text = buildingViewModel?.trafficString ?? ""
            addreddHeightConstant.constant = buildingViewModel?.trafficHeight ?? 0
        }
    }
    override func draw(_ rect: CGRect) {

    }

}
