//
//  OwnerBuildingCreateVideoVRViewController.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/10/10.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON
import Photos

class OwnerBuildingCreateVideoVRViewController: BaseTableViewController {
    
    //记录是否已经点了关闭pc按钮
    var isClose: Bool?
    
    var videoModel: BannerModel = BannerModel()
    
    var typeSourceArray:[OwnerBuildingEditConfigureModel] = [OwnerBuildingEditConfigureModel]()

    ///
    var buildingModel: FangYuanBuildingEditDetailModel?

    lazy var fczImagePickTool: UploadVideoTool = {
        let picker = UploadVideoTool()
        return picker
    }()
    
    lazy var saveBtn: UIButton = {
        let button = UIButton.init()
        button.clipsToBounds = true
        button.layer.cornerRadius = button_cordious_2
        button.backgroundColor = kAppBlueColor
        button.titleLabel?.font = FONT_MEDIUM_16
        button.setTitleColor(kAppWhiteColor, for: .normal)
        button.setTitle("保存并发布", for: .normal)
        button.addTarget(self, action: #selector(saveClick), for: .touchUpInside)
        return button
    }()
    
    lazy var pcEditBtn: UIButton = {
        let button = UIButton.init()
        button.clipsToBounds = true
        button.layer.cornerRadius = button_cordious_2
        button.layer.borderColor = kAppBlueColor.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = kAppWhiteColor
        button.titleLabel?.font = FONT_MEDIUM_16
        button.setTitleColor(kAppBlueColor, for: .normal)
        button.setTitle("在电脑上编辑", for: .normal)
        button.addTarget(self, action: #selector(pcEditClick), for: .touchUpInside)
        return button
    }()
    
    lazy var closePcEditBtn: UIButton = {
        let button = UIButton.init()
        button.setImage(UIImage.init(named: "closeBlue"), for: .normal)
        button.addTarget(self, action: #selector(closePcEditClick), for: .touchUpInside)
        return button
    }()
    
    @objc func saveClick() {
        let vc = OwnerBuildingCreateVideoVRViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func pcEditClick() {
        clickToQCode()
    }
    
    @objc func closePcEditClick() {
        isClose = true
        pcEditBtn.snp.remakeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.bottom.equalToSuperview().offset(-(bottomMargin()))
            make.height.equalTo(0)
        }
        closePcEditBtn.isHidden = true
    }
    
    ///跳转二维码页面页面
    func clickToQCode() {
        //设置扫码区域参数
        var style = LBXScanViewStyle()
        style.centerUpOffset = 44
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Inner
        style.photoframeLineW = 2
        style.photoframeAngleW = 18
        style.photoframeAngleH = 18
        style.isNeedShowRetangle = false

        style.anmiationStyle = LBXScanViewAnimationStyle.LineMove

        style.colorAngle = UIColor(red: 0.0/255, green: 200.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_Scan_weixin_Line")
        
        
        let vc = LBXScanViewController()
        vc.scanStyle = style
        vc.isOpenInterestRect = true
        let nav = BaseNavigationViewController.init(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        //TODO: 这块弹出要设置
        self.present(nav, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpData()
        
        setUpView()
    }
    
    func setUpData() {
        
        ///上传楼盘视频
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeBuildingVideo))
        ///添加vr
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeBuildingVR))
                
        if buildingModel != nil {
            
        }else {
            buildingModel = FangYuanBuildingEditDetailModel()
            buildingModel?.videoUrl = []
        }
    }
}

extension OwnerBuildingCreateVideoVRViewController {
    
    func setUpView() {
        
        titleview = ThorNavigationView.init(type: .backTitleRight)
        //设置背景颜色为蓝色 文字白色 -
        titleview?.backgroundColor = kAppBlueColor
        titleview?.backTitleRightView.backgroundColor = kAppClearColor
        titleview?.titleLabel.textColor = kAppWhiteColor
        titleview?.rightButton.setTitleColor(kAppWhiteColor, for: .normal)
        titleview?.rightButton.snp.remakeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.width.equalTo(65)
            make.top.bottom.equalToSuperview()
        }
        
        titleview?.leftButton.setImage(UIImage.init(named: "backWhite"), for: .normal)
        titleview?.leftButton.isHidden = false
        titleview?.rightButton.isHidden = true
        titleview?.titleLabel.text = "上传视频"
        titleview?.leftButtonCallBack = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .backTitleRight))
        
        
        self.view.addSubview(pcEditBtn)
        self.view.addSubview(saveBtn)
        
        pcEditBtn.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.bottom.equalToSuperview().offset(-(bottomMargin() + 20))
            make.height.equalTo(40)
        }

        saveBtn.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.bottom.equalTo(pcEditBtn.snp.top).offset(-20)
            make.height.equalTo(40)
        }
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(kNavigationHeight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(saveBtn.snp.top)
        }
        
        ///pc登录按钮显示
        if isClose == true {
            pcEditBtn.snp.remakeConstraints { (make) in
                make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
                make.bottom.equalToSuperview().offset(-(bottomMargin()))
                make.height.equalTo(0)
            }
        }else {
            self.view.addSubview(closePcEditBtn)
            closePcEditBtn.snp.makeConstraints { (make) in
                make.trailing.equalToSuperview()
                make.bottom.equalTo(pcEditBtn.snp.top).offset(20)
                make.size.equalTo(40)
            }
        }
        
        requestSet()
    }
    
    func requestSet() {
        
        isShowRefreshHeader = true
                
//        self.tableView.backgroundColor = kAppColor_bgcolor_F7F7F7
        
        ///视频选择
        self.tableView.register(OwnerBuildingVideoCell.self, forCellReuseIdentifier: OwnerBuildingVideoCell.reuseIdentifierStr)
        
        self.tableView.register(OwnerBuildingVRCell.self, forCellReuseIdentifier: OwnerBuildingVRCell.reuseIdentifierStr)

        
        refreshData()
        
    }
    
    func selectFCZPicker() {
        fczImagePickTool.chooseMultimediaWihtType(.forVideo, chooseVideoDone: {[weak self] (videoPath) in
            self?.videoModel.isLocal = true
            self?.videoModel.imgUrl = videoPath
            self?.buildingModel?.videoUrl?.removeAll()
            self?.buildingModel?.videoUrl?.append(self?.videoModel ?? BannerModel())
            self?.tableView.reloadData()
        }, chooseImageDone: nil)
       }
}

extension OwnerBuildingCreateVideoVRViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model:OwnerBuildingEditConfigureModel = typeSourceArray[indexPath.row]
        
        if model.type == .OwnerBuildingEditTypeBuildingVideo {
            ///点击cell
            let videoCell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingVideoCell.reuseIdentifierStr) as? OwnerBuildingVideoCell
            videoCell?.selectionStyle = .none
            videoCell?.model = model
            videoCell?.buildingModel = self.buildingModel ?? FangYuanBuildingEditDetailModel()
            videoCell?.closeBtnClickClouse = { [weak self] (index) in
                self?.buildingModel?.videoUrl?.removeAll()
                self?.tableView.reloadData()
            }
            videoCell?.selectVideoClickClouse = { [weak self] (index) in
                self?.selectFCZPicker()
            }
            
            return videoCell ?? OwnerBuildingVideoCell.init(frame: .zero)
        }else if model.type == .OwnerBuildingEditTypeBuildingVR {
            ///点击cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingVRCell.reuseIdentifierStr) as? OwnerBuildingVRCell
            cell?.selectionStyle = .none
            cell?.model = model
            cell?.buildingModel = self.buildingModel ?? FangYuanBuildingEditDetailModel()
            return cell ?? OwnerBuildingVRCell.init(frame: .zero)
        }else {
            return UITableViewCell()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeSourceArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if typeSourceArray[indexPath.row].type == .OwnerBuildingEditTypeBuildingVideo {
            return OwnerBuildingVideoCell.rowHeight()

        }else if typeSourceArray[indexPath.row].type == .OwnerBuildingEditTypeBuildingVR {
            return OwnerBuildingVRCell.rowHeight()
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.typeSourceArray.count <= 0 {
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = kAppWhiteColor
        return view
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0
    }
}



