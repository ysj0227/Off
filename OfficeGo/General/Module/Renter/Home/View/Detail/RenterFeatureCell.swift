//
//  RenterFeatureCell.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/11.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterFeatureCell: BaseTableViewCell {
    
    lazy var titleLabel: UILabel = {
        let view = UILabel(frame: CGRect(x: left_pending_space_17, y: 19, width: 22, height: 20))
        view.textAlignment = .left
        view.numberOfLines = 0
        view.font = FONT_11
        view.textColor = kAppBlueColor
        view.text = "特色"
        return view
    }()
    
    lazy var featureView: FeatureView = {
        let view = FeatureView(frame: CGRect(x: 50, y: 15, width: kWidth - 50, height: 20))
//        view.featureString = "免费停车,近地铁,近地铁1"
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
    
    
    var featureString: [String] = [] {
        didSet {
            if featureString.count > 0 {
                titleLabel.isHidden = false
            }else {
                titleLabel.isHidden = true
            }
            featureView.featureNumofLinesStringDetail = featureString
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(titleLabel)
        self.addSubview(featureView)
        self.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(left_pending_space_17)
            make.trailing.equalToSuperview().offset(-left_pending_space_17)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    var itemModel: String = "" {
        didSet {
            
        }
    }
    
    class func rowHeight() -> CGFloat {
        return 58
    }
    class func rowHeight0() -> CGFloat {
        return 58 - 30
    }
}


class FeatureView: UIView {
      
    //办公楼面积显示 - 列表
    var mianjiStringList: [String] = [] {
        didSet {
            widthAdd = 30
            setUpFeatureSubviews(arr: mianjiStringList, font: FONT_10, bgColor: kAppColor_line_D8D8D8, titleColor: kAppColor_666666)
        }
    }
    
    //合作办公- 开发办公室和独立工位显示 - list
    var lianheStringList: [String] = [] {
        didSet {
            widthAdd = 20
            setUpFeatureSubviews(arr: lianheStringList, font: FONT_10, bgColor: kAppBlueColor, titleColor: kAppWhiteColor)
        }
    }
    
    //特色设置 - 列表
    var featureStringList: [String] = [] {
        didSet {
            widthAdd = 40
            setUpFeatureSubviews(arr: featureStringList, font: FONT_MEDIUM_9, bgColor: kAppLightBlueColor, titleColor: kAppBlueColor)
        }
    }
    
    //特色设置 - 详情
       var featureStringDetail: [String] = [] {
           didSet {
            widthAdd = 10
               setUpFeatureSubviews(arr: featureStringDetail, font: FONT_10, bgColor: kAppBlueColor, titleColor: kAppWhiteColor)
           }
       }
       
    //特色设置 - 详情 - 多行显示
    var featureNumofLinesStringDetail: [String] = [] {
        didSet {
            widthAdd = 10
            setUpNumofLinesFeatureSubviews(arr: featureNumofLinesStringDetail, font: FONT_10, bgColor: kAppBlueColor, titleColor: kAppWhiteColor)
        }
    }
    
    func setUpNumofLinesFeatureSubviews(arr: [String], font: UIFont, bgColor: UIColor, titleColor: UIColor) {
        self.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
//        let arr = str.split{$0 == ","}.map(String.init)
        var width: CGFloat = 0.0
        let height: CGFloat = 20.0
        var topY: CGFloat = 5.0

        for strs in arr {
            let itemwidth:CGFloat = strs.boundingRect(with: CGSize(width: kWidth, height: height), font: font, lineSpacing: 0).width + widthAdd
            if (width + (itemwidth + space)) > self.width {
                width = 0.0
                topY += (height + 5)
            }
            let btn = UIButton.init(frame: CGRect(x: width, y: topY, width: itemwidth, height: height))
            btn.setTitleColor(titleColor, for: .normal)
            btn.setTitle(strs, for: .normal)
            btn.titleLabel?.font = font
            width =  width + (itemwidth + space)
            btn.backgroundColor = bgColor
            self.addSubview(btn)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)
      }
      override init(frame: CGRect) {
          
          super.init(frame: frame)
          
          self.frame = frame
          
      }
    
    //item之间间距
    let space: CGFloat = 9
    
    //每一项宽度添加的width
    var widthAdd: CGFloat = 0
    
    func setUpFeatureSubviews(arr: [String], font: UIFont, bgColor: UIColor, titleColor: UIColor) {
        self.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        var width: CGFloat = 0.0
        for strs in arr {
            let itemwidth:CGFloat = strs.boundingRect(with: CGSize(width: kWidth, height: self.height), font: font, lineSpacing: 0).width + widthAdd
            if (width + (itemwidth + space)) > self.width {
                return
            }
            let btn = UIButton.init(frame: CGRect(x: width, y: 0, width: itemwidth, height: self.height))
            btn.setTitleColor(titleColor, for: .normal)
            btn.setTitle(strs, for: .normal)
            btn.titleLabel?.font = font
            width =  width + (itemwidth + space)
            btn.backgroundColor = bgColor
            self.addSubview(btn)
        }
      }

}
