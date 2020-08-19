//
//  RenterScheduleFYViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/5/25.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterScheduleFYViewController: BaseTableViewController {
    
    ///神策点击预约看房记录的时间 - 从点击到一系列操作完成
    var scheduleTimestemp: String?
    
    var dateSelect: Date?
    
    var messageFYViewModel: MessageFYViewModel? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var dateHasSelect: Bool = false {
        didSet {
            if dateHasSelect {
                bottomBtnView.rightSelectBtn.isUserInteractionEnabled = true
                bottomBtnView.rightSelectBtn.backgroundColor = kAppBlueColor
            }
        }
    }
    
    lazy var bottomBtnView: BottomBtnView = {
        let view = BottomBtnView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: 50))
        view.bottomType = BottomBtnViewType.BottomBtnViewTypeIwantToFind
        view.rightSelectBtn.setTitle("立即约看", for: .normal)
        view.backgroundColor = kAppWhiteColor
        view.rightSelectBtn.isUserInteractionEnabled = false
        view.rightSelectBtn.backgroundColor = kAppColor_btnGray_BEBEBE
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    ///神策 - 预约看房申请提交
    func senorsSubmit_booking_see_house() {

        SensorsAnalyticsFunc.submit_booking_see_house(buildingId: "\(messageFYViewModel?.buildingId ?? 0)", buildOrHouse: messageFYViewModel?.buildOrHouse ?? "", timestamp: scheduleTimestemp ?? "0", seeTime: dateSelect?.yyyyMMddString() ?? "", chatedId: messageFYViewModel?.targetId ?? "0", chatedName: messageFYViewModel?.contactNameString ?? "", createTime: Date().yyyyMMddString())
    }
    
    //业主申请看房
    func sendOwnerYuyueNotify() {
        
        senorsSubmit_booking_see_house()
        
        let interval = Int(round(dateSelect?.timeIntervalSince1970 ?? 0 * 1000))
        
        var params = [String:AnyObject]()
        params["buildingId"] = messageFYViewModel?.buildingId as AnyObject?
        //params["houseIds"] = messageFYViewModel?.houseId as AnyObject?
        params["chatUserId"] = messageFYViewModel?.targetId as AnyObject?
        params["token"] = UserTool.shared.user_token as AnyObject?
        params["time"] = "\(interval)" as AnyObject?
        
        ///神策 - 接口记录添加的从点击预约按钮开始的字段
        params["times"] = scheduleTimestemp as AnyObject?
        
        SSNetworkTool.SSSchedule.request_addProprietorApp(params: params, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            
            if let model = ScheduleList.deserialize(from: response, designatedPath: "data") {
                    
                weakSelf.clickToSendSchedule(interval: interval, fyid: model.id ?? 0)
            }
            
            }, failure: { (error) in
                
        }) { (code, message) in
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    //租户申请看房
    func sendRenterYuyueNotify() {
        
        senorsSubmit_booking_see_house()

        let interval = Int(round(dateSelect?.timeIntervalSince1970 ?? 0 * 1000))
        
        var params = [String:AnyObject]()
        params["buildingId"] = messageFYViewModel?.buildingId as AnyObject?
        //params["houseIds"] = messageFYViewModel?.houseId as AnyObject?
        params["chatUserId"] = messageFYViewModel?.targetId as AnyObject?
        params["token"] = UserTool.shared.user_token as AnyObject?
        params["time"] = "\(interval)" as AnyObject?
        
        ///神策 - 接口记录添加的从点击预约按钮开始的字段
        params["times"] = scheduleTimestemp as AnyObject?
        
        SSNetworkTool.SSSchedule.request_addRenterApp(params: params, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            
            if let model = ScheduleList.deserialize(from: response, designatedPath: "data") {
                    
                weakSelf.clickToSendSchedule(interval: interval, fyid: model.id ?? 0)
            }
            
            }, failure: { (error) in
                
        }) { (code, message) in
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    func clickToSendSchedule(interval: Int, fyid: Int) {
        SSTool.invokeInMainThread {
            NotificationCenter.default.post(name: NSNotification.Name.MsgScheduleSuccess, object: ["interval": interval, "fyid": fyid])
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setUpView() {
        
        self.view.backgroundColor = kAppWhiteColor
        
        self.tableView.backgroundColor = kAppColor_bgcolor_F7F7F7
        
        titleview = ThorNavigationView.init(type: .backTitleRightBlueBgclolor)
        titleview?.titleLabel.text = "预约看房"
        titleview?.rightButton.isHidden = true
        titleview?.leftButtonCallBack = { [weak self] in
            self?.leftBtnClick()
        }
        self.view.addSubview(titleview!)
        
        self.view.addSubview(bottomBtnView)
        bottomBtnView.rightBtnClickBlock = { [weak self] in
            /// role 角色 用户身份类型,,0:租户,1:业主,9:其他
            //组合业主调用的方法不一样
            if UserTool.shared.user_id_type == 0 {
                self?.sendRenterYuyueNotify()
            }else if UserTool.shared.user_id_type == 1 {
                self?.sendOwnerYuyueNotify()
            }
        }
        bottomBtnView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-bottomMargin())
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(kNavigationHeight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomBtnView.snp.top)
        }
        
        self.tableView.register(HouseListTableViewCell.self, forCellReuseIdentifier: HouseListTableViewCell.reuseIdentifierStr)
        self.tableView.register(RenterScheduleUserBasicCell.self, forCellReuseIdentifier: RenterScheduleUserBasicCell.reuseIdentifierStr)

        tableView.reloadData()
    }
    
}

extension RenterScheduleFYViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return 1
        }else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 125
        }else if indexPath.section == 1 {
            return RenterScheduleUserBasicCell.rowHeight()
        }else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HouseListTableViewCell.reuseIdentifierStr) as? HouseListTableViewCell
            cell?.selectionStyle = .none
            cell?.mianjiOrLianheView.isHidden = true
            cell?.featureView.isHidden = true
            cell?.lineView.isHidden = true
            if let viewModel = messageFYViewModel {
                cell?.messageViewModel = viewModel
            }
            return cell ?? HouseListTableViewCell.init(frame: .zero)
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: RenterScheduleUserBasicCell.reuseIdentifierStr) as? RenterScheduleUserBasicCell
            cell?.selectionStyle = .none
            cell?.titleLabel.text = "看房时间"
            cell?.editLabel.placeholder = "请选择看房时间"
            cell?.editLabel.text = dateSelect?.getString(format: "MM月dd日 HH:mm")
            cell?.detailIcon.isHidden = false
            return cell ?? RenterScheduleUserBasicCell.init(frame: .zero)
        }else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 6
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            
            ///点击看房时间选择按钮
            SensorsAnalyticsFunc.order_see_house_time(buildingId: "\(messageFYViewModel?.buildingId ?? 0)", buildOrHouse: messageFYViewModel?.buildOrHouse ?? "", timestamp: scheduleTimestemp ?? "0")
            
            let datePicker = YLDatePicker(currentDate: dateSelect, minLimitDate: Date(), maxLimitDate: nil, datePickerType: .YMDHm) { [weak self] (date) in
                self?.dateSelect = date
                self?.dateHasSelect = true
                self?.tableView.reloadData()
                
                ///预约看房时间确定
                SensorsAnalyticsFunc.confirm_see_house_time(buildingId: "\(self?.messageFYViewModel?.buildingId ?? 0)", buildOrHouse: self?.messageFYViewModel?.buildOrHouse ?? "", timestamp: self?.scheduleTimestemp ?? "0", seeTime: date.yyyyMMddString())
            }
            datePicker.show()
        }
    }
}

class RenterScheduleUserBasicCell: BaseTableViewCell {
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_12
        view.textColor = kAppColor_666666
        return view
    }()
    
    
    lazy var editLabel: UITextField = {
        let view = UITextField()
        view.textAlignment = .left
        view.font = FONT_12
        view.isUserInteractionEnabled = false
        view.textColor = kAppColor_333333
        return view
    }()
    
    
    lazy var detailIcon: BaseImageView = {
        let view = BaseImageView.init()
        view.image = UIImage.init(named: "moreDetail")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func rowHeight() -> CGFloat {
        return 40
    }
    
    func setupViews() {
        
        addSubview(titleLabel)
        addSubview(editLabel)
        addSubview(detailIcon)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.centerY.equalToSuperview()
            make.width.equalTo(57)
        }
        
        editLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel.snp.trailing)
            make.trailing.equalTo(-(left_pending_space_17 + 10))
            make.top.bottom.equalToSuperview()
        }
        
        detailIcon.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-left_pending_space_17)
            make.centerY.equalToSuperview()
            make.width.equalTo(10)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

class RenterScheduleYeZhuBasicCell: BaseTableViewCell {
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_12
        view.text = "带看房东"
        view.textColor = kAppColor_666666
        return view
    }()
    
    lazy var yezhuAvatar: BaseImageView = {
        let view = BaseImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_MEDIUM_13
        view.textColor = kAppColor_333333
        return view
    }()
    lazy var companyLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_10
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func rowHeight() -> CGFloat {
        return 145
    }
    
    var viewModel: MessageFYViewModel? {
        didSet {
            yezhuAvatar.setImage(with: viewModel?.avatarString ?? "", placeholder: UIImage.init(named: "avatar"))
            nameLabel.text = viewModel?.contactNameString
            companyLabel.text = viewModel?.companyJobString
        }
    }
    
    func setupViews() {
        
        addSubview(titleLabel)
        addSubview(yezhuAvatar)
        addSubview(nameLabel)
        addSubview(companyLabel)
        addSubview(lineView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.top.equalToSuperview().inset(20)
        }
        yezhuAvatar.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(23)
            make.size.equalTo(24)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(yezhuAvatar.snp.trailing).offset(10)
            make.centerY.equalTo(yezhuAvatar)
        }
        companyLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(yezhuAvatar)
            make.trailing.equalToSuperview().inset(left_pending_space_17)
            make.leading.equalTo(nameLabel.snp.trailing).offset(3)
        }
        lineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(titleLabel)
            make.bottom.equalTo(yezhuAvatar.snp.bottom).offset(25)
            make.height.equalTo(1)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

