//
//  OwnerCreateBuildingViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/7/17.
//  Copyright © 2020 Senwei. All rights reserved.
//

import Alamofire

class OwnerCreateBuildingViewController: BaseTableViewController {
    
    lazy var bottomBtnView: BottomBtnView = {
        let view = BottomBtnView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: 50))
        view.bottomType = BottomBtnViewType.BottomBtnViewTypeIwantToFind
        view.rightSelectBtn.setTitle("确认创建", for: .normal)
        view.backgroundColor = kAppWhiteColor
        return view
    }()
    
    var typeSourceArray:[OwnerCreatBuildingConfigureModel] = [OwnerCreatBuildingConfigureModel]()
    
    var buildingModel: OwnerESBuildingSearchModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
        setUpData()
    }
    
}


extension OwnerCreateBuildingViewController {
    
    func setUpView() {
        
        titleview = ThorNavigationView.init(type: .backTitleRight)
        titleview?.titleLabel.text = "创建写字楼"
        titleview?.rightButton.isHidden = true
        titleview?.leftButtonCallBack = { [weak self] in
            self?.leftBtnClick()
        }
        
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .backTitleRight))
        
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(kNavigationHeight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kStatusBarHeight)
        }
        
        self.tableView.register(OwnerCreateBuildingCell.self, forCellReuseIdentifier: OwnerCreateBuildingCell.reuseIdentifierStr)
        
        self.view.addSubview(bottomBtnView)
        
        bottomBtnView.rightBtnClickBlock = { [weak self] in
            self?.requestCreateCompany()
        }
        bottomBtnView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-bottomMargin())
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
    }
    
    func setUpData() {
        
        typeSourceArray.append(OwnerCreatBuildingConfigureModel.init(types: .OwnerCreteBuildingTypeBranchName))
        typeSourceArray.append(OwnerCreatBuildingConfigureModel.init(types: .OwnerCreteBuildingTypeBranchDistrictArea))
        typeSourceArray.append(OwnerCreatBuildingConfigureModel.init(types: .OwnerCreteBuildingTypeBranchAddress))
        
        if buildingModel != nil {
            
        }else {
            buildingModel = OwnerESBuildingSearchModel()
        }
        
        self.tableView.reloadData()
    }
    
    func setSureBtnEnable(can: Bool) {
        self.bottomBtnView.rightSelectBtn.isUserInteractionEnabled = can
    }
    
    func updateSuccess() {
        
        AppUtilities.makeToast("保存成功")
        
        SSTool.delay(time: 2) {[weak self] in
            
            self?.leftBtnClick()
            
            self?.setSureBtnEnable(can: true)
            
        }
    }
    
    //发送加入公司和网点公司的通知
    func addNotify() {
        ///身份类型0个人1企业2联合
        NotificationCenter.default.post(name: NSNotification.Name.OwnerCreateBuilding, object: buildingModel)
        leftBtnClick()
    }
    
    ///创建公司接口 -
    func requestCreateCompany() {
        
        addNotify()
    }
    
    
}

extension OwnerCreateBuildingViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OwnerCreateBuildingCell.reuseIdentifierStr) as? OwnerCreateBuildingCell
        cell?.selectionStyle = .none
        cell?.buildingModel = buildingModel
        cell?.model = typeSourceArray[indexPath.row]
        cell?.endEditingMessageCell = { [weak self] (buildingModel) in
            self?.buildingModel = buildingModel
        }
        return cell ?? OwnerCreateBuildingCell.init(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeSourceArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return OwnerCreateBuildingCell.rowHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if typeSourceArray[indexPath.row].type == .OwnerCreteBuildingTypeBranchDistrictArea{
            ///区域商圈选择
            
        }
    }
}

class OwnerCreateBuildingCell: BaseEditCell {
    
    var buildingModel: OwnerESBuildingSearchModel?

    var endEditingMessageCell:((OwnerESBuildingSearchModel) -> Void)?
    
    override func setDelegate() {
        editLabel.delegate = self
    }
    
    var model: OwnerCreatBuildingConfigureModel = OwnerCreatBuildingConfigureModel(types: OwnerCreteBuildingType.OwnerCreteBuildingTypeBranchName) {
        didSet {
            
            titleLabel.attributedText = model.getNameFormType(type: model.type ?? OwnerCreteBuildingType.OwnerCreteBuildingTypeBranchName)
            
            detailIcon.isHidden = true
            
            if model.type == .OwnerCreteBuildingTypeBranchName{
                editLabel.isUserInteractionEnabled = true
                lineView.isHidden = false
                editLabel.text = buildingModel?.buildingName
            }else if model.type == .OwnerCreteBuildingTypeBranchDistrictArea{
                editLabel.isUserInteractionEnabled = false
                lineView.isHidden = false
                detailIcon.isHidden = false
                editLabel.text = buildingModel?.address
            }else if model.type == .OwnerCreteBuildingTypeBranchAddress{
                editLabel.isUserInteractionEnabled = true
                lineView.isHidden = false
                editLabel.text = buildingModel?.address
            }
        }
    }
}

extension OwnerCreateBuildingCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if model.type == .OwnerCreteBuildingTypeBranchName{
            buildingModel?.buildingName = textField.text
        }else if model.type == .OwnerCreteBuildingTypeBranchAddress{
            buildingModel?.address = textField.text
        }
        
        guard let blockk = self.endEditingMessageCell else {
            return
        }
        blockk(buildingModel ?? OwnerESBuildingSearchModel())
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}
