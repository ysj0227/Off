//
//  RenterHomePageViewController.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/8.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterHomePageViewController: LLSegmentViewController, CycleViewDelegate {
    
    //推荐房源搜索model
    var recommendSelectModel: HouseSelectModel = HouseSelectModel() {
       didSet {
//            self.tableView.reloadData()
       }
   }
    
    //附件房源搜索model
     var nearbySelectModel: HouseSelectModel = HouseSelectModel() {
        didSet {
//            self.tableView.reloadData()
        }
    }
    
    var titleview: ThorNavigationView?
    
    var itemStyle: LLSegmentItemTitleViewStyle?
    
    var segmentedCtlStyle: LLSegmentedControlStyle?
    
    var cycleView:CycleView?
    
    var segmentTitleSelectview: HomeSegmentSelectView = {
        let view = HomeSegmentSelectView(frame: CGRect(x: 0, y: 0, width: kWidth, height: kNavigationHeight + 58))
        return view
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tab = self.navigationController?.tabBarController as? MainTabBarController
        tab?.customTabBar.isHidden = true
        
        segmentTitleSelectview.selectView.removeShowView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tab = self.navigationController?.tabBarController as? MainTabBarController
        tab?.customTabBar.isHidden = false
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
        
        recommendSelectModel.areaModel.areaModelCount.append(categoryModel)
        
        
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
        
        recommendSelectModel.areaModel.areaModelCount.append(categoryModel3)
        
        
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
        recommendSelectModel.shaixuanModel.documentTypeModelArr.append(ddocumentModel)
        recommendSelectModel.shaixuanModel.documentTypeModelArr.append(ddocumentModel)
        recommendSelectModel.shaixuanModel.documentTypeModelArr.append(documentModel)
        recommendSelectModel.shaixuanModel.documentTypeModelArr.append(documentModel2)
        
        nearbySelectModel.shaixuanModel.documentTypeModelArr.append(ddocumentModel)
        nearbySelectModel.shaixuanModel.documentTypeModelArr.append(ddocumentModel)
        nearbySelectModel.shaixuanModel.documentTypeModelArr.append(documentModel)
        nearbySelectModel.shaixuanModel.documentTypeModelArr.append(documentModel2)
        
        //房源特色数据源模拟
        let fdocumentModel = HouseFeatureModel()
        fdocumentModel.title = "交通方便"
        fdocumentModel.id = "9"
        let fdocumentModel2 = HouseFeatureModel()
        fdocumentModel2.title = "商圈环绕"
        fdocumentModel2.id = "299"
        recommendSelectModel.shaixuanModel.featureModelArr.append(fdocumentModel)
        recommendSelectModel.shaixuanModel.featureModelArr.append(fdocumentModel2)
        recommendSelectModel.shaixuanModel.featureModelArr.append(fdocumentModel)
        recommendSelectModel.shaixuanModel.featureModelArr.append(fdocumentModel2)
        recommendSelectModel.shaixuanModel.featureModelArr.append(fdocumentModel)
        recommendSelectModel.shaixuanModel.featureModelArr.append(fdocumentModel2)
        recommendSelectModel.shaixuanModel.featureModelArr.append(fdocumentModel)
        recommendSelectModel.shaixuanModel.featureModelArr.append(fdocumentModel2)
        
        nearbySelectModel.shaixuanModel.featureModelArr.append(fdocumentModel)
        nearbySelectModel.shaixuanModel.featureModelArr.append(fdocumentModel2)
        nearbySelectModel.shaixuanModel.featureModelArr.append(fdocumentModel)
        nearbySelectModel.shaixuanModel.featureModelArr.append(fdocumentModel2)
        nearbySelectModel.shaixuanModel.featureModelArr.append(fdocumentModel)
        nearbySelectModel.shaixuanModel.featureModelArr.append(fdocumentModel2)
        nearbySelectModel.shaixuanModel.featureModelArr.append(fdocumentModel)
        nearbySelectModel.shaixuanModel.featureModelArr.append(fdocumentModel2)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        //模拟数据 - 推荐和附近 - 不同的数据
        setDataModel()
        
        //首页头部view - 标题栏搜索 - 跳转搜索
        segmentTitleSelectview.titleView.rightBtnClickBlock = { [weak self] in
            
            let vc = BaseNavigationViewController.init(rootViewController: RenterSearchViewController())
            vc.navigationBar.isHidden = true
            vc.modalPresentationStyle = .overFullScreen
            self?.present(vc, animated: true, completion: nil)
        }
        
        //默认推荐
        segmentTitleSelectview.selectView.selectModel = recommendSelectModel

        
        //切换下面的筛选条件
        segmentTitleSelectview.titleView.segHead?.buttonCallBack = {[weak self] (index) in
            
            //点击切换 移除
            self?.segmentTitleSelectview.selectView.removeShowView()
            
            self?.pageView.reloadCurrentIndex(index: index - 1)
//            delegate?.segMegmentCtlView?(segMegmentCtlView: self, dragToScroll: leftItemView, rightItemView: rightItemView)

            if index == 1 {
                //推荐
                self?.segmentTitleSelectview.selectView.hiddenArea = false
                self?.segmentTitleSelectview.selectView.selectModel = self?.recommendSelectModel
            }else if index == 2 {
                //附近
                self?.segmentTitleSelectview.selectView.hiddenArea = true
                self?.segmentTitleSelectview.selectView.selectModel = self?.nearbySelectModel
                
            }
            print("--------index --********---\(index)")
        }
        
        //首页头部 - 筛选操作 - 判断是推荐还是附近 - 然后刷新数据
        segmentTitleSelectview.selectView.sureButtonButtonCallBack = { [weak self] (_ isNearby: Bool, _ selectModel: HouseSelectModel) -> Void in
            if isNearby == true {
                self?.nearbySelectModel = selectModel
            }else {
                self?.recommendSelectModel = selectModel
            }
        }
        
        self.view.addSubview(segmentTitleSelectview)
        segmentTitleSelectview.isHidden = true
        self.view.bringSubviewToFront(segmentTitleSelectview)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.HomeBtnLocked, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
                        
            print("-----``````----------****\(self?.containerScrView.contentOffset.y ?? 0)")

            if self?.containerScrView.contentOffset.y ?? 0 > -(60 + kStatusBarHeight) {
               self?.titleview?.isHidden = true
               self?.segmentTitleSelectview.isHidden = false
           }else {
               self?.titleview?.isHidden = false
               self?.segmentTitleSelectview.isHidden = true
           }
        }
        
        
        
        titleview = ThorNavigationView.init(type: .locationSearchClear)
        titleview?.locationBtn.layoutButton(.imagePositionLeft, margin: 10)

        titleview?.locationBtn.setTitle("  上海", for: .normal)
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .locationSearchClear))
        self.view.bringSubviewToFront(titleview ?? ThorNavigationView.init(type: .locationSearchClear))
        titleview?.leftButtonCallBack = { [weak self] in
            self?.shareVc()
        }
        
        //轮播图加载
        let pointY: CGFloat = 0
        cycleView = CycleView(frame: CGRect(x: 0, y: pointY, width: kWidth, height: kWidth * 267 / 320.0))
        cycleView?.delegate = self
        cycleView?.mode = .scaleAspectFill
        //本地图片测试--加载网络图片,请用第三方库如SDWebImage等
        cycleView?.imageURLStringArr = ["loginBgImg", "wechat", "loginBgImg", "wechat"]
        
        loadSegmentedConfig()
    }
    
    
    func shareVc() {
        let shareVC = ShareViewController.initialization()
        shareVC.isPosterShare = true
        shareVC.modalPresentationStyle = .overFullScreen
        self.present(shareVC, animated: true, completion: {})
    }
}

//MARK: CycleViewDelegate
extension RenterHomePageViewController {
    func cycleViewDidSelectedItemAtIndex(_ index: NSInteger) {
        
    }
}


extension RenterHomePageViewController{
    func loadSegmentedConfig() {
        layoutContentView()
        loadCtls()
        setUpSegmentStyle()
    }
    
    func layoutContentView() {
        self.layoutInfo.refreshType = .list
        self.layoutInfo.headView = cycleView
        self.layoutInfo.segmentControlPositionType = .top(size: CGSize.init(width: UIScreen.main.bounds.width, height: 44), offset: 0)
        self.relayoutSubViews()
    }
    
    func loadCtls() {
        let introCtl = FangYuanListViewController()
        introCtl.title = "推荐房源"
        
        let catalogCtl = FangYuanListViewController()
        catalogCtl.title = "附近房源"
        
        let ctls =  [introCtl,catalogCtl]
        reloadViewControllers(ctls:ctls)
    }
    
    func setUpSegmentStyle() {
        itemStyle = LLSegmentItemTitleViewStyle()
        itemStyle?.selectedColor = kAppColor_333333
        itemStyle?.unSelectedColor = kAppColor_666666
        itemStyle?.selectedTitleScale = 1.2
        itemStyle?.titleFontSize = 12
        itemStyle?.itemWidth = 70 //如果不指定是自动适配的
        //这里可以继续增加itemStyle的其他配置项... ...
        
        segmentCtlView.backgroundColor = UIColor.white
        segmentCtlView.separatorLineShowEnabled = false //间隔线显示，默认不显示
        //还有其他配置项：颜色、宽度、上下的间隔...
        
        //    segmentCtlView.bottomSeparatorStyle = (1,UIColor.red) //分割线:默认透明色
        segmentCtlView.indicatorView.widthChangeStyle = .stationary(baseWidth: 0)//横杆宽度:有默认值
        segmentCtlView.indicatorView.centerYGradientStyle = .bottom(margin: 0)//横杆位置:有默认值
        segmentCtlView.indicatorView.shapeStyle = .custom //形状样式:有默认值
        
        segmentedCtlStyle = LLSegmentedControlStyle()
        segmentedCtlStyle?.segmentItemViewClass = LLSegmentItemTitleView.self  //ItemView和ItemViewStyle要统一对应
        segmentedCtlStyle?.itemViewStyle = itemStyle ?? LLSegmentItemTitleViewStyle()
        segmentCtlView.reloadData(ctlViewStyle: segmentedCtlStyle)
    }
}


//首页上面切换titleview和下面的筛选选择按钮
class HomeSegmentSelectView: UIView {
    
    var titleView: ThorNavigationView = {
        var view = ThorNavigationView.init(type: .homeTitleViewSearchBtn)
        return view
    }()
    
    var selectView: HouseSelectBtnView = {
        let view = HouseSelectBtnView.init(frame: CGRect(x: 0, y: kNavigationHeight, width: kWidth, height: 60))
        //   selectView?.selectModel = self.selectModel
        return view
    }()
    
    public override required init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        
        self.addSubview(titleView)
        self.addSubview(selectView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

