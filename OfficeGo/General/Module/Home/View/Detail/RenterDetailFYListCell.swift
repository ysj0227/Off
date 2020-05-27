//
//  RenterDetailFYListCell.swift
//  OfficeGo
//
//  Created by mac on 2020/5/12.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterDetailFYListCell: BaseTableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var leftTopLabel: UILabel!
    @IBOutlet weak var leftbottomLabel: UILabel!
    @IBOutlet weak var rightPriceLabel: UILabel!
    @IBOutlet weak var rightUnitLabel: UILabel!
    @IBOutlet weak var rightBottomUnitLabel: UILabel!

    class func rowHeight() -> CGFloat {
        return 84
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
