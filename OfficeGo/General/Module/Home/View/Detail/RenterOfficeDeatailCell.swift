//
//  RenterOfficeDeatailCell.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/11.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterOfficeDeatailCell: BaseTableViewCell {
    
    @IBOutlet weak var ruzhuQiyeConstantHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        ruzhuQiyeConstantHeight.constant = 25
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func rowHeight() -> CGFloat {
        return 493 - 25 + ruzhuQiyeConstantHeight.constant
    }
}
