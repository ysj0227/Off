//
//  RenterSearchViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/5/14.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
class RenterSearchViewController: BaseViewController {
    var layout: UICollectionViewLeftAlignedLayout = {
        let ll = UICollectionViewLeftAlignedLayout.init()
        ll.estimatedItemSize = .zero
        ll.minimumLineSpacing = 12
        ll.minimumInteritemSpacing = 12
        ll.headerReferenceSize = CGSize(width: kWidth - left_pending_space_17 * 2, height: 66) //组头视图高度
        ll.scrollDirection = .vertical
        return ll
    }()
    
    var collectionView: UICollectionView?
    
    var dataArr: [HouseFeatureModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        setData()
    }
    
    func setupView() {
        titleview = ThorNavigationView.init(type: .homeSearchRightBlue)
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .homeSearchRightBlue))
        self.view.bringSubviewToFront(titleview ?? ThorNavigationView.init(type: .homeSearchRightBlue))
        titleview?.rightBtnClickBlock = { [weak self] in
            self?.navigationController?.dismiss(animated: true, completion: nil)
        }
        titleview?.searchBarView.searchTextfiled.delegate = self
        
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView?.backgroundColor = kAppWhiteColor
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.contentInset = UIEdgeInsets(top: 5, left: left_pending_space_17, bottom: 0, right: 0)
        collectionView?.register(RenterSearchHistoryCollectionCell.self, forCellWithReuseIdentifier: RenterSearchHistoryCollectionCell.reuseIdentifierStr)
        collectionView?.register(RenterSearchRecommendCollectionCell.self, forCellWithReuseIdentifier: RenterSearchRecommendCollectionCell.reuseIdentifierStr)
        collectionView?.register(RenterSearchCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RenterSearchCollectionViewHeader")
        self.view.addSubview(collectionView ?? UICollectionView())
        self.collectionView?.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(kNavigationHeight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        collectionView?.snp.makeConstraints({ (make) in
            make.top.equalTo(kNavigationHeight)
            make.leading.bottom.trailing.equalToSuperview()
        })
    }
    
    func setData() {
        let model = HouseFeatureModel()
        model.dictCname = "ji"
        let model1 = HouseFeatureModel()
        model1.dictCname = "呃呃呃"
        let model2 = HouseFeatureModel()
        model2.dictCname = "俄方发个哥哥去"
        let model3 = HouseFeatureModel()
        model3.dictCname = "AAAA"
        let model4 = HouseFeatureModel()
        model4.dictCname = "热门"
        let model5 = HouseFeatureModel()
        model5.dictCname = "方法方法"
        let model6 = HouseFeatureModel()
        model6.dictCname = "上海大厦上海大厦上海大厦上海大厦上海大厦上海大厦上海大厦上海大厦上海大厦上海大厦上海大厦上海大厦上海大厦上海大厦上海大厦上海大厦上海大厦上海大厦"
        let model7 = HouseFeatureModel()
        model7.dictCname = "测试擦好姑娘数据- - - -- - 的年纪爱护肤IE"
        let model8 = HouseFeatureModel()
        model8.dictCname = "宝贝宝贝"
        let model9 = HouseFeatureModel()
        model9.dictCname = "恶吻吻吻"
        let model10 = HouseFeatureModel()
        model10.dictCname = "饿"
        dataArr.append(model)
        dataArr.append(model1)
        dataArr.append(model2)
        dataArr.append(model3)
        dataArr.append(model4)
        dataArr.append(model5)
        dataArr.append(model6)
        dataArr.append(model7)
        dataArr.append(model8)
        dataArr.append(model9)
        dataArr.append(model10)
        collectionView?.reloadData()
        
    }
}

extension RenterSearchViewController :UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        clickPushToSearchListVc(sarchStr: textField.text ?? "")
        return true
    }
}

extension RenterSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 || indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RenterSearchHistoryCollectionCell.reuseIdentifierStr, for: indexPath as IndexPath) as? RenterSearchHistoryCollectionCell
            cell?.model = dataArr[indexPath.item]
            //点击了某个item
            cell?.buttonCallBack = {[weak self] (str) in
                self?.clickPushToSearchListVc(sarchStr: str)
            }
            return cell ?? RenterSearchHistoryCollectionCell()
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RenterSearchRecommendCollectionCell.reuseIdentifierStr, for: indexPath as IndexPath) as? RenterSearchRecommendCollectionCell
            cell?.model = dataArr[indexPath.item]
            //点击了某个item
            cell?.buttonCallBack = {[weak self] (str) in
                self?.clickPushToSearchListVc(sarchStr: str)
            }
            return cell ?? RenterSearchRecommendCollectionCell()
            
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    //返回多少个cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            clickPushToSearchListVc(sarchStr: "")
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 || indexPath.section == 1 {
            let model: HouseFeatureModel
            model = dataArr[indexPath.item]
            return RenterSearchHistoryCollectionCell.sizeWithData(model: model)
        }else {
            return CGSize(width: kWidth - left_pending_space_17, height: 60)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 || section == 1 {
            return UIEdgeInsets(top: 2, left: 0, bottom: 0, right: left_pending_space_17)
            
        }else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RenterSearchCollectionViewHeader", for: indexPath) as? RenterSearchCollectionViewHeader
            if indexPath.section == 0 {
                header?.titleLabel.text = "历史"
                header?.headerButton.setImage(UIImage.init(named: "draftIcon"), for: .normal)
                header?.buttonCallBack = {[weak self] (str) in
                    //刷新数据
                }
            }else  if indexPath.section == 1 {
                header?.titleLabel.text = "发现"
                header?.headerButton.setImage(UIImage.init(named: "refreshRM"), for: .normal)
                header?.buttonCallBack = {[weak self] (str) in
                    //刷新数据
                }
            }else  if indexPath.section == 2 {
                header?.titleLabel.text = "推荐"
                header?.headerButton.setImage(UIImage.init(named: ""), for: .normal)
                header?.buttonCallBack = {[weak self] (str) in
                    //刷新数据
                }
            }
            return header ?? UICollectionReusableView()
        }
        
        return UICollectionReusableView()
    }
}

