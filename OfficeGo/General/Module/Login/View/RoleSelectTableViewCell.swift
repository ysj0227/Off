//
//  RoleSelectTableViewCell.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/27.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RoleSelectTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var bgImg: UIImageView!
  
    @IBOutlet weak var titleLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
}
