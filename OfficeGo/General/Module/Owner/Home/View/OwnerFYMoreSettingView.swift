//
//  OwnerFYMoreSettingView.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/9/28.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerFYMoreSettingView: UIView {
    
    var titleString: String?
    
    lazy var blackAlphabgView: UIButton = {
        let button = UIButton.init()
        button.backgroundColor = kAppAlphaWhite0_alpha_7
        button.addTarget(self, action: #selector(clickRemoveFromSuperview), for: .touchUpInside)
        return button
    }()
    
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: .zero, style: .plain)
        view.backgroundColor = kAppWhiteColor
        view.separatorStyle = .none
        view.estimatedRowHeight = 40
        return view
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppWhiteColor
        return view
    }()
    
    // MARK: - block
    //清除block
    fileprivate var clearButtonCallBack:(() -> Void)?
    
    //选择排序block
    fileprivate var sureHouseSortButtonCallBack:((Int) -> Void)?
    
    //房源列表更多
    fileprivate var sureOwnerFYMoreCallBack:((OWnerFYMoreSettingEnum) -> Void)?
    
    fileprivate var datasource: [Any] = [] {
        didSet {
            //            tableView.snp.remakeConstraints { (make) in
            //                make.bottom.leading.trailing.equalToSuperview()
            //                make.height.equalTo(datasource.count * 40 + 53 + 80)
            //            }
            if CGFloat(datasource.count * 40 + 133) > (kHeight / 2.0) {
                tableView.isScrollEnabled = true
                tableView.snp.remakeConstraints { (make) in
                    make.bottom.equalToSuperview().offset(-bottomMargin())
                    make.leading.trailing.equalToSuperview()
                    make.height.equalTo(kHeight / 2.0)
                }
            }else {
                let height = CGFloat(datasource.count * 40 + 53 + 80)
                tableView.snp.remakeConstraints { (make) in
                    make.bottom.equalToSuperview().offset(-bottomMargin())
                    make.leading.trailing.equalToSuperview()
                    make.height.equalTo(height)
                }
            }
            
            self.tableView.reloadData()
        }
    }
    
    fileprivate var moreSettingDatasource: [OWnerFYMoreSettingEnum] = [] {
        didSet {
            //            tableView.snp.remakeConstraints { (make) in
            //                make.bottom.leading.trailing.equalToSuperview()
            //                make.height.equalTo(datasource.count * 40 + 53 + 80)
            //            }
            if CGFloat(moreSettingDatasource.count * 40 + 133) > (kHeight / 2.0) {
                tableView.isScrollEnabled = true
                tableView.snp.remakeConstraints { (make) in
                    make.bottom.equalToSuperview().offset(-bottomMargin())
                    make.leading.trailing.equalToSuperview()
                    make.height.equalTo(kHeight / 2.0)
                }
            }else {
                let height = CGFloat(moreSettingDatasource.count * 40 + 53 + 80)
                tableView.snp.remakeConstraints { (make) in
                    make.bottom.equalToSuperview().offset(-bottomMargin())
                    make.leading.trailing.equalToSuperview()
                    make.height.equalTo(height)
                }
            }
            
            self.tableView.reloadData()
        }
    }
    
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
    
    
    // MARK: - 弹出view显示 - 排序
    func ShowOwnerSettingView(datasource: [String], clearButtonCallBack: @escaping (() -> Void), sureHouseSortButtonCallBack: @escaping ((Int) -> Void)) -> Void {
        UIApplication.shared.keyWindow?.subviews.forEach({ (view) in
            if view.isKind(of: OwnerFYMoreSettingView.self) {
                view.removeFromSuperview()
            }
        })
        
        self.frame = CGRect(x: 0, y: 0, width: kWidth, height: kHeight)
        self.clearButtonCallBack = clearButtonCallBack
        self.sureHouseSortButtonCallBack = sureHouseSortButtonCallBack
        self.datasource = datasource
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    // MARK: - 弹出view显示 - 房源更多点击独有
    func ShowOwnerFYMoreSettingView(datasource: [OWnerFYMoreSettingEnum], clearButtonCallBack: @escaping (() -> Void), sureHouseSortButtonCallBack: @escaping ((OWnerFYMoreSettingEnum) -> Void)) -> Void {
        UIApplication.shared.keyWindow?.subviews.forEach({ (view) in
            if view.isKind(of: OwnerFYMoreSettingView.self) {
                view.removeFromSuperview()
            }
        })
        
        self.frame = CGRect(x: 0, y: 0, width: kWidth, height: kHeight)
        self.clearButtonCallBack = clearButtonCallBack
        self.sureOwnerFYMoreCallBack = sureHouseSortButtonCallBack
        self.moreSettingDatasource = datasource
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
        addSubview(blackAlphabgView)
        addSubview(tableView)
        addSubview(bottomView)

        blackAlphabgView.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        tableView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(datasource.count * 40 + 53 + 80)
        }
        bottomView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(bottomMargin())
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TypeAndSortCell.self, forCellReuseIdentifier: TypeAndSortCell.reuseIdentifierStr)
    }
    
}

extension OwnerFYMoreSettingView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if moreSettingDatasource.count > 0 {
            return moreSettingDatasource.count
        }
        return self.datasource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TypeAndSortCell.reuseIdentifierStr) as? TypeAndSortCell
        cell?.selectionStyle = .blue
        cell?.titleLabel.font = FONT_15
        if moreSettingDatasource.count > 0 {
            cell?.titleLabel.text = moreSettingDatasource[indexPath.row].rawValue
        }
        if datasource.count > 0 {
            
            cell?.titleLabel.text = datasource[indexPath.row] as? String
        }
        return cell ?? TypeAndSortCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 53
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = kAppWhiteColor
        let title = UILabel()
        title.font = FONT_16
        title.textColor = kAppColor_333333
        if titleString != nil {
            title.text = titleString
        }else {
            title.text = "更多操作"
        }
        title.frame = CGRect(x: left_pending_space_17, y: 0, width: 200, height: 53)
        let button = UIButton(frame: CGRect(x: kWidth - left_pending_space_17 * 3, y: 0, width: left_pending_space_17 * 3, height: 53))
        button.setImage(UIImage.init(named: "closeGray"), for: .normal)
        button.addTarget(self, action: #selector(clickRemoveFromSuperview), for: .touchUpInside)
        view.addSubview(title)
        view.addSubview(button)
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = kAppWhiteColor
        let button = UIButton(frame: CGRect(x: left_pending_space_17, y: 20, width: kWidth - left_pending_space_17 * 2, height: 40))
        button.backgroundColor = kAppBlueColor
        button.setTitle("取消", for: .normal)
        button.titleLabel?.font = FONT_MEDIUM_15
        button.addTarget(self, action: #selector(clickRemoveFromSuperview), for: .touchUpInside)
        view.addSubview(button)
        return view
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if moreSettingDatasource.count > 0 {

            guard let blockk = sureOwnerFYMoreCallBack else {
                return
            }
            blockk(moreSettingDatasource[indexPath.row])
            selfRemove()
        }else {

            guard let blockk = sureHouseSortButtonCallBack else {
                return
            }
            blockk(indexPath.row)
            selfRemove()
        }
        
        
    }
}

