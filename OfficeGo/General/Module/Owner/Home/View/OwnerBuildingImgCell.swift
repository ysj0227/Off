//
//  OwnerBuildingImgCell.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/10/10.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import CLImagePickerTool
import HandyJSON
import SwiftyJSON


class OwnerBuildingImgCell: BaseTableViewCell {
        
    var imgSelectClickBlock:((_ maxImg: Int) -> Void)?

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
    
    var FYModel : FangYuanHouseEditModel = FangYuanHouseEditModel() {
        didSet {
            reloadData()
        }
    }
    
    var buildingModel: FangYuanBuildingEditModel = FangYuanBuildingEditModel() {
        didSet {
            reloadData()
        }
    }
    
    //楼盘弹出 imgpicker vc
    var buildingCreatVC: BaseViewController?
    
    var model: OwnerBuildingEditConfigureModel?
    
    //网点弹出 imgpicker vc
    var buildingJointCreatVC: BaseViewController?
    
    var jointModel: OwnerBuildingJointEditConfigureModel?
    
    var officeModel: OwnerBuildingOfficeConfigureModel?
    
    ///独立办公室
    var jointIndepentOfficeModel: OwnerBuildingJointOfficeConfigureModel?
    
    ///开放工位
    var jointOpenStationModel: OwnerBuildingJointOpenStationConfigureModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupViews() {

        self.backgroundColor = kAppWhiteColor
  
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
        headerCollectionView.register(OwnerFYManagerImagePickerCell.self, forCellWithReuseIdentifier: OwnerFYManagerImagePickerCell.reuseIdentifierStr)
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
        
        if model != nil {

            var imgArr = [BannerModel]()
            var imggggArr = [UIImage]()
            fczImagePickTool.cl_setupImagePickerWith(MaxImagesCount: ownerBuildingImageNumber_9 - buildingModel.buildingLocalImgArr.count, superVC: buildingCreatVC) {[weak self] (asset,cutImage) in
                // 内部提供的方法可以异步获取图片，同步获取的话时间比较长，不建议！，如果是iCloud中的照片就直接从icloud中下载，下载完成后返回图片,同时也提供了下载失败的方法
                CLImagePickerTool.convertAssetArrToOriginImage(assetArr: asset, scale: 0.1, successClouse: {[weak self] (image,assetItem) in
                    let img = image.resizeMax1500Image()

                    let fczBannerModel = BannerModel()
                    fczBannerModel.isLocal = true
                    fczBannerModel.image = img
                    
                    if self?.buildingModel.buildingLocalImgArr.count ?? 0 <= 0 {
                        fczBannerModel.isMain = true
                    }else {
                        fczBannerModel.isMain = false
                    }
                    imgArr.append(fczBannerModel)
                    imggggArr.append(img ?? UIImage())
                    }, failedClouse: { () in
                        
                })
                self?.uploadBuildingImg(imgArr: imggggArr, existImgCount: self?.buildingModel.buildingLocalImgArr.count ?? 0)
                //房产证
                self?.buildingModel.buildingLocalImgArr.append(contentsOf: imgArr)
                self?.loadCollectionData()
            }
        }else if jointModel != nil {

            var imgArr = [BannerModel]()
            var imggggArr = [UIImage]()
            fczImagePickTool.cl_setupImagePickerWith(MaxImagesCount: ownerBuildingImageNumber_9 - buildingModel.buildingLocalImgArr.count, superVC: buildingJointCreatVC) {[weak self] (asset,cutImage) in
                // 内部提供的方法可以异步获取图片，同步获取的话时间比较长，不建议！，如果是iCloud中的照片就直接从icloud中下载，下载完成后返回图片,同时也提供了下载失败的方法
                CLImagePickerTool.convertAssetArrToOriginImage(assetArr: asset, scale: 0.1, successClouse: {[weak self] (image,assetItem) in
                    let img = image.resizeMax1500Image()

                    let fczBannerModel = BannerModel()
                    fczBannerModel.isLocal = true
                    fczBannerModel.image = img
                    
                    if self?.buildingModel.buildingLocalImgArr.count ?? 0 <= 0 {
                        fczBannerModel.isMain = true
                    }else {
                        fczBannerModel.isMain = false
                    }
                    imgArr.append(fczBannerModel)
                    imggggArr.append(img ?? UIImage())
                    }, failedClouse: { () in
                        
                })
                self?.uploadBuildingImg(imgArr: imggggArr, existImgCount: self?.buildingModel.buildingLocalImgArr.count ?? 0)
                //房产证
                self?.buildingModel.buildingLocalImgArr.append(contentsOf: imgArr)
                self?.loadCollectionData()
            }
        }else {

            var imgArr = [BannerModel]()
            var imggggArr = [UIImage]()
            fczImagePickTool.cl_setupImagePickerWith(MaxImagesCount: ownerBuildingImageNumber_9 - FYModel.buildingLocalImgArr.count) {[weak self] (asset,cutImage) in
                // 内部提供的方法可以异步获取图片，同步获取的话时间比较长，不建议！，如果是iCloud中的照片就直接从icloud中下载，下载完成后返回图片,同时也提供了下载失败的方法
                CLImagePickerTool.convertAssetArrToOriginImage(assetArr: asset, scale: 0.1, successClouse: {[weak self] (image,assetItem) in
                    let img = image.resizeMax1500Image()

                    let fczBannerModel = BannerModel()
                    fczBannerModel.isLocal = true
                    fczBannerModel.image = img
                    
                    if self?.FYModel.buildingLocalImgArr.count ?? 0 <= 0 {
                        fczBannerModel.isMain = true
                    }else {
                        fczBannerModel.isMain = false
                    }
                    imgArr.append(fczBannerModel)
                    imggggArr.append(img ?? UIImage())
                    }, failedClouse: { () in
                        
                })
                self?.uploadImg(imgArr: imggggArr, existImgCount: self?.FYModel.buildingLocalImgArr.count ?? 0)
                //房产证
                self?.FYModel.buildingLocalImgArr.append(contentsOf: imgArr)
                self?.loadCollectionData()
            }
        }
    }

    
    func uploadBuildingImg(imgArr: [UIImage], existImgCount: Int) {
        
        var params = [String:AnyObject]()
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        ///0图片1视频
        params["filedirType"] = 0 as AnyObject?

        
        SSNetworkTool.SSFYManager.request_uploadResourcesUrl(params: params, imagesArray: imgArr, success: {[weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<BannerModel>.deserializeModelArrayFrom(json: JSON(response["data"] ?? "").rawString() ?? "", designatedPath: "urls") {
                
                if decoratedArray.count == imgArr.count {
                    var count = 0
                    for model in decoratedArray {
                        if count < decoratedArray.count {

                            weakSelf.buildingModel.buildingLocalImgArr[existImgCount + count].imgUrl = model?.url
                            count += 1
                        }
                    }
                }
                
            }
            
            }, failure: {[weak self] (error) in

                
        }) {[weak self] (code, message) in

            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    
    func uploadImg(imgArr: [UIImage], existImgCount: Int) {
        
        var params = [String:AnyObject]()
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        ///0图片1视频
        params["filedirType"] = 0 as AnyObject?

        
        SSNetworkTool.SSFYManager.request_uploadResourcesUrl(params: params, imagesArray: imgArr, success: {[weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<BannerModel>.deserializeModelArrayFrom(json: JSON(response["data"] ?? "").rawString() ?? "", designatedPath: "urls") {
                
                if decoratedArray.count == imgArr.count {
                    var count = 0
                    for model in decoratedArray {
                        if count < decoratedArray.count {

                            weakSelf.FYModel.buildingLocalImgArr[existImgCount + count].imgUrl = model?.url
                            count += 1
                        }
                    }
                }
                
            }
            
            }, failure: {[weak self] (error) in

                
        }) {[weak self] (code, message) in

            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    func loadCollectionData() {
        headerCollectionView.reloadData()
    }
    
    ///删除房产证图片接口
    func request_deleteFCZImgApp(index: Int) {
        
        if model != nil || jointModel != nil {
            if buildingModel.buildingLocalImgArr[index].isLocal == true {
                buildingModel.buildingDeleteRemoteArr.append(buildingModel.buildingLocalImgArr[index])
                buildingModel.buildingLocalImgArr.remove(at: index)

                ///删除之后，如果图片还有。则默认第一个为封面图
                if buildingModel.buildingLocalImgArr.count > 0 {
                    buildingModel.buildingLocalImgArr[0].isMain = true
                }
                loadCollectionData()
            }else {
                buildingModel.buildingDeleteRemoteArr.append(buildingModel.buildingLocalImgArr[index])
                buildingModel.buildingLocalImgArr.remove(at: index)
                
                ///删除之后，如果图片还有。则默认第一个为封面图
                if buildingModel.buildingLocalImgArr.count > 0 {
                    buildingModel.buildingLocalImgArr[0].isMain = true
                }
                
                loadCollectionData()
            }
        }else {
            if FYModel.buildingLocalImgArr[index].isLocal == true {
                FYModel.buildingDeleteRemoteArr.append(FYModel.buildingLocalImgArr[index])
                FYModel.buildingLocalImgArr.remove(at: index)
                ///删除之后，如果图片还有。则默认第一个为封面图
                if FYModel.buildingLocalImgArr.count > 0 {
                    FYModel.buildingLocalImgArr[0].isMain = true
                }
                loadCollectionData()
            }else {
                FYModel.buildingDeleteRemoteArr.append(FYModel.buildingLocalImgArr[index])
                FYModel.buildingLocalImgArr.remove(at: index)
                
                ///删除之后，如果图片还有。则默认第一个为封面图
                if FYModel.buildingLocalImgArr.count > 0 {
                    FYModel.buildingLocalImgArr[0].isMain = true
                }
                
                loadCollectionData()
            }
        }

    }
    
    ///设置封面图
    func setMainPic(index: Int) {
           
        if model != nil || jointModel != nil {

            buildingModel.buildingLocalImgArr[0].isMain = false
            
            buildingModel.buildingLocalImgArr[index].isMain = true
            
            ///把设置的封面图插入到放在第一位
            buildingModel.buildingLocalImgArr.insert(buildingModel.buildingLocalImgArr[index], at: 0)
            
            ///移除之前的数据的index + 1的图片
            buildingModel.buildingLocalImgArr.remove(at: index + 1)
            loadCollectionData()
        }else {

            FYModel.buildingLocalImgArr[0].isMain = false
            
            FYModel.buildingLocalImgArr[index].isMain = true
            
            ///把设置的封面图插入到放在第一位
            FYModel.buildingLocalImgArr.insert(FYModel.buildingLocalImgArr[index], at: 0)
            
            ///移除之前的数据的index + 1的图片
            FYModel.buildingLocalImgArr.remove(at: index + 1)
            loadCollectionData()
        }
    }
}

extension OwnerBuildingImgCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if model != nil || jointModel != nil {
            return buildingModel.buildingLocalImgArr.count + 1
        }else {
            return FYModel.buildingLocalImgArr.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OwnerFYManagerImagePickerCell.reuseIdentifierStr, for: indexPath as IndexPath) as? OwnerFYManagerImagePickerCell
        cell?.indexPath = indexPath
        
        if model != nil || jointModel != nil {

            if indexPath.item <= buildingModel.buildingLocalImgArr.count - 1  {
                if buildingModel.buildingLocalImgArr[indexPath.item].isLocal == false {
                    cell?.image.setImage(with: buildingModel.buildingLocalImgArr[indexPath.item].imgUrl ?? "", placeholder: UIImage(named: Default_1x1))
                }else {
                    cell?.image.image = buildingModel.buildingLocalImgArr[indexPath.item].image
                }
                if buildingModel.buildingLocalImgArr[indexPath.item].isMain == true {
                    cell?.mainTags.isHidden = true
                }else {
                    cell?.mainTags.isHidden = false
                }
                cell?.closeBtnClickClouse = { [weak self] (index) in
                    self?.request_deleteFCZImgApp(index: index)
                }
                
                cell?.setMainPicClouse = { [weak self] (index) in
                    self?.setMainPic(index: index)
                }
                
            }else {
                cell?.image.image = UIImage.init(named: "addImgBg")
                cell?.mainTags.isHidden = true
            }
            
            if indexPath.item == buildingModel.buildingLocalImgArr.count {
                cell?.closeBtn.isHidden = true
            }else {
                cell?.closeBtn.isHidden = false
            }
        }else {

            if indexPath.item <= FYModel.buildingLocalImgArr.count - 1  {
                if FYModel.buildingLocalImgArr[indexPath.item].isLocal == false {
                    cell?.image.setImage(with: FYModel.buildingLocalImgArr[indexPath.item].imgUrl ?? "", placeholder: UIImage(named: Default_1x1))
                }else {
                    cell?.image.image = FYModel.buildingLocalImgArr[indexPath.item].image
                }
                if FYModel.buildingLocalImgArr[indexPath.item].isMain == true {
                    cell?.mainTags.isHidden = true
                }else {
                    cell?.mainTags.isHidden = false
                }
                cell?.closeBtnClickClouse = { [weak self] (index) in
                    self?.request_deleteFCZImgApp(index: index)
                }
                
                cell?.setMainPicClouse = { [weak self] (index) in
                    self?.setMainPic(index: index)
                }
                
            }else {
                cell?.image.image = UIImage.init(named: "addImgBg")
                cell?.mainTags.isHidden = true
            }
            
            if indexPath.item == FYModel.buildingLocalImgArr.count {
                cell?.closeBtn.isHidden = true
            }else {
                cell?.closeBtn.isHidden = false
            }
        }
        return cell ?? OwnerFYManagerImagePickerCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if model != nil || jointModel != nil {
            
            if indexPath.item == buildingModel.buildingLocalImgArr.count {
                if indexPath.item < ownerBuildingImageNumber_9 {
                    //                if self.imgSelectClickBlock != nil {
                    //                    self.imgSelectClickBlock!(ownerBuildingImageNumber_9 - buildingModel.buildingLocalImgArr.count)
                    //                }
                    selectFCZPicker()
                }else {
                    AppUtilities.makeToast("最多可选择\(ownerBuildingImageNumber_9)张图片")
                }
            }
        }else {
            
            if indexPath.item == FYModel.buildingLocalImgArr.count {
                if indexPath.item < ownerBuildingImageNumber_9 {
                    //                if self.imgSelectClickBlock != nil {
                    //                    self.imgSelectClickBlock!(ownerBuildingImageNumber_9 - FYModel.buildingLocalImgArr.count)
                    //                }
                    selectFCZPicker()
                }else {
                    AppUtilities.makeToast("最多可选择\(ownerBuildingImageNumber_9)张图片")
                }
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
            }else if jointIndepentOfficeModel != nil {
                header?.titleLabel.attributedText = jointIndepentOfficeModel?.getNameFormType(type: jointIndepentOfficeModel?.type ?? OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeBuildingImage)
                header?.descLabel.text = jointIndepentOfficeModel?.getPalaceHolderFormType(type: jointIndepentOfficeModel?.type ?? OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeBuildingImage)
            }else if jointOpenStationModel != nil {
                header?.titleLabel.attributedText = jointOpenStationModel?.getNameFormType(type: jointOpenStationModel?.type ?? OwnerBuildingJointOpenStationType.OwnerBuildingJointOpenStationTypeBuildingImage)
                header?.descLabel.text = jointOpenStationModel?.getPalaceHolderFormType(type: jointOpenStationModel?.type ?? OwnerBuildingJointOpenStationType.OwnerBuildingJointOpenStationTypeBuildingImage)
            }
            

            return header ?? UICollectionReusableView()
        }
        
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: kWidth, height: 68)
    }
}

