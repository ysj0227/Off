//
//  RenterOfficebuildingDeatailHuxingCell.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/11.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterOfficebuildingDeatailHuxingCell: BaseTableViewCell {

    @IBOutlet weak var huxingConstangHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func rowHeight() -> CGFloat {
        return 241 + 25
    }
}
