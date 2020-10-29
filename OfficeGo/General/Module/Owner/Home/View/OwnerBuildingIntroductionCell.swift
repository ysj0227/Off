//
//  OwnerBuildingIntroductionCell.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/10/9.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerBuildingIntroductionCell: BaseTableViewCell {

    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_14
        view.text = "详细介绍"
        view.textColor = kAppColor_333333
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
    
    lazy var intruductionTextview: UITextView = {
        let view = UITextView()
        view.delegate = self
        view.textAlignment = .left
        view.placeholder = "请输入详细介绍"
        view.holderColor = kAppColor_btnGray_BEBEBE
        view.font = FONT_12
        view.textColor = kAppColor_666666
        view.backgroundColor = kAppClearColor
        return view
    }()
    
    lazy var numOfCharLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.font = FONT_10
        view.text = "0/100"
        view.textColor = kAppColor_btnGray_BEBEBE
        return view
    }()

    var buildingModel: FangYuanBuildingEditModel = FangYuanBuildingEditModel() {
        didSet {
            intruductionTextview.text = buildingModel.buildingMsg?.buildingIntroduction
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func rowHeight() -> CGFloat {
        return 200
    }
           
    func setupViews() {

        self.backgroundColor = kAppWhiteColor
  
        self.addSubview(titleLabel)
        self.addSubview(lineView)
        self.addSubview(intruductionTextview)
        self.addSubview(numOfCharLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.top.equalToSuperview()
            make.height.equalTo(cell_height_58)
        }
        numOfCharLabel.snp.makeConstraints { (make) in
            make.trailing.bottom.equalToSuperview().inset(left_pending_space_17)
        }
        intruductionTextview.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(-5)
            make.leading.trailing.equalToSuperview().inset(13)
            make.bottom.equalTo(numOfCharLabel.snp.top)
        }
        lineView.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.trailing.equalTo(-left_pending_space_17)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }

}

extension OwnerBuildingIntroductionCell: UITextViewDelegate {
    //MARK: - TextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        //获得已输出字数与正输入字母数
        let selectRange = textView.markedTextRange
        //获取高亮部分 － 如果有联想词则解包成功
        if let selectRange = selectRange {
            let position =  textView.position(from: (selectRange.start), offset: 0)
            if (position != nil) {
                return
            }
        }
        let textContent = textView.text
        let textNum = textContent?.count
        //截取
        if textNum! > 100 {
            let index = textContent?.index((textContent?.startIndex)!, offsetBy: 100)
            let str = textContent?.substring(to: index!)
            textView.text = str
            numOfCharLabel.text = "100/100"
            buildingModel.buildingMsg?.buildingIntroduction = textView.text
        }
        numOfCharLabel.text = String(format: "%ld/100",textView.text.count)
    }
}
