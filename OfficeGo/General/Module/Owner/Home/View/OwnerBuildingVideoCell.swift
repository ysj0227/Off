//
//  OwnerBuildingVideoCell.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/10/10.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import WMPlayer

class OwnerBuildingVideoCell: BaseTableViewCell {
    
    @objc var closeBtnClickClouse: CloseBtnClickClouse?
    
    @objc var selectVideoClickClouse: CloseBtnClickClouse?

    let closeBtn: UIButton = {
        let view = UIButton()
        view.setImage(UIImage.init(named: "imageDeleIcon"), for: .normal)
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
        view.textColor = kAppColor_999999
        return view
    }()
    
    //视频播放view
    lazy var videoView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.image = UIImage.init(named: "videoBg")
        return view
    }()
    
    class func rowHeight() -> CGFloat {
        return 69 + (SCREEN_WIDTH - left_pending_space_17 * 2) * 3 / 4.0
    }
    
    deinit {
        wmPlayer?.pause()
        wmPlayer?.removeFromSuperview()
        wmPlayer = nil
    }
    
    func removePlayer() {
        wmPlayer?.pause()
        wmPlayer?.removeFromSuperview()
        wmPlayer = nil
    }
    
    func pausePlayer() {
        wmPlayer?.pause()
    }
    
    func releaseWMplayer() {
        pausePlayer()
        wmPlayer?.removeFromSuperview()
        wmPlayer = nil
    }
    var playerModel: WMPlayerModel = WMPlayerModel() {
        didSet {
            setPlayer()
        }
    }
    
    var wmPlayer: WMPlayer?
    
    func setPlayer() {
        wmPlayer = WMPlayer(playerModel: playerModel)
        wmPlayer?.delegate = self
        wmPlayer?.backBtnStyle = .none
        wmPlayer?.fullScreenBtn.isHidden = true
        videoView.addSubview(wmPlayer ?? WMPlayer(playerModel: playerModel))
        wmPlayer?.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
    }
    var buildingModel: FangYuanBuildingEditDetailModel = FangYuanBuildingEditDetailModel() {
        didSet {
            if buildingModel.videoUrl?.count ?? 0 > 0 {
                closeBtn.isHidden = false
                if buildingModel.videoUrl?[0].isLocal == true {
                    let videoUrl = buildingModel.videoUrl?[0].imgUrl
                    let player = WMPlayerModel()
//                    player.videoURL = URL.init(string: videoUrl ?? "")
                    player.playerItem = AVPlayerItem.init(url: URL.init(string: videoUrl ?? "")!)
                    playerModel = player
                }else {
                    if buildingModel.videoUrl?[0].imgUrl?.count ?? 0 > 0 {
                        let videoUrl = "https://img.officego.com/test/1596620185492.mp4"
                        let player = WMPlayerModel()
                        player.videoURL = URL.init(string: videoUrl ?? "")
                        playerModel = player
                    }
                }
            }else {
                closeBtn.isHidden = true
                removePlayer()
            }
        }
    }
    var model: OwnerBuildingEditConfigureModel = OwnerBuildingEditConfigureModel(types: OwnerBuildingEditType.OwnerBuildingEditTypeBuildingVideo) {
        didSet {
            titleLabel.attributedText = model.getNameFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingVideo)
            descLabel.text = model.getPalaceHolderFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingVideo)
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupViews() {
        addSubview(titleLabel)
        addSubview(descLabel)
        addSubview(videoView)
        addSubview(closeBtn)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.top.equalToSuperview()
            make.height.equalTo(46)
        }
        descLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(-15)
            make.height.equalTo(46)
        }
        videoView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.top.equalTo(descLabel.snp.bottom)
            make.height.equalTo((SCREEN_WIDTH - left_pending_space_17 * 2) * 3 / 4.0)
        }
        closeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(videoView).offset(-10)
            make.trailing.equalTo(videoView).offset(10)
            make.size.equalTo(20)
        }
        closeBtn.addTarget(self, action: #selector(clickCloseBtn(btn:)), for: .touchUpInside)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapTextMessage(_:)))
         singleTap.numberOfTapsRequired = 1
         videoView.addGestureRecognizer(singleTap)
    }
    
    /// 关闭按钮
    @objc func clickCloseBtn(btn:UIButton) {
        
        if self.closeBtnClickClouse != nil {
            self.closeBtnClickClouse!(btn.tag)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    /*!
      单击操作，跳转消息详情
      */
    @objc private func tapTextMessage(_ tap: UITapGestureRecognizer) {
        if self.selectVideoClickClouse != nil {
            self.selectVideoClickClouse!(0)
        }
    }
}

extension OwnerBuildingVideoCell: WMPlayerDelegate{
    //点击播放暂停按钮代理方法
    func wmplayer(_ wmplayer: WMPlayer!, clickedPlayOrPause playOrPauseBtn: UIButton!) {
        
    }
    //播放完毕的代理方法
    func wmplayerFinishedPlay(_ wmplayer: WMPlayer!) {
        
    }
    
    
    func wmplayer(_ wmplayer: WMPlayer!, isHiddenTopAndBottomView isHidden: Bool) {
        
    }
    
    //点击全屏按钮代理
    func wmplayer(_ wmplayer: WMPlayer!, clickedFullScreenButton fullScreenBtn: UIButton!) {
        
    }
    
    func wmplayerReady(toPlay wmplayer: WMPlayer!, wmPlayerStatus state: WMPlayerState) {
        
    }
    
}
extension OwnerBuildingVideoCell {
    func selectFCZPicker() {
        
    }
    
    
}


