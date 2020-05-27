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
    
    @IBAction func clickToChat(_ sender: Any) {
    }
    
    @IBAction func clickToTelephone(_ sender: Any) {
    }
    
    
    var model: String = "" {
        didSet {
            houseNameLabel.text = "约看：" + ""
            userAvatarImg.setImage(with: "", placeholder: UIImage.init(named: "avatar"))
            userNameLabel.text = "名字"
            userCompanyLabel.text = "公司"
            scheduleTimeLabel.text = "时间点"
            scheduleAddressLabel.text = "地址"
            scheduleTrafficLabel.text = "公交"
        }
    }

    override func draw(_ rect: CGRect) {

    }

}
