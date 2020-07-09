//
//  RenterDetailTrafficCell.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/11.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterDetailTrafficCell: BaseTableViewCell {
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var trafficIcon: UIImageView!
    
    @IBOutlet weak var trafficLineView: UIView!
    
    @IBOutlet weak var lookAllButton: UIButton!
    
    @IBOutlet weak var lineViewConstantHeight: NSLayoutConstraint!
    
    //点击全部站点- block
    var trafficBtnClick: ((_ isUp: Bool) -> Void)?
    
    @IBAction func clickLookAllLineview(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard let blockk = trafficBtnClick else {
            return
        }
        blockk(sender.isSelected)
        setBtnUpOrDown(button: sender, isUp: sender.isSelected)
    }
    
    //设置按钮箭头方向
    func setBtnUpOrDown(button: UIButton?, isUp: Bool) {
        if isUp {
            button?.setImage(UIImage(named: "upDirGray"), for: .normal)
        }else {
            button?.setImage(UIImage(named: "downDirGray"), for: .normal)
        }
    }
    var model: FangYuanBuildingBuildingModel = FangYuanBuildingBuildingModel() {
        didSet {
            viewModel = FangYuanBuildingBuildingViewModel.init(model: model)
        }
    }
    
    var viewModel: FangYuanBuildingBuildingViewModel = FangYuanBuildingBuildingViewModel(model: FangYuanBuildingBuildingModel()) {
        didSet {
            
            setCellWithViewModel(viewModel: viewModel)
        }
    }
    
    func setCellWithViewModel(viewModel: FangYuanBuildingBuildingViewModel) {
        
        addressLabel.text = viewModel.addressString
        if viewModel.walkTimesubwayAndStationStringArr?.count ?? 0 <= 0 {
            trafficIcon.isHidden = true
            lookAllButton.isHidden = true
            trafficLineView.isHidden = true
        }else {
            trafficIcon.isHidden = false
            lookAllButton.isHidden = false
            trafficLineView.isHidden = false
            addLineLabels(str: viewModel.walkTimesubwayAndStationStringArr ?? [])
        }
    }
    
    
    
    var fYViewModel: FangYuanBuildingFYDetailHouseViewModel = FangYuanBuildingFYDetailHouseViewModel(model: FangYuanBuildingFYDetailHouseModel()) {
        didSet {
            
            setfYCellWithViewModel(viewModel: fYViewModel)
        }
    }
    
    func setfYCellWithViewModel(viewModel: FangYuanBuildingFYDetailHouseViewModel) {
        
        addressLabel.text = viewModel.addressString
        if viewModel.walkTimesubwayAndStationStringArr?.count ?? 0 <= 0 {
            trafficIcon.isHidden = true
            lookAllButton.isHidden = true
            trafficLineView.isHidden = true
        }else {
            trafficIcon.isHidden = false
            lookAllButton.isHidden = false
            trafficLineView.isHidden = false
            addLineLabels(str: viewModel.walkTimesubwayAndStationStringArr ?? [])
        }
    }
    
    func addLineLabels(str: [String]) {
        trafficLineView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        var height: CGFloat = 0.0
        for strs in str {
            let itemHeight:CGFloat = 30
            let view = UILabel.init(frame: CGRect(x: 0, y: height, width: trafficLineView.width, height: itemHeight))
            view.text = strs
            view.font = FONT_11
            view.textColor = kAppColor_666666
            height =  height + itemHeight
            trafficLineView.addSubview(view)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.clipsToBounds = true
        lookAllButton.setTitle("全部站点", for: .normal)
        lookAllButton.setImage(UIImage(named: "downDirGray"), for: .normal)
        lookAllButton.layoutButton(.imagePositionRight, space: 4)
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    class func rowHeight() -> CGFloat {
        return 45 + 30
    }
    
    func rowHeight() -> CGFloat {
        return 45 + 30 * 2
    }
}
