//
//  HouseTypeCell.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/27.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class HouseTypeCell: BaseTableViewCell {

    typealias HouseTypeSelectBlock = (_ type: HouseTypeEnum) -> Void
    
    var houseTypeBlock: HouseTypeSelectBlock?

    @IBOutlet weak var categoryTitleLabel: UILabel!

    @IBOutlet weak var officeBuildingButton: UIButton!

    @IBOutlet weak var jointOfficeButton: UIButton!
    
    @IBAction func officeBuildingSelect(_ sender: Any) {
        guard let blockk = houseTypeBlock else {
            return
        }
        self.setBtnSelected(btn: officeBuildingButton)
        self.setUnBtnSelected(btn: jointOfficeButton)
        blockk(HouseTypeEnum.officeBuildingEnum)
    }
    
    @IBAction func jointOfficeSelect(_ sender: Any) {
        guard let blockk = houseTypeBlock else {
            return
        }
        self.setBtnSelected(btn: jointOfficeButton)
        self.setUnBtnSelected(btn: officeBuildingButton)
        blockk(HouseTypeEnum.jointOfficeEnum)
    }
    
    func setBtnSelected(btn: UIButton) {
        btn.setTitleColor(kAppBlueColor, for: .normal)
        btn.titleLabel?.font = FONT_MEDIUM_12
        btn.backgroundColor = kAppLightBlueColor
    }
    
    func setUnBtnSelected(btn: UIButton) {
        btn.setTitleColor(kAppColor_333333, for: .normal)
        btn.titleLabel?.font = FONT_12
        btn.backgroundColor = kAppColor_bgcolor_F7F7F7
    }
    
    class func rowHeight() -> CGFloat {
        return 110
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
