//
//  CellFlowLayout.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class CellFlowLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare()
        //尺寸
        itemSize = (collectionView?.bounds.size)!
        //间距
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        //滚动方向
        scrollDirection = .horizontal
    }
}


class areaFlowLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare()
        //尺寸
        itemSize = (collectionView?.bounds.size)!
        //间距
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        //滚动方向
        scrollDirection = .horizontal
    }
}
