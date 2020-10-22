//
//  OwnerIdCardImagePickerCell.swift
//  OfficeGo
//
//  Created by mac on 2020/7/16.
//  Copyright © 2020 Senwei. All rights reserved.
//

class OwnerIdCardImagePickerCell: BaseCollectionViewCell {
    
    @objc var closeBtnClickClouse: CloseBtnClickClouse?
    @objc var visitPhotoBtnClickClouse: VisitPhotoBtnClickClouse?
    
    let image: BaseImageView = {
        let view = BaseImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        return view
    }()
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
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {

        self.backgroundColor = kAppWhiteColor
          addSubview(bgimage)
        addSubview(image)
        image.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        bgimage.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview()
        }

    }
    
}
