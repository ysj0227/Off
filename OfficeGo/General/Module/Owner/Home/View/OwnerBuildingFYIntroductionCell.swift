
//
//  OwnerBuildingFYIntroductionCell.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/10/15.
//  Copyright © 2020 Senwei. All rights reserved.
//

import CLImagePickerTool

class OwnerBuildingFYIntroductionCell: BaseTableViewCell {

    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_14
        view.text = "户型格局简介"
        view.textColor = kAppColor_333333
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
    
    lazy var intruductionTextview: UITextView = {
        let view = UITextView()
        view.delegate = self
        view.textAlignment = .left
        view.placeholder = "简单描述该办公室的方形格局，清晰的拓或者VR能够吸引更多客服的关注"
        view.holderColor = kAppColor_btnGray_BEBEBE
        view.font = FONT_12
        view.textColor = kAppColor_666666
        view.backgroundColor = kAppClearColor
        return view
    }()
    
    lazy var numOfCharLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.font = FONT_10
        view.text = "0/100"
        view.textColor = kAppColor_666666
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

    var jointModel: OwnerBuildingJointEditConfigureModel?

    var buildingModel: FangYuanBuildingEditDetailModel = FangYuanBuildingEditDetailModel() {
        didSet {
            intruductionTextview.text = buildingModel.introduction?.introductionStr
        }
    }
    
    @objc var uploadPicModelFCZArr = [BannerModel]()  // 在实际的项目中可能用于存储图片的url
    
    lazy var fczImagePickTool: CLImagePickerTool = {
        let picker = CLImagePickerTool()
        picker.cameraOut = true
        picker.isHiddenVideo = true
        return picker
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func rowHeight() -> CGFloat {
        return 200 + ((kWidth - left_pending_space_17 * 2 - 5 * 2) / 3.0 + 10) * 4 + 68

    }
           
    func setupViews() {
        
        self.addSubview(titleLabel)
        self.addSubview(lineView)
        self.addSubview(intruductionTextview)
        self.addSubview(numOfCharLabel)
        
        addSubview(headerCollectionView)

        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.top.equalToSuperview()
            make.height.equalTo(cell_height_58)
        }
        intruductionTextview.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(-5)
            make.leading.trailing.equalToSuperview().inset(13)
            make.height.equalTo(110)
        }
        numOfCharLabel.snp.makeConstraints { (make) in
            make.top.equalTo(intruductionTextview.snp.bottom)
            make.height.equalTo(20)
            make.trailing.equalToSuperview().inset(left_pending_space_17)
        }
        headerCollectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(numOfCharLabel.snp.bottom)
            make.bottom.equalToSuperview().offset(-1)
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
        headerCollectionView.register(OwnerImgPickerCollectionViewFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "OwnerImgPickerCollectionViewFooter")

    }

}

extension OwnerBuildingFYIntroductionCell: UITextViewDelegate {
    //MARK: - TextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        //获得已输出字数与正输入字母数
        let selectRange = textView.markedTextRange
        //获取高亮部分 － 如果有联想词则解包成功
        if let selectRange = selectRange {
            let position =  textView.position(from: (selectRange.start), offset: 0)
            if (position != nil) {
                return
            }
        }
        let textContent = textView.text
        let textNum = textContent?.count
        //截取
        if textNum! > 100 {
            let index = textContent?.index((textContent?.startIndex)!, offsetBy: 100)
            let str = textContent?.substring(to: index!)
            textView.text = str
            numOfCharLabel.text = "100/100"
            buildingModel.introduction?.introductionStr = textView.text
        }
        numOfCharLabel.text = String(format: "%ld/100",textView.text.count)
    }
}

extension OwnerBuildingFYIntroductionCell {
    func selectFCZPicker() {
        var imgArr = [BannerModel]()
        fczImagePickTool.cl_setupImagePickerWith(MaxImagesCount: ownerBuildingImageNumber - uploadPicModelFCZArr.count) {[weak self] (asset,cutImage) in
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

extension OwnerBuildingFYIntroductionCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
            if indexPath.item < ownerBuildingImageNumber {
                selectFCZPicker()
            }else {
                AppUtilities.makeToast("最多可选择\(ownerBuildingImageNumber)张图片")
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
        if kind == UICollectionView.elementKindSectionFooter {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "OwnerImgPickerCollectionViewFooter", for: indexPath) as? OwnerImgPickerCollectionViewFooter
            header?.backgroundColor = kAppWhiteColor
            header?.titleLabel.adjustsFontSizeToFitWidth = true
            
            header?.titleLabel.text = "可上传9张图片，单张不大于10M，支持jpg、jpeg、png格式"

            return header ?? UICollectionReusableView()
        }
        
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: kWidth, height: 68)
    }
}

