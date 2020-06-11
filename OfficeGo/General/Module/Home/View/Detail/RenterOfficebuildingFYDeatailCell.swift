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
        officePatternLabel.text = viewModel.officePattern?.isBlankString == true ? "--" : viewModel.officePattern
        floorLabel.text = "\(viewModel.floor ?? "0")层"
        earliestDeliveryLabel.text = viewModel.earliestDelivery?.count ?? 0 > 0 ? "--" : viewModel.earliestDelivery
        rentFreePeriodLabel.text = viewModel.rentFreePeriod?.count ?? 0 > 0 ? "--" : viewModel.rentFreePeriod
        //标准下的最短租期单位是年   联合下的最短租期单位是月
        ///1是办公楼，2是联合办公 用来判断最短租期单位
        if viewModel.btype == 1 {
            minimumLeaseLabel.text = "\(viewModel.minimumLease ?? "0")年起"
        }else {
            minimumLeaseLabel.text = "\(viewModel.minimumLease ?? "0")个月起"
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    class func rowHeight() -> CGFloat {
        return 236
    }
}
