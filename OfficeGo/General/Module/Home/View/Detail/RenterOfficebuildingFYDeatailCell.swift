//
//  RenterOfficebuildingFYDeatailCell.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/11.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterOfficebuildingFYDeatailCell: BaseTableViewCell {
    
    ///办公格局
    @IBOutlet weak var officePatternLabel: UILabel!
    
    @IBOutlet weak var floorLabel: UILabel!
    
    ///"随时",//最早交付
    @IBOutlet weak var earliestDeliveryLabel: UILabel!
    
    ///"6个月",//免租期
    @IBOutlet weak var rentFreePeriodLabel: UILabel!
    
    ///3年起",//最短租期
    @IBOutlet weak var minimumLeaseLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var model: FangYuanBuildingFYDetailBasicInformationModel = FangYuanBuildingFYDetailBasicInformationModel() {
        didSet {
            setCellWithViewModel(viewModel: model)
        }
    }
    
    /**
     ///"随时",//最早交付
     var earliestDelivery : String?
     ///楼层信息
     var floor : String?
     ///3年起",//最短租期
     var minimumLease : String?
     ///办公格局
     var officePattern : String?
     var otherRemark : AnyObject?
     ///"6个月",//免租期
     var rentFreePeriod : String?
     ///户型格局图
     var unitPatternImg : String?
     ///"门朝北，窗户朝向南，2个独立办公室，1间大会议室，3间小会议室。",//户型格局简
     var unitPatternRemark : String?
     */
    func setCellWithViewModel(viewModel: FangYuanBuildingFYDetailBasicInformationModel) {
        officePatternLabel.text = model.officePattern
        floorLabel.text = model.floor
        earliestDeliveryLabel.text = model.earliestDelivery
        rentFreePeriodLabel.text = model.rentFreePeriod
        minimumLeaseLabel.text = model.minimumLease
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    class func rowHeight() -> CGFloat {
        return 236
    }
}
