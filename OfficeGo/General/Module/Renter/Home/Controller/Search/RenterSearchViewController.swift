//
//  RenterSearchViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/5/14.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

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
    
    var searchResultVC: ESearchRenterResultListViewController?
    
    var collectionView: UICollectionView?
    
    var historyDatasource: [SearchHistoryModel?] = []
    
    var findHotDatasource: [DictionaryModel?] = []
    
    
    var dataArr: [HouseFeatureModel] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //每次点击人民广场或者搜索跳到新的页面之后 都要刷新历史记录接口
        requestGetHistory()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        setData()
    }
    
    @objc func valueDidChange() {
        if titleview?.searchBarView.searchTextfiled.text?.isBlankString == true {
            searchResultVC?.view.isHidden = true
            searchResultVC?.keywords = ""
        }else {
            searchResultVC?.view.isHidden = false
            searchResultVC?.keywords = titleview?.searchBarView.searchTextfiled.text
            
        }
        
    }
    
    func setupView() {
        
        titleview = ThorNavigationView.init(type: .homeSearchRightBlue)
        titleview?.searchBarView.searchTextfiled.delegate = self
        titleview?.searchBarView.searchTextfiled.clearButtonMode = .always
        titleview?.searchBarView.searchTextfiled.keyboardType = .webSearch
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .homeSearchRightBlue))
        self.view.bringSubviewToFront(titleview ?? ThorNavigationView.init(type: .homeSearchRightBlue))
        titleview?.rightBtnClickBlock = { [weak self] in
            self?.navigationController?.dismiss(animated: true, completion: nil)
        }
        titleview?.searchBarView.searchTextfiled.addTarget(self, action: #selector(valueDidChange), for: .editingChanged)
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
        
        searchResultVC = ESearchRenterResultListViewController.init()
        searchResultVC?.view.isHidden = true
        self.view.addSubview(searchResultVC?.view ?? UIView())
        
        // 传递闭包 当点击’搜索结果‘的cell调用
        searchResultVC?.callBack = {[weak self] (model) in
            // 搜索完成 关闭resultVC
            if model.btype == 1 {
                let vc = RenterOfficebuildingDetailVC()
                vc.buildingModel = model
                self?.navigationController?.pushViewController(vc, animated: true)
            }else if model.btype == 2 {
                let vc = RenterOfficeJointDetailVC()
                vc.buildingModel = model
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        
        collectionView?.snp.makeConstraints({ (make) in
            make.top.equalTo(kNavigationHeight)
            make.leading.bottom.trailing.equalToSuperview()
        })
        
        searchResultVC?.view.snp.makeConstraints({ (make) in
            make.top.equalTo(kNavigationHeight)
            make.leading.bottom.trailing.equalToSuperview()
        })
    }
    
    func setData() {
        
        requestGetHotFind()
    }
}
extension RenterSearchViewController {
    
    //MARK: 历史记录
    func requestGetHistory() {
        var params = [String:AnyObject]()
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        SSNetworkTool.SSSearch.request_getHistorySearchKeywords(params: params, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<SearchHistoryModel>.deserializeModelArrayFrom(json: JSON(response).rawString() ?? "", designatedPath: "data") {
                
                weakSelf.historyDatasource = decoratedArray
                weakSelf.collectionView?.reloadData()
            }
            
            }, failure: { (error) in
                
        }) { (code, message) in
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    
    //MARK: 清除历史记录
    func requestClearHistory() {
        
        var params = [String:AnyObject]()
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        SSNetworkTool.SSSearch.request_getClearHistorySearchKeywords(params: params, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            weakSelf.historyDatasource.removeAll()
            weakSelf.collectionView?.reloadData()
            
            }, failure: { (error) in
                
        }) { (code, message) in
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    //MARK: 发现- 热门关键字
    func requestGetHotFind() {
        
        SSNetworkTool.SSBasic.request_getDictionary(code: .codeEnumhotKeywords, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<HouseFeatureModel>.deserializeModelArrayFrom(json: JSON(response).rawString() ?? "", designatedPath: "data") {
                weakSelf.findHotDatasource = decoratedArray
                weakSelf.collectionView?.reloadData()
            }
            
            }, failure: {(error) in
                
        }) {(code, message) in
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
}
extension RenterSearchViewController :UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.isBlankString == true {
            AppUtilities.makeToast("请输入搜索内容")
            return false
        }
        clickPushToSearchListVc(sarchStr: textField.text ?? "")
        return true
    }
    
}

extension RenterSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RenterSearchHistoryCollectionCell.reuseIdentifierStr, for: indexPath as IndexPath) as? RenterSearchHistoryCollectionCell
            cell?.isHistory = true
            cell?.historyModel = historyDatasource[indexPath.item] ?? SearchHistoryModel()
            //点击了某个item
            cell?.buttonCallBack = {[weak self] (str) in
                self?.clickPushToSearchListVc(sarchStr: str)
            }
            return cell ?? RenterSearchHistoryCollectionCell()
        }else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RenterSearchHistoryCollectionCell.reuseIdentifierStr, for: indexPath as IndexPath) as? RenterSearchHistoryCollectionCell
            cell?.isHistory = false
            cell?.findHotModel = findHotDatasource[indexPath.item] ?? DictionaryModel()
            //点击了某个item
            cell?.buttonCallBack = {[weak self] (str) in
                self?.clickPushToSearchListVc(sarchStr: str)
            }
            return cell ?? RenterSearchHistoryCollectionCell()
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RenterSearchRecommendCollectionCell.reuseIdentifierStr, for: indexPath as IndexPath) as? RenterSearchRecommendCollectionCell
            //点击了某个item
            cell?.buttonCallBack = {[weak self] (str) in
                self?.clickPushToSearchListVc(sarchStr: str)
            }
            return cell ?? RenterSearchRecommendCollectionCell()
            
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //        return 3
        return 2
    }
    //返回多少个cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return historyDatasource.count
        }else if section == 1 {
            return findHotDatasource.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            clickPushToSearchListVc(sarchStr: "")
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            
            return RenterSearchHistoryCollectionCell.sizeWithHistoryModelData(historyModel: historyDatasource[indexPath.item] ?? SearchHistoryModel())
            
        }else if indexPath.section == 1 {
            
            return RenterSearchHistoryCollectionCell.sizeWithFindHotData(findHotModel: findHotDatasource[indexPath.item] ?? DictionaryModel())
            
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
                    self?.requestClearHistory()
                }
            }else  if indexPath.section == 1 {
                header?.titleLabel.text = "发现"
                header?.headerButton.setImage(UIImage.init(named: "refreshRM"), for: .normal)
                header?.buttonCallBack = {[weak self] (str) in
                    //刷新数据
                    self?.requestGetHotFind()
                }
            }
            /*else  if indexPath.section == 2 {
             header?.titleLabel.text = "推荐"
             header?.headerButton.setImage(UIImage.init(named: ""), for: .normal)
             header?.buttonCallBack = {[weak self] (str) in
             //刷新数据
             }
             }*/
            return header ?? UICollectionReusableView()
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            if historyDatasource.count > 0 {
                return CGSize(width: kWidth - left_pending_space_17 * 2, height: 66)
            }
        }else if section == 1 {
            if findHotDatasource.count > 0 {
                return CGSize(width: kWidth - left_pending_space_17 * 2, height: 66)
            }
        }
        return CGSize(width: kWidth - left_pending_space_17 * 2, height: 0)
    }
}

