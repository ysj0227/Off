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

    var factorMap: FangYuanBuildingFactorModel = FangYuanBuildingFactorModel() {
        didSet {
            
            reloadData()
        }
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
        
        if let btype = self.factorMap.btype {
            ///办公楼
            if btype == 1 {
                if indexPath.item == 0 {
                    cell?.titleString = "全部 \n \(self.factorMap.buildingItem0 ?? 0)套"
                }else if indexPath.item == 1 {
                    cell?.titleString = "0-100㎡ \n \(self.factorMap.buildingItem1 ?? 0)套"
                }else if indexPath.item == 2 {
                    cell?.titleString
                        = "100-200 \n \(self.factorMap.buildingItem2 ?? 0)套"
                }else if indexPath.item == 3 {
                    cell?.titleString = "200-300㎡ \n \(self.factorMap.buildingItem3 ?? 0)套"
                }else if indexPath.item == 4 {
                    cell?.titleString = "300-400㎡ \n \(self.factorMap.buildingItem4 ?? 0)套"
                }else if indexPath.item == 5 {
                    cell?.titleString = "400-500㎡ \n \(self.factorMap.buildingItem5 ?? 0)套"
                }else if indexPath.item == 6 {
                    cell?.titleString = "500-1000㎡ \n \(self.factorMap.buildingItem6 ?? 0)套"
                }else if indexPath.item == 7 {
                    cell?.titleString = "1000㎡以上 \n \(self.factorMap.buildingItem7 ?? 0)套"
                }
            }else {
                if indexPath.item == 0 {
                    cell?.titleString = "全部 \n \(self.factorMap.jointworkItem0 ?? 0)套"
                }else if indexPath.item == 1 {
                    cell?.titleString = "1人 \n \(self.factorMap.jointworkItem1 ?? 0)套"
                }else if indexPath.item == 2 {
                    cell?.titleString = "2～3人 \n \(self.factorMap.jointworkItem2 ?? 0)套"
                }else if indexPath.item == 3 {
                    cell?.titleString = "4～6人 \n \(self.factorMap.jointworkItem3 ?? 0)套"
                }else if indexPath.item == 4 {
                    cell?.titleString = "7～10人 \n \(self.factorMap.jointworkItem4 ?? 0)套"
                }else if indexPath.item == 5 {
                    cell?.titleString = "11～15人 \n \(self.factorMap.jointworkItem5 ?? 0)套"
                }else if indexPath.item == 6 {
                    cell?.titleString = "16～20人 \n \(self.factorMap.jointworkItem6 ?? 0)套"
                }else if indexPath.item == 7 {
                    cell?.titleString = "20人以上 \n \(self.factorMap.jointworkItem7 ?? 0)套"
                }
            }
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
        if let btype = self.factorMap.btype {
            ///办公楼
            if btype == 1 {
                return 8

            }else {
                return 8

            }
        }
        return 0
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
