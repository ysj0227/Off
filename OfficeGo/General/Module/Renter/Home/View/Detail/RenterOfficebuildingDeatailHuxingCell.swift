//
//  RenterOfficebuildingDeatailHuxingCell.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/11.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterOfficebuildingDeatailHuxingCell: BaseTableViewCell {

    @IBOutlet weak var huxingLabel: UILabel!
    
    @IBOutlet weak var huxingImgConstantHeight: NSLayoutConstraint!
    
    @IBOutlet weak var huxingImgBottomConstantHeight: NSLayoutConstraint!
    
    @IBOutlet weak var huxingConstangHeight: NSLayoutConstraint!
    
    ///户型格局图
    @IBOutlet weak var unitPatternImgView: BaseImageView!
    
    ///"门朝北，窗户朝向南，2个独立办公室，1间大会议室，3间小会议室。",//户型格局简
    @IBOutlet weak var unitPatternRemarkLabel: UILabel!
    
    var basicViewModel: FangYuanBuildingFYDetailBasicInformationViewModel = FangYuanBuildingFYDetailBasicInformationViewModel.init(model: FangYuanBuildingFYDetailBasicInformationModel()) {
        didSet {
            setCellWithViewModel(viewModel: basicViewModel)
        }
    }

    func setCellWithViewModel(viewModel: FangYuanBuildingFYDetailBasicInformationViewModel) {
        if viewModel.patternCellHeight == 0 {
            huxingLabel.isHidden = true
        }else {
            huxingLabel.isHidden = true
        }
        huxingConstangHeight.constant = viewModel.textHeight
        huxingImgConstantHeight.constant = viewModel.patternHeight
        if viewModel.patternHeight == 0 {
            huxingImgBottomConstantHeight.constant = viewModel.patternHeight
        }
        unitPatternImgView.setImage(with: viewModel.unitPatternImg ?? "", placeholder: UIImage.init(named: Default_4x3_large))
        unitPatternRemarkLabel.text = viewModel.unitPatternRemark
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        unitPatternRemarkLabel.font = FONT_LIGHT_11
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func rowHeight() -> CGFloat {
        return 55 + 17 * 2 + (kWidth - left_pending_space_17 * 2) * (2 / 3.0)
    }
}
