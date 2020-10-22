//
//  HouseTypeSelectView.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/29.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

enum HouseShaixuanStyle: String {
    case HouseArea = "区域"
    case HouseType = "类型"
    case HouseSort = "排序"
    case HouseShaixuan = "筛选"
}

class HouseTypeAndSortSelectView: UIView {
    
    lazy var blackAlphabgView: UIButton = {
        let button = UIButton.init()
        button.backgroundColor = kAppAlphaWhite0_alpha_7
        button.addTarget(self, action: #selector(clickRemoveFromSuperview), for: .touchUpInside)
        return button
    }()
    
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: .zero, style: .grouped)
        view.backgroundColor = kAppWhiteColor
        view.separatorStyle = .none
        view.estimatedRowHeight = 40
        return view
    }()
    
    // MARK: - block
    //清除block
    fileprivate var clearButtonCallBack:(() -> Void)?
    
    //选择区域block
    fileprivate var sureHouseAreaButtonCallBack:(() -> Void)?

    //选择类型block
    fileprivate var sureHouseTypeButtonCallBack:((HouseTypeEnum) -> Void)?
    
    //选择排序block
    fileprivate var sureHouseSortButtonCallBack:((HouseSortEnum) -> Void)?
    
    //筛选block
    fileprivate var sureHouseShaixuanButtonCallBack:(() -> Void)?

    var typeSelectEnum: HouseTypeEnum?
    
    var sortSelectEnum: HouseSortEnum?
    
    fileprivate var datasource: [Any] = [] {
        didSet {
            self.tableView.snp.updateConstraints { (make) in
                make.top.leading.trailing.equalToSuperview()
                make.height.equalTo(datasource.count * 40)
            }
            self.tableView.reloadData()
        }
    }
    
    fileprivate var alertStyle: HouseShaixuanStyle?
    
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
    // MARK: - 弹出view显示 - 类型
    func ShowHouseTypeView(style: HouseShaixuanStyle, typeSelectEnum: HouseTypeEnum, datasource: [HouseTypeEnum], clearButtonCallBack: @escaping (() -> Void), sureHouseTypeButtonCallBack: @escaping ((HouseTypeEnum) -> Void)) -> Void {
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
        self.sureHouseTypeButtonCallBack = sureHouseTypeButtonCallBack
        self.datasource = datasource
        self.alertStyle = style
        self.typeSelectEnum = typeSelectEnum
        UIApplication.shared.keyWindow?.addSubview(self)
        
    }
    
    // MARK: - 弹出view显示 - 排序
    func ShowHouseSortView(style: HouseShaixuanStyle, sortSelectEnum: HouseSortEnum,  datasource: [HouseSortEnum], clearButtonCallBack: @escaping (() -> Void), sureHouseSortButtonCallBack: @escaping ((HouseSortEnum) -> Void)) -> Void {
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
        self.sureHouseSortButtonCallBack = sureHouseSortButtonCallBack
        self.datasource = datasource
        self.alertStyle = style
        self.sortSelectEnum = sortSelectEnum
        UIApplication.shared.keyWindow?.addSubview(self)
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setUpSubviews()
    }
    
    func setUpSubviews() {
        self.addSubview(blackAlphabgView)
        self.addSubview(tableView)
        blackAlphabgView.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        tableView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(datasource.count * 40)
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TypeAndSortCell.self, forCellReuseIdentifier: TypeAndSortCell.reuseIdentifierStr)
    }
    
}

extension HouseTypeAndSortSelectView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TypeAndSortCell.reuseIdentifierStr) as? TypeAndSortCell
        cell?.selectionStyle = .none
        if self.datasource.count > 0 {
            let model = self.datasource[indexPath.row]
            if self.alertStyle == HouseShaixuanStyle.HouseType {
                cell?.titleLabel.text = (model as? HouseTypeEnum)?.rawValue

                if model as? HouseTypeEnum == typeSelectEnum {
                    cell?.titleLabel.textColor = kAppBlueColor
                }else {
                    cell?.titleLabel.textColor = kAppColor_333333
                }

            }else if self.alertStyle == HouseShaixuanStyle.HouseSort {
                cell?.titleLabel.text = (model as? HouseSortEnum)?.rawValue
                
                if model as? HouseSortEnum == sortSelectEnum {
                    cell?.titleLabel.textColor = kAppBlueColor
                }else {
                    cell?.titleLabel.textColor = kAppColor_333333
                }
            }
        }
        return cell ?? TypeAndSortCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.alertStyle == HouseShaixuanStyle.HouseType {
            guard let blockk = sureHouseTypeButtonCallBack else {
                return
            }
            blockk(datasource[indexPath.row] as? HouseTypeEnum ?? HouseTypeEnum.officeBuildingEnum)
            selfRemove()
        }else if self.alertStyle == HouseShaixuanStyle.HouseSort {
            guard let blockk = sureHouseSortButtonCallBack else {
                return
            }
            blockk(datasource[indexPath.row] as? HouseSortEnum ?? HouseSortEnum.defaultSortEnum)
            selfRemove()
        }
        
    }
}


class TypeAndSortCell: BaseTableViewCell {
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.numberOfLines = 0
        view.font = FONT_LIGHT_13
        
        view.textColor = kAppColor_333333
        return view
    }()
    
    lazy var itemNumView: UILabel = {
        let view = UILabel()
        view.isHidden = true
        view.textAlignment = .center
        view.font = FONT_MEDIUM_10
        view.textColor = kAppWhiteColor
        view.backgroundColor = kAppBlueColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 7
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

        self.backgroundColor = kAppWhiteColor
          self.addSubview(titleLabel)
        titleLabel.snp.updateConstraints { (make) in
           make.centerX.centerY.equalToSuperview()
       }
        self.addSubview(itemNumView)
         itemNumView.snp.updateConstraints { (make) in
            make.top.equalTo(titleLabel.snp.top).offset(-7)
            make.height.equalTo(14)
            make.width.greaterThanOrEqualTo(14)
            make.leading.equalTo(titleLabel.snp.trailing)
        }

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
