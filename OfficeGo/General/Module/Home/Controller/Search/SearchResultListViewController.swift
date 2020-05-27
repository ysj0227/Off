//
//  SearchResultListViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/5/15.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class SearchResultListViewController: BaseTableViewController {
    
    var searchString: String = "" {
        //搜索接口
        //设置上面button的title
        didSet {
            titleview?.searchBarBtnTitleLabel?.text = searchString
        }
    }
    
    var selectView: HouseSelectBtnView = {
        let view = HouseSelectBtnView.init(frame: CGRect(x: 0, y: kNavigationHeight, width: kWidth, height: 60))
        view.hiddenArea = false
        return view
    }()
    
    var selectModel: HouseSelectModel = HouseSelectModel() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        selectView.removeShowView()
    }
    
    func setDataModel() {
        
        let categoryModel = AreaCategorySelectModel()
        categoryModel.id = "1"
        categoryModel.name = "商圈"
        let firstModel = AreaCategoryFirstLevelSelectModel()
        firstModel.id = "11"
        firstModel.n = "1号线"
        let firstModel2 = AreaCategoryFirstLevelSelectModel()
        firstModel2.id = "12"
        firstModel2.n = "2号线"
        
        let dseconModel = AreaCategorySecondLevelSelectModel()
        dseconModel.id = "111"
        dseconModel.n = "上海站"
        let dseconModel112 = AreaCategorySecondLevelSelectModel()
        dseconModel112.id = "112"
        dseconModel112.n = "上海站11"
        
        firstModel.list.append(dseconModel)
        firstModel.list.append(dseconModel112)
        
        
        let dseconModel22 = AreaCategorySecondLevelSelectModel()
        dseconModel22.id = "121"
        dseconModel22.n = "上海南站"
        let dseconModel1122 = AreaCategorySecondLevelSelectModel()
        dseconModel1122.id = "122"
        dseconModel1122.n = "曹艳骨"
        
        firstModel2.list.append(dseconModel22)
        firstModel2.list.append(dseconModel1122)
        
        categoryModel.c.append(firstModel)
        categoryModel.c.append(firstModel2)
        
        selectModel.areaModel.areaModelCount.append(categoryModel)
        
        
        let categoryModel3 = AreaCategorySelectModel()
        categoryModel3.id = "3"
        categoryModel3.name = "地铁"
        let firstModel3 = AreaCategoryFirstLevelSelectModel()
        firstModel3.id = "113"
        firstModel3.n = "3号线"
        let firstModel23 = AreaCategoryFirstLevelSelectModel()
        firstModel23.id = "312"
        firstModel23.n = "32号线"
        
        let dseconModel3 = AreaCategorySecondLevelSelectModel()
        dseconModel3.id = "3111"
        dseconModel3.n = "3上海站"
        let dseconModel1123 = AreaCategorySecondLevelSelectModel()
        dseconModel1123.id = "3112"
        dseconModel1123.n = "3上海站11"
        
        firstModel3.list.append(dseconModel3)
        firstModel3.list.append(dseconModel1123)
        
        
        let dseconModel223 = AreaCategorySecondLevelSelectModel()
        dseconModel223.id = "3121"
        dseconModel223.n = "3上海南站"
        let dseconModel11223 = AreaCategorySecondLevelSelectModel()
        dseconModel11223.id = "3122"
        dseconModel11223.n = "3曹艳骨"
        
        firstModel23.list.append(dseconModel223)
        firstModel23.list.append(dseconModel11223)
        
        categoryModel3.c.append(firstModel3)
        categoryModel3.c.append(firstModel23)
        
        selectModel.areaModel.areaModelCount.append(categoryModel3)
        
        
        //装修类型数据源模拟
        let documentModel = HouseFeatureModel()
        documentModel.title = "11"
        documentModel.id = "1"
        let documentModel2 = HouseFeatureModel()
        documentModel2.title = "22"
        documentModel2.id = "2"
        let ddocumentModel = HouseFeatureModel()
        ddocumentModel.title = "交通方便"
        ddocumentModel.id = "13"
        let ddocumentModel2 = HouseFeatureModel()
        ddocumentModel2.title = "商圈环绕"
        ddocumentModel2.id = "25"
        selectModel.shaixuanModel.documentTypeModelArr.append(ddocumentModel)
        selectModel.shaixuanModel.documentTypeModelArr.append(ddocumentModel)
        selectModel.shaixuanModel.documentTypeModelArr.append(documentModel)
        selectModel.shaixuanModel.documentTypeModelArr.append(documentModel2)
        
        //房源特色数据源模拟
        let fdocumentModel = HouseFeatureModel()
        fdocumentModel.title = "交通方便"
        fdocumentModel.id = "9"
        let fdocumentModel2 = HouseFeatureModel()
        fdocumentModel2.title = "商圈环绕"
        fdocumentModel2.id = "299"
        selectModel.shaixuanModel.featureModelArr.append(fdocumentModel)
        selectModel.shaixuanModel.featureModelArr.append(fdocumentModel2)
        selectModel.shaixuanModel.featureModelArr.append(fdocumentModel)
        selectModel.shaixuanModel.featureModelArr.append(fdocumentModel2)
        selectModel.shaixuanModel.featureModelArr.append(fdocumentModel)
        selectModel.shaixuanModel.featureModelArr.append(fdocumentModel2)
        selectModel.shaixuanModel.featureModelArr.append(fdocumentModel)
        selectModel.shaixuanModel.featureModelArr.append(fdocumentModel2)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDataModel()
        setupView()
    }
    
    func setupView() {
        titleview = ThorNavigationView.init(type: .homeBackSearchRightBlue)
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .homeSearchRightBlue))
        self.view.bringSubviewToFront(titleview ?? ThorNavigationView.init(type: .homeSearchRightBlue))
        titleview?.leftButtonCallBack = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        titleview?.rightBtnClickBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: false)
        }
        
        //设置筛选条件推荐
        selectView.selectModel = selectModel

        //首页头部 - 筛选操作 - 判断是推荐还是附近 - 然后刷新数据
        selectView.sureButtonButtonCallBack = { [weak self] (_ isNearby: Bool, _ selectModel: HouseSelectModel) -> Void in
            self?.selectModel = selectModel
        }
        self.view.addSubview(selectView)
        self.tableView.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(selectView.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension SearchResultListViewController {
    
}
