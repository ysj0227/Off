//
//  RenterHeaderItemSelectView.swift
//  OfficeGo
//
//  Created by mac on 2020/5/12.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterHeaderItemSelectView: UIView {
    
    var headerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = kAppWhiteColor
        return view
    }()
    
    func reloadData() {
        headerCollectionView.reloadData()
    }
    
    var itemSelectCallBack:((Int) -> Void)?
    
    var selectedIndex: Int = 0 {
        didSet {
            guard let blockk = itemSelectCallBack else {
                return
            }
            blockk(selectedIndex)
        }
    }
    
    var selectModel: HouseSelectModel = HouseSelectModel() {
        didSet {
            reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpSubviews()
    }
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.frame = frame
        
        setUpSubviews()
    }
    
    func setUpSubviews() {
        headerCollectionView.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
        headerCollectionView.register(RenterHeaderItemCell.self, forCellWithReuseIdentifier: RenterHeaderItemCell.reuseIdentifierStr)
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
        self.addSubview(headerCollectionView)
        reloadData()
    }
}

extension RenterHeaderItemSelectView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RenterHeaderItemCell.reuseIdentifierStr, for: indexPath as IndexPath) as? RenterHeaderItemCell
        if indexPath.item == 0 {
            cell?.titleString = "全部 \n 50套"
        }else if indexPath.item == 1 {
            cell?.titleString = "100-300㎡ \n 10套"
        }else if indexPath.item == 2 {
            cell?.titleString
                = "300-500 \n 20套"
        }else if indexPath.item == 3 {
            cell?.titleString = "500-1000㎡ \n 10套"
        }else {
            cell?.titleString = "\(indexPath.item)" + "00-1000㎡ \n 10套"
        }
        if indexPath.item == selectedIndex {
            cell?.itemView.backgroundColor = kAppBlueColor
            cell?.itemView.textColor = kAppWhiteColor
        }else {
            cell?.itemView.backgroundColor = kAppWhiteColor
            cell?.itemView.textColor = kAppBlueColor
        }
        return cell ?? RenterHeaderItemCell()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    //返回多少个cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        self.headerCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 72, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

class RenterHeaderItemCell: UICollectionViewCell {
    
    class var reuseIdentifierStr: String {
        return String(describing: self.self)
    }
    
    //FIXME: 本地和网络下载走的不同路径
    var titleString: String = "" {
        didSet {
            itemView.text = self.titleString
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 懒加载
    lazy var itemView: UILabel = {
        let itemView = UILabel(frame: bounds)
        itemView.numberOfLines = 2
        itemView.textAlignment = .center
        itemView.font = FONT_11
        itemView.textColor = kAppBlueColor
        itemView.clipsToBounds = true
        itemView.layer.cornerRadius = button_cordious_2
        itemView.layer.borderColor = kAppBlueColor.cgColor
        itemView.layer.borderWidth = 1.0
        return itemView
    }()
}

//MARK: 设置UI
extension RenterHeaderItemCell {
    fileprivate func setUpUI() {
        self.addSubview(itemView)
    }
}
