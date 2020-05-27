//
//  AreaAddressView.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/30.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit


class AreaAddressView: UIView {
    
    var categoryLevelModel = AreaCategorySelectModel()
    //    {
    //        didSet {
    //            firstLevelTableView.reloadData()
    ////            firstLevelIndex = 0
    //            firstLevelModel = categoryLevelModel.c[firstLevelIndex]
    ////            secondLevelModel = firstLevelModel.list[secondLevelIndex]
    //
    //        }
    //    }
    
    var firstLevelModel = AreaCategoryFirstLevelSelectModel()
    //    {
    //        didSet {
    //            secondLevelTableView.reloadData()
    ////            secondLevelIndex = 0
    //            secondLevelModel = firstLevelModel.list[secondLevelIndex]
    //
    //        }
    //    }
//    var secondLevelModel = AreaCategorySecondLevelSelectModel()
    //    {
    //        didSet {
    //        }
    //    }
    var categoryIndex: Int = 2
    //    {
    //        didSet {
    //            categoryLevelModel = areaRegionModel.areaModelCount[categoryIndex]
    //        }
    //    }
    
    var firstLevelIndex: Int = 0
    //    {
    //        didSet {
    //            firstLevelModel = categoryLevelModel.c[firstLevelIndex]
    //        }
    //    }
    
    var secondLevelIndex: Int = 0
    //    {
    //        didSet {
    //            secondLevelModel = firstLevelModel.list[secondLevelIndex]
    //        }
    //    }
    
    //数据结构
    var areaRegionModel: AreaModel = AreaModel()
    //    {
    //        didSet {
    //            categoryIndex = 0
    //            firstLevelIndex = 0
    //            secondLevelIndex = 0
    //        }
    //    }
    
    lazy var blackAlphabgView: UIButton = {
        let button = UIButton.init()
        button.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
        button.addTarget(self, action: #selector(clickRemoveFromSuperview), for: .touchUpInside)
        return button
    }()
    
    lazy var categoryTableview: UITableView = {
        let view = UITableView.init(frame: .zero, style: .grouped)
        view.backgroundColor = kAppColor_bgcolor_F7F7F7
        view.separatorStyle = .none
        view.dataSource = self
        view.delegate = self
        view.estimatedRowHeight = 40
        view.tag = 1
        view.register(TypeAndSortCell.self, forCellReuseIdentifier: TypeAndSortCell.reuseIdentifierStr)
        return view
    }()
    
    lazy var firstLevelTableView: UITableView = {
        let view = UITableView.init(frame: .zero, style: .grouped)
        view.backgroundColor = kAppWhiteColor
        view.separatorStyle = .none
        view.dataSource = self
        view.delegate = self
        view.estimatedRowHeight = 40
        view.tag = 2
        view.register(TypeAndSortCell.self, forCellReuseIdentifier: TypeAndSortCell.reuseIdentifierStr)
        return view
    }()
    
    lazy var secondLevelTableView: UITableView = {
        let view = UITableView.init(frame: .zero, style: .grouped)
        view.backgroundColor = kAppWhiteColor
        view.separatorStyle = .none
        view.dataSource = self
        view.delegate = self
        view.estimatedRowHeight = 40
        view.tag = 3
        view.register(AreaSubwayMutileSelectCell.self, forCellReuseIdentifier: AreaSubwayMutileSelectCell.reuseIdentifierStr)
        return view
    }()
    
    lazy var bottomBtnView: BottomBtnView = {
        let view = BottomBtnView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: 50))
        view.bottomType = BottomBtnViewType.BottomBtnViewTypeShaixuan
        view.backgroundColor = kAppWhiteColor
        return view
    }()
    
    // MARK: - block
    //清除block
    var clearButtonCallBack:(() -> Void)?
    
    //筛选block
    var sureAreaaddressButtonCallBack:((HouseSelectModel) -> Void)?
    
    @objc func clickRemoveFromSuperview() {
        guard let blockk = clearButtonCallBack else {
            return
        }
        blockk()
        selfRemove()
    }
    
    func selfRemove() {
        self.removeFromSuperview()
    }
    
    // MARK: - 弹出view显示
    // MARK: - 弹出view显示 - 筛选
    func ShowAreaaddressView(model: HouseSelectModel, clearButtonCallBack: @escaping (() -> Void), sureAreaaddressButtonCallBack: @escaping ((HouseSelectModel) -> Void)) -> Void {
        
        UIApplication.shared.keyWindow?.subviews.forEach({ (view) in
            if view.isKind(of: AreaAddressView.self) {
                view.removeFromSuperview()
            }
            if view.isKind(of: HouseTypeAndSortSelectView.self) {
                view.removeFromSuperview()
            }
            if view.isKind(of: HouseShaixuanSelectView.self) {
                view.removeFromSuperview()
            }
        })
        self.frame = CGRect(x: 0.0, y: kNavigationHeight + 60, width: kWidth, height: kHeight - kNavigationHeight - 60)
        
        self.clearButtonCallBack = clearButtonCallBack
        self.sureAreaaddressButtonCallBack = sureAreaaddressButtonCallBack
        self.areaRegionModel = model.areaModel
        
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.frame = frame
        
        setUpSubviews()
    }
    
    func setUpSubviews() {
        self.addSubview(blackAlphabgView)
        self.addSubview(categoryTableview)
        self.addSubview(firstLevelTableView)
        self.addSubview(secondLevelTableView)
        self.addSubview(bottomBtnView)
        blackAlphabgView.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        
        bottomBtnView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-kTabBarHeight)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        categoryTableview.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview()
            make.bottom.equalTo(bottomBtnView.snp.top)
            make.width.equalTo(1 / 4.0 * kWidth)
        }
        
        firstLevelTableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalTo(1 / 4.0 * kWidth)
            make.bottom.equalTo(categoryTableview.snp.bottom)
            make.width.equalTo(9 / 32.0 * kWidth)
        }
        
        secondLevelTableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalTo(1 / 4.0 * kWidth + 9 / 32.0 * kWidth)
            make.bottom.equalTo(categoryTableview.snp.bottom)
            make.trailing.equalToSuperview()
        }
        
    }
    
}

extension AreaAddressView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return areaRegionModel.areaModelCount.count
        }else if tableView.tag == 2 {
            return categoryLevelModel.c.count
        }else  {
            return firstLevelModel.list.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TypeAndSortCell.reuseIdentifierStr) as? TypeAndSortCell
            cell?.selectionStyle = .none
            cell?.backgroundColor = kAppClearColor
            cell?.titleLabel.backgroundColor = kAppClearColor
            if self.areaRegionModel.areaModelCount.count > 0 {
                
                 cell?.titleLabel.text = areaRegionModel.areaModelCount[indexPath.row].name

                if categoryLevelModel.id ==  areaRegionModel.areaModelCount[indexPath.row].id{
                    var selNum = 0
                    for model in firstLevelModel.list {
                        if model.isSelected ?? false {
                            selNum += 1
                        }
                    }
                    if selNum > 0 {
                        cell?.itemNumView.isHidden = false
                        cell?.itemNumView.text = "\(selNum)"
                    }else {
                        cell?.itemNumView.isHidden = true
                    }
                    cell?.titleLabel.textColor = kAppBlueColor
                    
                }else {
                    cell?.itemNumView.isHidden = true
                    cell?.titleLabel.textColor = kAppColor_333333
                }
            }
            
            return cell ?? TypeAndSortCell()
        }else if tableView.tag == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TypeAndSortCell.reuseIdentifierStr) as? TypeAndSortCell
            cell?.selectionStyle = .none
            if self.categoryLevelModel.c.count > 0 {
                cell?.titleLabel.text = categoryLevelModel.c[indexPath.row].n
                if firstLevelModel.id ==  categoryLevelModel.c[indexPath.row].id{
                    cell?.titleLabel.textColor = kAppBlueColor
                }else {
                    cell?.titleLabel.textColor = kAppColor_333333
                }
            }
            return cell ?? TypeAndSortCell()
        }else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: AreaSubwayMutileSelectCell.reuseIdentifierStr) as? AreaSubwayMutileSelectCell
            cell?.selectionStyle = .none
            if self.firstLevelModel.list.count > indexPath.row {
                cell?.layoutSubviews()
                let model = firstLevelModel.list[indexPath.row]
                cell?.titleLabel.text = model.n
                
                if model.isSelected == true {
                    cell?.titleLabel.textColor = kAppBlueColor
                    cell?.itemImg.image = UIImage.init(named: "circleSelected")
                }else {
                    cell?.titleLabel.textColor = kAppColor_333333
                    cell?.itemImg.image = UIImage.init(named: "circleUnSelected")
                }
            }
            return cell ?? AreaSubwayMutileSelectCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1 {
            //            if categoryIndex ==  indexPath.row{
            //                return
            //            }
            categoryIndex = indexPath.row
            categoryLevelModel = areaRegionModel.areaModelCount[indexPath.row]
            firstLevelModel = AreaCategoryFirstLevelSelectModel()
            categoryTableview.reloadData()
            firstLevelTableView.reloadData()
            secondLevelTableView.reloadData()
        }else if tableView.tag == 2 {
            //            if firstLevelIndex ==  indexPath.row{
            //                return
            //            }
            firstLevelIndex =  indexPath.row
            firstLevelModel = categoryLevelModel.c[indexPath.row]
            for model in firstLevelModel.list {
                model.isSelected = false
            }
            categoryTableview.reloadData()
            firstLevelTableView.reloadData()
            secondLevelTableView.reloadData()
        }else  {
            secondLevelIndex = indexPath.row
            firstLevelModel.list[indexPath.row].isSelected = !(firstLevelModel.list[indexPath.row].isSelected ?? false)
            categoryTableview.reloadData()
            secondLevelTableView.reloadData()
        }
    }
}

class AreaSubwayMutileSelectCell: BaseTableViewCell {
    
    lazy var itemImg: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.numberOfLines = 0
        view.font = FONT_LIGHT_13
        
        view.textColor = kAppColor_333333
        return view
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(itemImg)
        self.addSubview(titleLabel)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        itemImg.frame = CGRect(x: 20, y: (self.height - 14) / 2.0, width: 14, height: 14)
        titleLabel.frame = CGRect(x: itemImg.right + 12, y: 0, width: self.width - itemImg.right - 12, height: self.height)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
