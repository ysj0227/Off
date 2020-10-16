//
//  OwnerBuildingImgCell.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/10/10.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import CLImagePickerTool

class OwnerBuildingImgCell: BaseTableViewCell {
    
    @objc var uploadPicModelFCZArr = [BannerModel]()  // 在实际的项目中可能用于存储图片的url
    
    lazy var fczImagePickTool: CLImagePickerTool = {
        let picker = CLImagePickerTool()
        picker.cameraOut = true
        picker.isHiddenVideo = true
        return picker
    }()
    
    lazy var headerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: left_pending_space_17 - 3, bottom: 0, right: left_pending_space_17 - 3)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = kAppWhiteColor
        view.isScrollEnabled = false
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
    
    var buildingModel: FangYuanBuildingEditDetailModel = FangYuanBuildingEditDetailModel() {
        didSet {
            reloadData()
        }
    }
    var model: OwnerBuildingEditConfigureModel?
    
    var jointModel: OwnerBuildingJointEditConfigureModel?
    
    var officeModel: OwnerBuildingOfficeConfigureModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupViews() {
        
        addSubview(headerCollectionView)
        addSubview(lineView)
        
        headerCollectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.trailing.equalTo(-left_pending_space_17)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
        headerCollectionView.register(OwnerImagePickerCell.self, forCellWithReuseIdentifier: OwnerImagePickerCell.reuseIdentifierStr)
        headerCollectionView.register(OwnerImgPickerCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "OwnerImgPickerCollectionViewHeader")
    }
    
    
    func reloadData() {
        headerCollectionView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

extension OwnerBuildingImgCell {
    func selectFCZPicker() {
        var imgArr = [BannerModel]()
        fczImagePickTool.cl_setupImagePickerWith(MaxImagesCount: ownerBuildingImageNumber_9 - uploadPicModelFCZArr.count) {[weak self] (asset,cutImage) in
            // 内部提供的方法可以异步获取图片，同步获取的话时间比较长，不建议！，如果是iCloud中的照片就直接从icloud中下载，下载完成后返回图片,同时也提供了下载失败的方法
            CLImagePickerTool.convertAssetArrToOriginImage(assetArr: asset, scale: 0.1, successClouse: {[weak self] (image,assetItem) in
                let img = image.resizeMax1500Image()
                
                let fczBannerModel = BannerModel()
                fczBannerModel.isLocal = true
                fczBannerModel.image = img
                imgArr.append(fczBannerModel)
                }, failedClouse: { () in
                    
            })
            //房产证
            self?.uploadPicModelFCZArr.append(contentsOf: imgArr)
            self?.loadCollectionData()
        }
    }
    
    func loadCollectionData() {
        headerCollectionView.reloadData()
    }
    
    ///删除房产证图片接口
    func request_deleteFCZImgApp(index: Int) {
        
        if uploadPicModelFCZArr[index].isLocal == true {
            uploadPicModelFCZArr.remove(at: index)
            loadCollectionData()
            return
        }
        
        var params = [String:AnyObject]()
        
        params["id"] = uploadPicModelFCZArr[index].id as AnyObject?
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        SSNetworkTool.SSOwnerIdentify.request_getDeleteImgApp(params: params, success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
            
            weakSelf.uploadPicModelFCZArr.remove(at: index)
            weakSelf.loadCollectionData()
            
            }, failure: { (error) in
                
        }) { (code, message) in
            
            //只有5000 提示给用户 - 失效原因
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" || code == "\(SSCode.ERROR_CODE_7016.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
}

extension OwnerBuildingImgCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return uploadPicModelFCZArr.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OwnerImagePickerCell.reuseIdentifierStr, for: indexPath as IndexPath) as? OwnerImagePickerCell
        cell?.indexPath = indexPath
        if indexPath.item <= uploadPicModelFCZArr.count - 1  {
            if uploadPicModelFCZArr[indexPath.item].isLocal == false {
                cell?.image.setImage(with: uploadPicModelFCZArr[indexPath.item].imgUrl ?? "", placeholder: UIImage(named: Default_1x1))
            }else {
                cell?.image.image = uploadPicModelFCZArr[indexPath.item].image
            }
            cell?.closeBtnClickClouse = { [weak self] (index) in
                self?.request_deleteFCZImgApp(index: index)
            }
        }else {
            cell?.image.image = UIImage.init(named: "addImgBg")
        }
        
        if indexPath.item == uploadPicModelFCZArr.count {
            cell?.closeBtn.isHidden = true
        }else {
            cell?.closeBtn.isHidden = false
        }
        return cell ?? OwnerImagePickerCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == uploadPicModelFCZArr.count {
            if indexPath.item < ownerBuildingImageNumber_9 {
                selectFCZPicker()
            }else {
                AppUtilities.makeToast("最多可选择\(ownerBuildingImageNumber_9)张图片")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (kWidth - left_pending_space_17 * 2 - 5 * 2) / 3.0 - 1, height: (kWidth - left_pending_space_17 * 2 - 5 * 2) / 3.0 - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "OwnerImgPickerCollectionViewHeader", for: indexPath) as? OwnerImgPickerCollectionViewHeader
            header?.backgroundColor = kAppWhiteColor
            header?.descLabel.adjustsFontSizeToFitWidth = true
            if model != nil {
                header?.titleLabel.attributedText = model?.getNameFormType(type: model?.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingImage)
                header?.descLabel.text = model?.getPalaceHolderFormType(type: model?.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingImage)
            }else if jointModel != nil {
                header?.titleLabel.attributedText = jointModel?.getNameFormType(type: jointModel?.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeBuildingImage)
                header?.descLabel.text = jointModel?.getPalaceHolderFormType(type: jointModel?.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeBuildingImage)
            }else if officeModel != nil {
                header?.titleLabel.attributedText = officeModel?.getNameFormType(type: officeModel?.type ?? OwnerBuildingOfficeType.OwnerBuildingOfficeTypeBuildingImage)
                header?.descLabel.text = officeModel?.getPalaceHolderFormType(type: officeModel?.type ?? OwnerBuildingOfficeType.OwnerBuildingOfficeTypeBuildingImage)
            }

            return header ?? UICollectionReusableView()
        }
        
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: kWidth, height: 68)
    }
}

