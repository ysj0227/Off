//
//  RenterCustomerListCell.swift
//  OfficeGo
//
//  Created by mac on 2020/9/17.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterCustomerListCell: RCConversationBaseCell {
    
    class var reuseIdentifierStr: String {
        return String(describing: self.self)
    }
    
    lazy var ivAva: BaseImageView = {
        let view = BaseImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 5.0
        return view
    }()
    
    lazy var lblName: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_MEDIUM_15
        view.textColor = kAppColor_333333
        return view
    }()
    
    lazy var lblDetail: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_13
        view.textColor = kAppColor_666666
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    func setChatListDataModel(_ model: ChatListModel!) {
        ivAva.setImage(with: model.avatar ?? "", placeholder: UIImage.init(named: "avatar"))
        lblName.text = model.nickname
        lblDetail.text = "楼盘名称：" + "\(model.buildingName ?? "")"
    }
    
    override func setDataModel(_ model: RCConversationModel!) {
        self.model = model
        ivAva.setImage(with: "", placeholder: UIImage.init(named: "avatar"))
        lblName.text = model.conversationTitle
        lblDetail.text = "消息"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupViews() {
        
        addSubview(ivAva)
        addSubview(lblName)
        addSubview(lblDetail)
        addSubview(lineView)
                  
        ivAva.snp.makeConstraints { (make) in
            make.leading.equalTo(13)
            make.centerY.equalToSuperview()
            make.size.equalTo(46)
        }
        lblName.snp.makeConstraints { (make) in
            make.leading.equalTo(ivAva.snp.trailing).offset(13)
            make.trailing.equalToSuperview().offset(-13)
            make.top.equalTo(ivAva)
        }
        lblDetail.snp.makeConstraints { (make) in
            make.leading.equalTo(lblName)
            make.trailing.equalToSuperview().offset(-13)
            make.bottom.equalTo(ivAva)
        }
        lineView.snp.makeConstraints { (make) in
            make.leading.equalTo(ivAva)
            make.trailing.equalTo(lblDetail)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }

}
