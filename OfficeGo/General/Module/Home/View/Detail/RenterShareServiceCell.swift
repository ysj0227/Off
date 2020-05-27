//
//  RenterShareServiceCell.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/11.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterShareServiceCell: BaseTableViewCell {

    @IBOutlet weak var chuangyeServiceView: ShareItemBtnView!
    @IBOutlet weak var featureServiceView: ShareItemBtnView!
    @IBOutlet weak var basicServiceView: ShareItemBtnView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        chuangyeServiceView.addTarget(self, action: #selector(showView), for: .touchUpInside)
    }
    
    var featureitemArr: [String] = [] {
        didSet {
            chuangyeServiceView.featureServiceStringList = featureitemArr
            featureServiceView.featureServiceStringList = featureitemArr
        }
    }
    
    lazy var areaView: RenterShareServiceShowView = {
        let view = RenterShareServiceShowView.init(frame: CGRect(x: 0.0, y: 0, width: kWidth, height: kHeight))
        return view
    }()
    
    @IBAction func showView(_ sender: UIButton) {
        if sender.tag == 1 {
            areaView.ShowHouseShaixuanView(tite: "特色服务", model: HouseSelectModel())
        }else if sender.tag == 2 {
            areaView.ShowHouseShaixuanView(tite: "创业服务", model: HouseSelectModel())
        }else if sender.tag == 3 {
            areaView.ShowHouseShaixuanView(tite: "基础服务", model: HouseSelectModel())
        }
    }
//    @objc func showView() {
//        areaView.ShowHouseShaixuanView(tite: "特色服务", model: HouseSelectModel())
//    }

    var basicitemArr: [String] = [] {
        didSet {
            basicServiceView.featureServiceStringList = basicitemArr
        
        }
    }
    
    class func rowHeight() -> CGFloat {
        return 260
    }
}

class ShareItemBtnView: UIButton {
      
    //特色服务
    var featureServiceStringList: [String] = [] {
        didSet {
            setUpFeatureSubviews(str: featureServiceStringList)
        }
    }
    
    //创业服务
    var chuangyeServiceStringList: String = ""
    
    //基础服务
    var basicServiceStringList: String = ""
    
    required init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)
      }
      override init(frame: CGRect) {
          
          super.init(frame: frame)
          
          self.frame = frame
          
      }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    //item之间间距
    let space: CGFloat = 20
    
    //每一项宽度添加的width
    var itemwidth: CGFloat = 20
    
    func setUpFeatureSubviews(str: [String]) {
        var width: CGFloat = 0.0
        for strs in str {
            if (width + (itemwidth + space)) > self.width {
                return
            }
            let btn = BaseImageView.init(frame: CGRect(x: width, y: 0, width: itemwidth, height: self.height))
            btn.setImage(with: strs, placeholder: UIImage.init(named: "wechat"))
            width =  width + (itemwidth + space)
            self.addSubview(btn)
        }
      }

}
