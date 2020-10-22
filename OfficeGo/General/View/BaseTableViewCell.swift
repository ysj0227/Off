//
//  BaseTableViewCell.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/27.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    class var reuseIdentifierStr: String {
        return String(describing: self.self)
    }
    
    lazy var bottomLine: UIView = {
        let view = UIView(frame: CGRect(x: left_pending_space_17, y: self.height - 1, width: kWidth - left_pending_space_17 * 2, height: 1))
        view.isHidden = true
        return view
    }()
        
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = kAppWhiteColor
        self.addSubview(bottomLine)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
