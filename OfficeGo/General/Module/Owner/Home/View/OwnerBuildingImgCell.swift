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
  
        self.contentView.addSubview(headerCollectionView)
        self.contentView.addSubview(lineView)
        
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
        
        
        ///1楼图片2视频3房源图片4认证文件夹
        params["filedirType"] = UploadImgOrVideoEnum.buildingImage.rawValue as AnyObject?

        
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
        
        
        ///1楼图片2视频3房源图片
        params["filedirType"] = UploadImgOrVideoEnum.fyImage.rawValue as AnyObject?

        
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
                    selectFCZPicker()
                }else {
                    AppUtilities.makeToast("最多可选择\(ownerBuildingImageNumber_9)张图片")
                }
            }
        }else {
            
            if indexPath.item == FYModel.buildingLocalImgArr.count {
                if indexPath.item < ownerBuildingImageNumber_9 {
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




//MARK: 新认证 - 图片选择cell
class OwnerNewIdentifyImgCell: BaseCollectionViewCell {
        
    var imgSelectClickBlock:((_ usermodel: OwnerIdentifyUserModel) -> Void)?

    lazy var fczImagePickTool: CLImagePickerTool = {
        let picker = CLImagePickerTool()
        picker.cameraOut = true
        picker.isHiddenVideo = true
        return picker
    }()
    
    lazy var rejectImg: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "redLine")
        view.contentMode = .scaleToFill
        return view
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
        
    ///认证数据展示
    var userModel: OwnerIdentifyUserModel = OwnerIdentifyUserModel() {
        didSet {
            reloadData()
        }
    }
    
    var model: OwnerNewIedntifyConfigureModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupViews() {
  
        self.contentView.addSubview(headerCollectionView)
        self.contentView.addSubview(rejectImg)
        
        rejectImg.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(10)
        }
        
        
        headerCollectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
        headerCollectionView.register(OwnerNewIdtnfifyImagePickerCell.self, forCellWithReuseIdentifier: OwnerNewIdtnfifyImagePickerCell.reuseIdentifierStr)
        headerCollectionView.register(OwnerImgPickerCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "OwnerImgPickerCollectionViewHeader")
    }
    
    
    func reloadData() {
        headerCollectionView.reloadData()
    }
    
}

extension OwnerNewIdentifyImgCell {
    
    
    func loadVC() {
        guard let block = imgSelectClickBlock else {
            return
        }
        block(userModel)
    }
    
    //MARK: 上传房产证 - 拍照
    func selectFCZPicker() {
        
        var imgArr = [BannerModel]()
        var imggggArr = [UIImage]()
        fczImagePickTool.cl_setupImagePickerWith(MaxImagesCount: ownerBuildingImageNumber_9 - userModel.fczLocalLocalImgArr.count, superVC: nil) {[weak self] (asset,cutImage) in
            // 内部提供的方法可以异步获取图片，同步获取的话时间比较长，不建议！，如果是iCloud中的照片就直接从icloud中下载，下载完成后返回图片,同时也提供了下载失败的方法
            CLImagePickerTool.convertAssetArrToOriginImage(assetArr: asset, scale: 0.1, successClouse: {[weak self] (image,assetItem) in
                let img = image.resizeMax1500Image()

                let fczBannerModel = BannerModel()
                fczBannerModel.isLocal = true
                fczBannerModel.image = img

                imgArr.append(fczBannerModel)
                imggggArr.append(img ?? UIImage())
                }, failedClouse: { () in

            })
            //self?.uploadFCZImg(imgArr: imggggArr, existImgCount: self?.userModel.fczLocalLocalImgArr.count ?? 0)
            //房产证
            self?.userModel.fczLocalLocalImgArr.append(contentsOf: imgArr)
            self?.loadVC()
        }
    }

    //MARK: 上传房产证
    func uploadFCZImg(imgArr: [UIImage], existImgCount: Int) {
        
        var params = [String:AnyObject]()
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        
        ///1楼图片2视频3房源图片4认证文件夹
        params["filedirType"] = UploadImgOrVideoEnum.newIdentify.rawValue as AnyObject?
        
        
        SSNetworkTool.SSFYManager.request_uploadResourcesUrl(params: params, imagesArray: imgArr, success: {[weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<BannerModel>.deserializeModelArrayFrom(json: JSON(response["data"] ?? "").rawString() ?? "", designatedPath: "urls") {
                
                if decoratedArray.count == imgArr.count {
                    var count = 0
                    for model in decoratedArray {
                        if count < decoratedArray.count {
                            
                            weakSelf.userModel.fczLocalLocalImgArr[existImgCount + count].imgUrl = model?.url
                            count += 1
                        }
                    }
                }
            }
            
        }, failure: { (error) in
            
        }) { (code, message) in
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    
    
    //MARK: 上传营业执照 - 拍照
    func selectYinyePicker() {
        
        var imgArr = [BannerModel]()
        var imggggArr = [UIImage]()
        fczImagePickTool.cl_setupImagePickerWith(MaxImagesCount: ownerBuildingImageNumber_9 - userModel.businessLicenseLocalImgArr.count, superVC: nil) {[weak self] (asset,cutImage) in
            // 内部提供的方法可以异步获取图片，同步获取的话时间比较长，不建议！，如果是iCloud中的照片就直接从icloud中下载，下载完成后返回图片,同时也提供了下载失败的方法
            CLImagePickerTool.convertAssetArrToOriginImage(assetArr: asset, scale: 0.1, successClouse: {[weak self] (image,assetItem) in
                let img = image.resizeMax1500Image()

                let fczBannerModel = BannerModel()
                fczBannerModel.isLocal = true
                fczBannerModel.image = img

                imgArr.append(fczBannerModel)
                imggggArr.append(img ?? UIImage())
                }, failedClouse: { () in

            })
            //self?.uploadYingyeImg(imgArr: imggggArr, existImgCount: self?.userModel.businessLicenseLocalImgArr.count ?? 0)
            //房产证
            self?.userModel.businessLicenseLocalImgArr.append(contentsOf: imgArr)
            self?.loadVC()
        }
    }
    
    //MARK: 上传营业执照
    func uploadYingyeImg(imgArr: [UIImage], existImgCount: Int) {
        
        var params = [String:AnyObject]()
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        
        ///1楼图片2视频3房源图片4认证文件夹
        params["filedirType"] = UploadImgOrVideoEnum.newIdentify.rawValue as AnyObject?
        
        
        SSNetworkTool.SSFYManager.request_uploadResourcesUrl(params: params, imagesArray: imgArr, success: {[weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<BannerModel>.deserializeModelArrayFrom(json: JSON(response["data"] ?? "").rawString() ?? "", designatedPath: "urls") {
                
                if decoratedArray.count == imgArr.count {
                    var count = 0
                    for model in decoratedArray {
                        if count < decoratedArray.count {
                            
                            weakSelf.userModel.businessLicenseLocalImgArr[existImgCount + count].imgUrl = model?.url
                            count += 1
                        }
                    }
                }
            }
            
        }, failure: { (error) in
            
        }) { (code, message) in
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    
    //MARK: 上传补充信息 - 拍照
    func selectAddtionalPicker() {
        
        var imgArr = [BannerModel]()
        var imggggArr = [UIImage]()
        fczImagePickTool.cl_setupImagePickerWith(MaxImagesCount: ownerBuildingImageNumber_9 - userModel.addtionalLocalImgArr.count, superVC: nil) {[weak self] (asset,cutImage) in
            // 内部提供的方法可以异步获取图片，同步获取的话时间比较长，不建议！，如果是iCloud中的照片就直接从icloud中下载，下载完成后返回图片,同时也提供了下载失败的方法
            CLImagePickerTool.convertAssetArrToOriginImage(assetArr: asset, scale: 0.1, successClouse: {[weak self] (image,assetItem) in
                let img = image.resizeMax1500Image()

                let fczBannerModel = BannerModel()
                fczBannerModel.isLocal = true
                fczBannerModel.image = img

                imgArr.append(fczBannerModel)
                imggggArr.append(img ?? UIImage())
                }, failedClouse: { () in

            })
            //self?.uploadAddtionalImg(imgArr: imggggArr, existImgCount: self?.userModel.addtionalLocalImgArr.count ?? 0)
            //房产证
            self?.userModel.addtionalLocalImgArr.append(contentsOf: imgArr)
            self?.loadVC()
        }
    }
    //MARK: 上传补充信息
    func uploadAddtionalImg(imgArr: [UIImage], existImgCount: Int) {
        
        var params = [String:AnyObject]()
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        
        ///1楼图片2视频3房源图片4认证文件夹
        params["filedirType"] = UploadImgOrVideoEnum.newIdentify.rawValue as AnyObject?
        
        
        SSNetworkTool.SSFYManager.request_uploadResourcesUrl(params: params, imagesArray: imgArr, success: {[weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<BannerModel>.deserializeModelArrayFrom(json: JSON(response["data"] ?? "").rawString() ?? "", designatedPath: "urls") {
                
                if decoratedArray.count == imgArr.count {
                    var count = 0
                    for model in decoratedArray {
                        if count < decoratedArray.count {
                            
                            weakSelf.userModel.addtionalLocalImgArr[existImgCount + count].imgUrl = model?.url
                            count += 1
                        }
                    }
                }
            }
            
        }, failure: { (error) in
            
        }) { (code, message) in
            
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
    func request_deleteFCZImgApp(type:OwnerNewIdentifyType, index: Int) {

        if type == .OwnerNewIdentifyTypeUploadFangchanzheng {
            if userModel.fczLocalLocalImgArr[index].isLocal == true {
                userModel.fczLocalLocalImgArr.remove(at: index)
                loadVC()
            }else {
                userModel.fczLocalLocalImgArr.remove(at: index)
                loadVC()
            }
        }else if type == .OwnerNewIdentifyTypeYinYeOrIdCard {
            if userModel.businessLicenseLocalImgArr[index].isLocal == true {
                userModel.businessLicenseLocalImgArr.remove(at: index)
                loadVC()
            }else {
                userModel.businessLicenseLocalImgArr.remove(at: index)
                loadVC()
            }
        }else if type == .OwnerNewIdentifyTypeAddtional {
            if userModel.addtionalLocalImgArr[index].isLocal == true {
                userModel.addtionalLocalImgArr.remove(at: index)
                loadVC()
            }else {
                userModel.addtionalLocalImgArr.remove(at: index)
                loadVC()
            }
        }
    }
    
}

extension OwnerNewIdentifyImgCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if model?.type == .OwnerNewIdentifyTypeUploadFangchanzheng {
            return userModel.fczLocalLocalImgArr.count + 1
        }else if model?.type == .OwnerNewIdentifyTypeYinYeOrIdCard {
            return userModel.businessLicenseLocalImgArr.count + 1
        }else if model?.type == .OwnerNewIdentifyTypeAddtional {
            return userModel.addtionalLocalImgArr.count + 1
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OwnerNewIdtnfifyImagePickerCell.reuseIdentifierStr, for: indexPath as IndexPath) as? OwnerNewIdtnfifyImagePickerCell
        cell?.indexPath = indexPath
        if model?.type == .OwnerNewIdentifyTypeUploadFangchanzheng {
            if indexPath.item <= userModel.fczLocalLocalImgArr.count - 1  {
                if userModel.fczLocalLocalImgArr[indexPath.item].isLocal == false {
                    cell?.image.setImage(with: userModel.fczLocalLocalImgArr[indexPath.item].imgUrl ?? "", placeholder: UIImage(named: Default_1x1))
                }else {
                    cell?.image.image = userModel.fczLocalLocalImgArr[indexPath.item].image
                }
                cell?.closeBtnClickClouse = { [weak self] (index) in
                    self?.request_deleteFCZImgApp(type: .OwnerNewIdentifyTypeUploadFangchanzheng, index: index)
                }
                
            }else {
                cell?.image.image = UIImage.init(named: "addImgBg")
            }
            
            if indexPath.item == userModel.fczLocalLocalImgArr.count {
                cell?.closeBtn.isHidden = true
            }else {
                cell?.closeBtn.isHidden = false
            }
        }else if model?.type == .OwnerNewIdentifyTypeYinYeOrIdCard {
            if indexPath.item <= userModel.businessLicenseLocalImgArr.count - 1  {
                if userModel.businessLicenseLocalImgArr[indexPath.item].isLocal == false {
                    cell?.image.setImage(with: userModel.businessLicenseLocalImgArr[indexPath.item].imgUrl ?? "", placeholder: UIImage(named: Default_1x1))
                }else {
                    cell?.image.image = userModel.businessLicenseLocalImgArr[indexPath.item].image
                }
                cell?.closeBtnClickClouse = { [weak self] (index) in
                    self?.request_deleteFCZImgApp(type: .OwnerNewIdentifyTypeYinYeOrIdCard, index: index)
                }
                
            }else {
                cell?.image.image = UIImage.init(named: "addImgBg")
            }
            
            if indexPath.item == userModel.businessLicenseLocalImgArr.count {
                cell?.closeBtn.isHidden = true
            }else {
                cell?.closeBtn.isHidden = false
            }
        }else if model?.type == .OwnerNewIdentifyTypeAddtional {
            if indexPath.item <= userModel.addtionalLocalImgArr.count - 1  {
                if userModel.addtionalLocalImgArr[indexPath.item].isLocal == false {
                    cell?.image.setImage(with: userModel.addtionalLocalImgArr[indexPath.item].imgUrl ?? "", placeholder: UIImage(named: Default_1x1))
                }else {
                    cell?.image.image = userModel.addtionalLocalImgArr[indexPath.item].image
                }
                cell?.closeBtnClickClouse = { [weak self] (index) in
                    self?.request_deleteFCZImgApp(type: .OwnerNewIdentifyTypeAddtional, index: index)
                }
                
            }else {
                cell?.image.image = UIImage.init(named: "addImgBg")
            }
            
            if indexPath.item == userModel.addtionalLocalImgArr.count {
                cell?.closeBtn.isHidden = true
            }else {
                cell?.closeBtn.isHidden = false
            }
        }

        return cell ?? OwnerNewIdtnfifyImagePickerCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if model != nil {

            if model?.type == .OwnerNewIdentifyTypeUploadFangchanzheng {
                if indexPath.item == userModel.fczLocalLocalImgArr.count {
                    if indexPath.item < ownerBuildingImageNumber_9 {
                        selectFCZPicker()
                    }else {
                        AppUtilities.makeToast("最多可选择\(ownerBuildingImageNumber_9)张图片")
                    }
                }
            }else if model?.type == .OwnerNewIdentifyTypeYinYeOrIdCard {
                if indexPath.item == userModel.businessLicenseLocalImgArr.count {
                    if indexPath.item < ownerBuildingImageNumber_9 {
                        selectYinyePicker()
                    }else {
                        AppUtilities.makeToast("最多可选择\(ownerBuildingImageNumber_9)张图片")
                    }
                }
            }else if model?.type == .OwnerNewIdentifyTypeAddtional {
                if indexPath.item == userModel.addtionalLocalImgArr.count {
                    if indexPath.item < ownerBuildingImageNumber_9 {
                        selectAddtionalPicker()
                    }else {
                        AppUtilities.makeToast("最多可选择\(ownerBuildingImageNumber_9)张图片")
                    }
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
            if model != nil {
                header?.titleLabel.attributedText = model?.getNameFormType(type: model?.type ?? .OwnerNewIdentifyTypeUploadFangchanzheng)
                header?.descLabel.text = model?.getDescFormType(type: model?.type ?? .OwnerNewIdentifyTypeUploadFangchanzheng)
            }
            

            return header ?? UICollectionReusableView()
        }
        
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: kWidth, height: 68)
    }
}


class OwnerNewIdCardImagePickerView: UIView {
    
    @objc var clickIDCardBlock: CloseBtnClickClouse?
    
    let image: BaseImageView = {
        let view = BaseImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        return view
    }()
    @objc private func tapTextMessage(_ tap: UITapGestureRecognizer) {
        guard let blockk = clickIDCardBlock else {
            return
        }
        blockk(1)
    }
    let bgimage: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = kAppClearColor
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.image = UIImage.init(named: "idcardBgFront")
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {

        self.backgroundColor = kAppWhiteColor
        self.addSubview(bgimage)
        self.addSubview(image)
        image.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        bgimage.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapTextMessage(_:)))
        singleTap.numberOfTapsRequired = 1
        image.addGestureRecognizer(singleTap)
    }
    
}


//MARK: 新认证 - 图片选择cell
class OwnerNewPersonIDCardIdentifyImgCell: BaseCollectionViewCell {
        
    var presentVC: BaseViewController?
    
    lazy var fczImagePickTool: CLImagePickerTool = {
        let picker = CLImagePickerTool()
        picker.cameraOut = true
        picker.isHiddenVideo = true
        return picker
    }()
    
    lazy var rejectImg: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "redLine")
        view.contentMode = .scaleToFill
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = FONT_14
        view.textColor = kAppColor_999999
        return view
    }()
    
    lazy var descLabel: UILabel = {
        let view = UILabel()
        view.font = FONT_12
        view.textColor = kAppColor_btnGray_BEBEBE
        return view
    }()

    var frontView: OwnerNewIdCardImagePickerView = {
        let view = OwnerNewIdCardImagePickerView()
        view.bgimage.image = UIImage.init(named: "idcardBgFront")
        return view
    }()
    
    var reverseView: OwnerNewIdCardImagePickerView = {
        let view = OwnerNewIdCardImagePickerView()
        view.bgimage.image = UIImage.init(named: "idcardBgFBack")
        return view
    }()
        
    ///认证数据展示
    var userModel: OwnerIdentifyUserModel?
    
    class func rowHeight() -> CGFloat {
        let width = (kWidth - left_pending_space_17 * 3) / 2.0 - 1
        let height = width * 3 / 4.0
        return 68 + height + 20
    }
    
    var model: OwnerNewIedntifyConfigureModel? {
        didSet {
            titleLabel.attributedText = model?.getNameFormType(type: model?.type ?? .OwnerNewIdentifyTypeYinYeOrIdCard)
            descLabel.text = model?.getDescFormType(type: model?.type ?? .OwnerNewIdentifyTypeYinYeOrIdCard)
            
            if let imgUrl = userModel?.frontBannerModel?.imgUrl {
                if imgUrl.count > 0 {
                    frontView.image.setImage(with: imgUrl, placeholder: UIImage(named: Default_1x1))
                }else {
                    frontView.image.image = userModel?.frontBannerModel?.image
                }
            }else {
                frontView.image.image = userModel?.frontBannerModel?.image
            }
            if let imgUrl = userModel?.reverseBannerModel?.imgUrl {
                if imgUrl.count > 0 {
                    reverseView.image.setImage(with: imgUrl, placeholder: UIImage(named: Default_1x1))
                }else {
                    reverseView.image.image = userModel?.reverseBannerModel?.image
                }
            }else {
                reverseView.image.image = userModel?.reverseBannerModel?.image
            }
        }
    }
    
    func pickerSelectIDCard() {
        self.userModel?.isFront = false
        let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let refreshAction = UIAlertAction.init(title: "拍照", style: .default) {[weak self] (action: UIAlertAction) in
            let vc = ZKIDCardCameraController.init(type: .reverse)
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            self?.presentVC?.present(vc, animated: true, completion: nil)
        }
        let copyAction = UIAlertAction.init(title: "从手机相册选择", style: .default) {[weak self] (action: UIAlertAction) in
            let picker = CLImagePickerTool()
            picker.cameraOut = false
            picker.isHiddenVideo = true
            picker.singleImageChooseType = .singlePicture   //设置单选
            picker.singleModelImageCanEditor = false        //单选不可编辑
            picker.cl_setupImagePickerWith(MaxImagesCount: 2) {[weak self] (asset,cutImage) in
                SSLog("返回的asset数组是\(asset)")
                
                var index = asset.count // 标记失败的次数
                
                // 获取原图，异步
                // scale 指定压缩比
                // 内部提供的方法可以异步获取图片，同步获取的话时间比较长，不建议！，如果是iCloud中的照片就直接从icloud中下载，下载完成后返回图片,同时也提供了下载失败的方法
                CLImagePickerTool.convertAssetArrToOriginImage(assetArr: asset, scale: 0.1, successClouse: {[weak self] (image,assetItem) in
                    let img = image.resizeMax1500Image()
                    
                    self?.userModel?.reverseBannerModel?.imgUrl = nil
                    self?.userModel?.reverseBannerModel?.image = img?.crop(ratio: 4 / 3.0)
                    self?.reverseView.image.image = self?.userModel?.reverseBannerModel?.image
                    self?.uploadReverseImg(img: img ?? UIImage())
                    }, failedClouse: { () in
                        index = index - 1
                        //                    self?.dealImage(imageArr: imageArr, index: index)
                })
            }
        }
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (action: UIAlertAction) in
            
        }
        alertController.addAction(refreshAction)
        alertController.addAction(copyAction)
        alertController.addAction(cancelAction)
        presentVC?.present(alertController, animated: true, completion: nil)
    }
    
    func uploadReverseImg(img: UIImage) {
        
        var params = [String:AnyObject]()
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        ///1楼图片2视频3房源图片4认证
        params["filedirType"] = UploadImgOrVideoEnum.newIdentify.rawValue as AnyObject?

        
        SSNetworkTool.SSFYManager.request_uploadResourcesUrl(params: params, imagesArray: [img], success: {[weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<BannerModel>.deserializeModelArrayFrom(json: JSON(response["data"] ?? "").rawString() ?? "", designatedPath: "urls") {
                
                if decoratedArray.count >= 1 {
                    weakSelf.userModel?.reverseBannerModel?.isLocal = false
                    weakSelf.userModel?.reverseBannerModel?.imgUrl = decoratedArray[0]?.url
                }
            }
            }, failure: { (error) in
                
        }) { (code, message) in

            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    func pickerSelectIDCardFront() {
        self.userModel?.isFront = true
        let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let refreshAction = UIAlertAction.init(title: "拍照", style: .default) {[weak self] (action: UIAlertAction) in
            let vc = ZKIDCardCameraController.init(type: .front)
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            self?.presentVC?.present(vc, animated: true, completion: nil)
        }
        let copyAction = UIAlertAction.init(title: "从手机相册选择", style: .default) {[weak self] (action: UIAlertAction) in
            let picker = CLImagePickerTool()
            picker.cameraOut = false
            picker.isHiddenVideo = true
            picker.singleImageChooseType = .singlePicture   //设置单选
            picker.singleModelImageCanEditor = false        //单选不可编辑
            picker.cl_setupImagePickerWith(MaxImagesCount: 2) {[weak self] (asset,cutImage) in
                SSLog("返回的asset数组是\(asset)")
                
                var index = asset.count // 标记失败的次数
                
                // 获取原图，异步
                // scale 指定压缩比
                // 内部提供的方法可以异步获取图片，同步获取的话时间比较长，不建议！，如果是iCloud中的照片就直接从icloud中下载，下载完成后返回图片,同时也提供了下载失败的方法
                CLImagePickerTool.convertAssetArrToOriginImage(assetArr: asset, scale: 0.1, successClouse: {[weak self] (image,assetItem) in
                    let img = image.resizeMax1500Image()
                    
                    self?.userModel?.frontBannerModel?.imgUrl = nil
                    self?.userModel?.frontBannerModel?.image = img?.crop(ratio: 4 / 3.0)
                    self?.frontView.image.image = self?.userModel?.frontBannerModel?.image
                    self?.uploadFrontImg(img: img ?? UIImage())
                    }, failedClouse: { () in
                        index = index - 1
                })
            }
        }
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (action: UIAlertAction) in
            
        }
        alertController.addAction(refreshAction)
        alertController.addAction(copyAction)
        alertController.addAction(cancelAction)
        presentVC?.present(alertController, animated: true, completion: nil)
    }
    
    func uploadFrontImg(img: UIImage) {
        
        var params = [String:AnyObject]()
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        ///1楼图片2视频3房源图片4认证
        params["filedirType"] = UploadImgOrVideoEnum.newIdentify.rawValue as AnyObject?

        
        SSNetworkTool.SSFYManager.request_uploadResourcesUrl(params: params, imagesArray: [img], success: {[weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<BannerModel>.deserializeModelArrayFrom(json: JSON(response["data"] ?? "").rawString() ?? "", designatedPath: "urls") {
                
                if decoratedArray.count >= 1 {
                    weakSelf.userModel?.frontBannerModel?.isLocal = false
                    weakSelf.userModel?.frontBannerModel?.imgUrl = decoratedArray[0]?.url
                }
            }
            }, failure: { (error) in
                
        }) { (code, message) in

            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupViews() {
  
        frontView.clickIDCardBlock = { [weak self] (index) in
            self?.pickerSelectIDCardFront()
        }
        reverseView.clickIDCardBlock = { [weak self] (index) in
            self?.pickerSelectIDCard()
        }
        self.contentView.addSubview(rejectImg)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(descLabel)
        self.contentView.addSubview(frontView)
        self.contentView.addSubview(reverseView)
        
        rejectImg.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(20)
        }
                
        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.top.equalToSuperview()
            make.height.equalTo(46)
        }
        
        descLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(-15)
            make.height.equalTo(35)
        }
        
        let width = (kWidth - left_pending_space_17 * 3) / 2.0 - 1
        let height = width * 3 / 4.0
        frontView.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.top.equalTo(68)
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
        reverseView.snp.makeConstraints { (make) in
            make.trailing.equalTo(-left_pending_space_17)
            make.top.width.height.equalTo(frontView)
        }
    }
}

extension OwnerNewPersonIDCardIdentifyImgCell: ZKIDCardCameraControllerDelegate {
    func cameraDidFinishShoot(withCameraImage image: UIImage) {
        if userModel?.isFront == true {
            userModel?.frontBannerModel?.imgUrl = nil
            userModel?.frontBannerModel?.image = image.crop(ratio: 4 / 3.0)
            frontView.image.image = userModel?.frontBannerModel?.image
        }else {
            userModel?.reverseBannerModel?.imgUrl = nil
            userModel?.reverseBannerModel?.image = image.crop(ratio: 4 / 3.0)
            reverseView.image.image = userModel?.reverseBannerModel?.image
        }
    }
}
