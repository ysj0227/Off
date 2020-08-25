//
//  LBXScanViewController.swift
//  swiftScan
//
//  Created by lbxia on 15/12/8.
//  Copyright © 2015年 xialibing. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

public protocol LBXScanViewControllerDelegate: class {
     func scanFinished(scanResult: LBXScanResult, error: String?)
}

public protocol QRRectDelegate {
    func drawwed()
}

class LBXScanViewController: BaseViewController {
    
    // 返回扫码结果，也可以通过继承本控制器，改写该handleCodeResult方法即可
    open weak var scanResultDelegate: LBXScanViewControllerDelegate?

    open var delegate: QRRectDelegate?

    open var scanObj: LBXScanWrapper?

    open var scanStyle: LBXScanViewStyle? = LBXScanViewStyle()

    open var qRScanView: LBXScanView?

    // 启动区域识别功能
    open var isOpenInterestRect = false

    // 识别码的类型
    public var arrayCodeType: [AVMetadataObject.ObjectType]?

    // 是否需要识别后的当前图像
    public var isNeedCodeImage = false

    // 相机启动提示文字
    public var readyString: String! = "loading"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if scanObj != nil {

            // 开始扫描动画
            startScanFunc()
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        // [self.view addSubview:_qRScanView];
        view.backgroundColor = UIColor.black
        edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        
        drawScanView()
        perform(#selector(LBXScanViewController.startScan), with: nil, afterDelay: 0.3)
        
        titleview = ThorNavigationView.init(type: .backTitleRight)
        titleview?.backgroundColor = kAppWhiteColor
        titleview?.leftButtonCallBack = { [weak self] in
            self?.leftBtnClick()
        }
        titleview?.titleLabel.text = "扫一扫"
        view.addSubview(titleview ?? ThorNavigationView.init(type: .backTitleRight))
        
    }
    
    override func leftBtnClick() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    open func setNeedCodeImage(needCodeImg: Bool) {
        isNeedCodeImage = needCodeImg
    }

    // 设置框内识别
    open func setOpenInterestRect(isOpen: Bool) {
        isOpenInterestRect = isOpen
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @objc open func startScan() {
        if scanObj == nil {
            var cropRect = CGRect.zero
            if isOpenInterestRect {
                cropRect = LBXScanView.getScanRectWithPreView(preView: view, style: scanStyle!)
            }

            // 指定识别几种码
            if arrayCodeType == nil {
                arrayCodeType = [AVMetadataObject.ObjectType.qr as NSString,
                                 AVMetadataObject.ObjectType.ean13 as NSString,
                                 AVMetadataObject.ObjectType.code128 as NSString] as [AVMetadataObject.ObjectType]
            }

            scanObj = LBXScanWrapper(videoPreView: view,
                                     objType: arrayCodeType!,
                                     isCaptureImg: isNeedCodeImage,
                                     cropRect: cropRect,
                                     success: { [weak self] (arrayResult) -> Void in
                                         guard let strongSelf = self else {
                                             return
                                         }
                                         // 停止扫描动画
                                         strongSelf.qRScanView?.stopScanAnimation()
                                         strongSelf.handleCodeResult(arrayResult: arrayResult)
            })
        }
        
        // 结束相机等待提示
        qRScanView?.deviceStopReadying()
        
        startScanFunc()
    }
    
    func startScanFunc() {
        // 开始扫描动画
        qRScanView?.startScanAnimation()

        // 相机运行
        scanObj?.start()
    }
    
    open func drawScanView() {
        if qRScanView == nil {
            qRScanView = LBXScanView(frame: CGRect(x: 0, y: kNavigationHeight, width: view.width, height: view.height + kNavigationHeight), vstyle: scanStyle!)
            view.addSubview(qRScanView!)
            delegate?.drawwed()
        }
        qRScanView?.deviceStartReadying(readyStr: readyString)
    }
    

    /**
     处理扫码结果，如果是继承本控制器的，可以重写该方法,作出相应地处理，或者设置delegate作出相应处理
     */
    open func handleCodeResult(arrayResult: [LBXScanResult]) {
//        guard let delegate = scanResultDelegate else {
//            fatalError("you must set scanResultDelegate or override this method without super keyword")
//        }
//        navigationController?.popViewController(animated: true)
//        if let result = arrayResult.first {
//            delegate.scanFinished(scanResult: result, error: nil)
//        } else {
//            let result = LBXScanResult(str: nil, img: nil, barCodeType: nil, corner: nil)
//            delegate.scanFinished(scanResult: result, error: "no scan result")
//        }
        if let result = arrayResult.first {
            dealScanStr(result: result)
        }
    }
    
    func dealScanStr(result: LBXScanResult) {
        
        NSLog("scanResult:\(result)")
        
        if result.strScanned?.hasPrefix("http") ?? false {
            
            let vc = OwnerScanLoginSuccessViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let alert = SureAlertView(frame: self.view.frame)
             alert.isHiddenVersionCancel = true
            alert.bottomBtnView.rightSelectBtn.setTitle("重新扫码", for: .normal)
            var descStr: String?
            if let strScan = result.strScanned {
                descStr = "扫描结果为：" + "\n" + strScan
            }
            alert.ShowAlertView(withalertType: AlertType.AlertTypeVersionUpdate, title: "二维码不符合规则，请重新扫码", descMsg: descStr ?? "" , cancelButtonCallClick: {

             }) { [weak self] in

                alert.selfRemove()

                // 开始扫描动画
                self?.startScanFunc()
             }
        }

    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        qRScanView?.stopScanAnimation()
        scanObj?.stop()
    }
    
    @objc open func openPhotoAlbum() {
        LBXPermissions.authorizePhotoWith { [weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true, completion: nil)
        }
    }
}

//MARK: - 图片选择代理方法
extension LBXScanViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: -----相册选择图片识别二维码 （条形码没有找到系统方法）
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        guard let image = editedImage ?? originalImage else {
            showMsg(title: nil, message: NSLocalizedString("Identify failed", comment: "Identify failed"))
            return
        }
        let arrayResult = LBXScanWrapper.recognizeQRImage(image: image)
        if !arrayResult.isEmpty {
            handleCodeResult(arrayResult: arrayResult)
        }
    }
    
}

//MARK: - 私有方法
private extension LBXScanViewController {
    
    func showMsg(title: String?, message: String?) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
