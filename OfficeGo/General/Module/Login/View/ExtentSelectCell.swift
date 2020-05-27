//
//  ExtentSelectCell.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/27.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class ExtentSelectCell: BaseTableViewCell {
    
    @IBOutlet weak var categoryTitleLabel: UILabel!
    
    @IBOutlet weak var unitLabel: UILabel!
    
    var minNumLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = kAppBlueColor
        label.font = FONT_12
        label.frame = CGRect(x:0, y:0, width: 60, height: 20)
        return label
    }()
    
    var maxNumLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = kAppBlueColor
        label.font = FONT_12
        label.frame = CGRect(x:0, y:0, width: 60, height: 20)
        return label
    }()
    
    //单位
    var unit: String? {
        didSet {
            unitLabel.text = unit
        }
    }
    
    //滑动杆的值
    var lowValue: Double? {
        didSet {
            sliderView.lowValue = lowValue ?? 0
        }
    }
    
    var highValue: Double? {
         didSet {
             sliderView.highValue = highValue ?? 0
            if highValue == minimumValue{
                maxNumLabel.text = "不限"
            }
         }
     }
     
    var minimumValue: Double? {
           didSet {
               sliderView.minimumValue = minimumValue ?? 0
           }
       }
       
   var maximumValue: Double? {
        didSet {
            sliderView.maximumValue = maximumValue ?? 0
        }
    }
    
    @IBOutlet weak var sliderView: AORangeSlider!
    
    class func rowHeight() -> CGFloat {
        return 120
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        sliderView.minimumValue = 0
//        sliderView.maximumValue = 100
//        sliderView.lowValue = 0
//        sliderView.highValue = 100
        
        self.addSubview(minNumLabel)
        self.addSubview(maxNumLabel)
        
        sliderView.valuesChangedHandler = { [weak self] in
            guard let `self` = self else {
                return
            }
            let lowCenterInSlider = CGPoint(x:self.sliderView.lowCenter.x, y: self.sliderView.lowCenter.y - 30)
            let highCenterInSlider = CGPoint(x:self.sliderView.highCenter.x, y: self.sliderView.highCenter.y - 30)
            let lowCenterInView = self.sliderView.convert(lowCenterInSlider, to: self)
            let highCenterInView = self.sliderView.convert(highCenterInSlider, to: self)
            
            self.minNumLabel.center = lowCenterInView
            self.maxNumLabel.center = highCenterInView
            self.minNumLabel.text = String(format: "%.0f", self.self.sliderView.lowValue)
            self.maxNumLabel.text = String(format: "%.0f", self.self.sliderView.highValue)
            if self.sliderView.highValue == self.maximumValue{
                self.maxNumLabel.text = "不限"
            }
        }
        
    }
    
}
