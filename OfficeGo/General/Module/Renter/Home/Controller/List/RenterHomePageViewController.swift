//
//  RenterHomePageViewController.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/8.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

class RenterHomePageViewController: LLSegmentViewController, CycleViewDelegate, LLSegmentedControlDelegate {
    
    //推荐房源搜索model
    var recommendSelectModel: HouseSelectModel = HouseSelectModel() {
        didSet {
            
            NotificationCenter.default.post(name: NSNotification.Name.HomeSelectRefresh, object: recommendSelectModel)
        }
    }
    /*
     //附件房源搜索model
     var nearbySelectModel: HouseSelectModel = HouseSelectModel() {
     didSet {
     //            self.tableView.reloadData()
     }
     }*/
    
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
        let tab = self.navigationController?.tabBarController as? RenterMainTabBarController
        tab?.customTabBar.isHidden = true
        
        segmentTitleSelectview.selectView.removeShowView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SSLog(kWidth)
        SSLog(kHeight)
        SSLog((UIDevice.current.systemVersion as NSString).doubleValue)
        
        let tab = self.navigationController?.tabBarController as? RenterMainTabBarController
        tab?.customTabBar.isHidden = false
        
        if self.cycleView?.imageURLStringArr.count ?? 0 <= 0 {
            request_bannerlist()
        }
        
        requestVersionUpdate()
    }
    
    ///版本更新判断
    func requestVersionUpdate() {
        
        SSNetworkTool.SSVersion.request_version(success: { [weak self] (response) in
            
            if let model = VersionModel.deserialize(from: response, designatedPath: "data") {
                self?.showUpdateAlertview(versionModel: model)
            }
            }, failure: { (error) in
                
        }) {(code, message) in
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
            
        }
        
    }
    
    //弹出版本更新弹框
    func showUpdateAlertview(versionModel: VersionModel) {
        
        if UserTool.shared.isCloseCancelVersionUpdate == true {
            return
        }
        
        let alert = SureAlertView(frame: self.view.frame)
        alert.isHiddenVersionCancel = versionModel.force ?? false
        alert.ShowAlertView(withalertType: AlertType.AlertTypeVersionUpdate, title: "版本更新", descMsg: versionModel.desc ?? "", cancelButtonCallClick: {
            UserTool.shared.isCloseCancelVersionUpdate = true
        }) {
            UserTool.shared.isCloseCancelVersionUpdate = true
            if let url = URL(string: versionModel.uploadUrl ?? "") {
                if UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler:nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        }
    }
    
    func setDataModel() {
        
        request_getDistrict()
        
        requestGetFeature()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeAutomaticallyAdjusts()
        
        request_bannerlist()
        
        //模拟数据 - 推荐和附近 - 不同的数据
        setDataModel()
        
        //首页头部view - 标题栏搜索 - 跳转搜索
        segmentTitleSelectview.titleView.rightBtnClickBlock = { [weak self] in
            
            //移除筛选弹框
            self?.segmentTitleSelectview.selectView.removeShowView()
            
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
            
            //更新选中下面的滑动和点击view
            self?.segmentCtlView.selected(at: index - 1, animation: true)
            
            if index == 1 {
                //推荐
                self?.segmentTitleSelectview.selectView.hiddenArea = false
                self?.segmentTitleSelectview.selectView.selectModel = self?.recommendSelectModel
            }else if index == 2 {
                /*
                 //附近
                 self?.segmentTitleSelectview.selectView.hiddenArea = true
                 self?.segmentTitleSelectview.selectView.selectModel = self?.nearbySelectModel
                 */
            }
            SSLog("--------index --********---\(index)")
        }
        
        //首页头部 - 筛选操作 - 判断是推荐还是附近 - 然后刷新数据
        segmentTitleSelectview.selectView.sureButtonButtonCallBack = { [weak self] (_ isNearby: Bool, _ selectModel: HouseSelectModel) -> Void in
            self?.recommendSelectModel = selectModel
            /*if isNearby == true {
             self?.nearbySelectModel = selectModel
             }else {
             self?.recommendSelectModel = selectModel
             }*/
        }
        
        self.view.addSubview(segmentTitleSelectview)
        //        segmentTitleSelectview.isHidden = true
        segmentTitleSelectview.alpha = 0
        self.view.bringSubviewToFront(segmentTitleSelectview)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.HomeBtnLocked, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            
            SSLog("-----``````----------****\(self?.containerScrView.contentOffset.y ?? 0)")
            
            if self?.containerScrView.contentOffset.y ?? 0 > -(60 + kStatusBarHeight) {
                self?.segmentTitleSelectview.alpha = 1
            } else if self?.containerScrView.contentOffset.y ?? 0 > -(60 + kStatusBarHeight + 180){
                
                //y = k * x + b
                let k: CGFloat = 1 / 180.0
                let b: CGFloat = 1 / 180.0 * (60 + kStatusBarHeight) + 1
                let alpha = k * (self?.containerScrView.contentOffset.y ?? 0.0) + b
                self?.segmentTitleSelectview.alpha = alpha
                SSLog("*******************---****\(alpha)")
                
            }
            else {
                self?.segmentTitleSelectview.alpha = 0
            }
            
            if self?.containerScrView.contentOffset.y ?? 0 > -(60 + kStatusBarHeight + 150){
                
                self?.titleview?.isHidden = true
            }
            else {
                self?.titleview?.isHidden = false
            }
        }
        
        
        
        titleview = ThorNavigationView.init(type: .locationSearchClear)
        titleview?.locationBtn.layoutButton(.imagePositionLeft, margin: 10)
        titleview?.rightBtnClickBlock = { [weak self] in
            //移除筛选弹框
            self?.segmentTitleSelectview.selectView.removeShowView()
            
            let vc = BaseNavigationViewController.init(rootViewController: RenterSearchViewController())
            vc.navigationBar.isHidden = true
            vc.modalPresentationStyle = .overFullScreen
            self?.present(vc, animated: true, completion: nil)
        }
        titleview?.locationBtn.setTitle("  上海", for: .normal)
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .locationSearchClear))
        self.view.bringSubviewToFront(titleview ?? ThorNavigationView.init(type: .locationSearchClear))
        titleview?.leftButtonCallBack = { [weak self] in
            self?.shareVc()
        }
        
        let pointY: CGFloat = 0
        cycleView = CycleView(frame: CGRect(x: 0, y: pointY, width: kWidth, height: (CGFloat)(ceilf((Float)(kWidth * 240.0 / 320.0)))))
        cycleView?.delegate = self
        cycleView?.mode = .scaleAspectFill
        
        //cycleView?.addSubview(titleview ?? ThorNavigationView.init(type: .locationSearchClear))
        
        loadSegmentedConfig()
        
        //        requestGetBuildingList()
    }
    
    
    func shareVc() {
        
    }
}

//MARK: 接口处理
extension RenterHomePageViewController {
    
    //MARK: 获取商圈数据
    func request_getDistrict() {
        //查询类型，1：全部，0：系统已有楼盘的商圈
        var params = [String:AnyObject]()
        params["type"] = 1 as AnyObject?
        SSNetworkTool.SSBasic.request_getDistrictList(params: params, success: { [weak self] (response) in
            if let model = AreaCategorySelectModel.deserialize(from: response) {
                model.name = "商圈"
                self?.recommendSelectModel.areaModel.areaModelCount = model
            }
            self?.request_getSubwaylist()
            }, failure: { [weak self] (error) in
                self?.request_getSubwaylist()
        }) { [weak self] (code, message) in
            
            self?.request_getSubwaylist()
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    //MARK: 获取地铁数据
    func request_getSubwaylist() {
        //查询类型，1：全部，0：系统已有楼盘的商圈
        var params = [String:AnyObject]()
        params["type"] = 1 as AnyObject?
        SSNetworkTool.SSBasic.request_getSubwayList(params: params, success: { [weak self] (response) in
            if let model = SubwayCategorySelectModel.deserialize(from: response) {
                model.name = "地铁"
                self?.recommendSelectModel.areaModel.subwayModelCount = model
            }
            
            }, failure: { (error) in
                
        }) { (code, message) in
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    //MARK: 获取装修类型
    func requestGetDecorate() {
        
        SSNetworkTool.SSBasic.request_getDictionary(code: .codeEnumdecoratedType, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<HouseFeatureModel>.deserializeModelArrayFrom(json: JSON(response).rawString() ?? "", designatedPath: "data") {
                for model in decoratedArray {
                    weakSelf.recommendSelectModel.shaixuanModel.documentTypeModelArr.append(model ?? HouseFeatureModel())
                    /*weakSelf.nearbySelectModel.shaixuanModel.documentTypeModelArr.append(model ?? HouseFeatureModel())*/
                }
            }
            
            }, failure: {(error) in
                
        }) {(code, message) in
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    //MARK: 获取特色接口
    func requestGetFeature() {
        
        SSNetworkTool.SSBasic.request_getDictionary(code: .codeEnumbranchUnique, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<HouseFeatureModel>.deserializeModelArrayFrom(json: JSON(response).rawString() ?? "", designatedPath: "data") {
                for model in decoratedArray {
                    weakSelf.recommendSelectModel.shaixuanModel.featureModelArr.append(model ?? HouseFeatureModel())
                    /*weakSelf.nearbySelectModel.shaixuanModel.featureModelArr.append(model ?? HouseFeatureModel())*/
                }
            }
            weakSelf.requestGetDecorate()
            
            }, failure: {[weak self] (error) in
                self?.requestGetDecorate()
        }) {[weak self] (code, message) in
            self?.requestGetDecorate()
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    //MARK: 轮播图
    func request_bannerlist() {
        SSNetworkTool.SSHome.request_getbannerListt(success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<BannerModel>.deserializeModelArrayFrom(json: JSON(response).rawString() ?? "", designatedPath: "data") {
                
                var arr: [String] = []
                for model in decoratedArray {
                    arr.append(model?.img ?? "")
                }
                
                //                weakSelf.setCycleImg()
                weakSelf.cycleView?.imageURLStringArr = arr
                
            }
            
            }, failure: { (error) in
                
        }) { (code, message) in
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    func setCycleImg() {
        SSTool.invokeInMainThread { [weak self] in
            self?.cycleView?.imageURLStringArr = ["bannerBgView"]
            
            
            //            self?.cycleView?.imageURLStringArr = ["https://img.officego.com/building/1592531586982.jpg?x-oss-process=style/large"]
            //                weakSelf.cycleView?.imageURLStringArr = arr
        }
        
    }
}


//MARK: LLSegmentedControlDelegate
extension RenterHomePageViewController {
    //设置自己上面的按钮状态
    /*******滚动ContentView*****/
    func segMegmentCtlView(segMegmentCtlView: LLSegmentedControl, dragToSelected itemView: LLSegmentBaseItemView) {
        segmentTitleSelectview.titleView.segHead?.selectedIndex = itemView.index + 1
    }
    /********点击ItemView*****/
    func segMegmentCtlView(segMegmentCtlView: LLSegmentedControl, clickItemAt sourceItemView: LLSegmentBaseItemView, to destinationItemView: LLSegmentBaseItemView) {
        segmentTitleSelectview.titleView.segHead?.selectedIndex = destinationItemView.index + 1
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
        ///首页列表滑动显示问题 - 
        //        closeAutomaticallyAdjusts()
    }
    
    func layoutContentView() {
        
        self.layoutInfo.refreshType = .list
        
        self.layoutInfo.headView = cycleView
        
        self.layoutInfo.segmentControlPositionType = .top(size: CGSize.init(width: UIScreen.main.bounds.width, height: 44), offset: 0)
        self.relayoutSubViews()
    }
    
    func loadCtls() {
        let introCtl = RenterFangYuanListViewController()
        introCtl.title = "推荐房源"
        
        /* 暂时隐藏附近房源
         let catalogCtl = RenterFangYuanListViewController()
         catalogCtl.title = "附近房源"
         let ctls =  [introCtl,catalogCtl]
         */
        
        let ctls =  [introCtl]
        reloadViewControllers(ctls:ctls)
    }
    
    func setUpSegmentStyle() {
        itemStyle = LLSegmentItemTitleViewStyle()
        itemStyle?.selectedColor = kAppColor_333333
        itemStyle?.unSelectedColor = kAppColor_666666
        itemStyle?.selectedTitleScale = 1.2
        itemStyle?.titleFontSize = 14
        itemStyle?.itemWidth = 100 //如果不指定是自动适配的
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
        segmentCtlView.delegate = self
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

