//
//  CityOrRegionSelectCell.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/27.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class CityOrRegionSelectCell: BaseTableViewCell {
    
    @IBOutlet weak var cityButton: UIButton!
    
    @IBOutlet weak var addressButton: UIButton!
    
    @IBAction func citySelect(_ sender: Any) {
    }
    
    @IBAction func addressSelect(_ sender: Any) {
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
