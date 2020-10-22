//
//  BaseCollectionViewCell.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/29.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    class var reuseIdentifierStr: String {
        return String(describing: self.self)
    }
    
}
  
