//
//  BaseImageView.swift
//  OfficeGo
//
//  Created by renrenshipin on 2018/9/12.
//  Copyright © 2018年 RRTV. All rights reserved.
//

import UIKit
import Kingfisher

typealias ImageProgressHandel = ((_ received: Int64,_ total: Int64) -> Void)
typealias ImageCompletionHandel = ((_ image: Image?, _ error: NSError?, _ imageURL: URL?) -> Void)

class BaseImageView: UIImageView {
    var localImageName: String?
    
    convenience init (localImageName: String? = nil) {
        self.init()
        self.localImageName = localImageName
        self.contentMode = .scaleAspectFill
        if let imageName = localImageName {
            self.image = UIImage.init(named: imageName)
        }
    }
    
    func setImage(with urlString: String) {
        self.setImage(with: urlString, placeholder: nil)
    }
    
    func setImage(with urlString: String, placeholder: UIImage? = nil) {
        self.setImage(with: urlString, placeholder: placeholder, progress: nil)
    }
    
    func setImage(with urlString: String,
                  placeholder: UIImage? = nil,
                  progress: ImageProgressHandel? = nil) {
        self.setImage(with: urlString, placeholder: placeholder, progress: { (receivedSize, totalSize) in
            progress?(receivedSize,totalSize)
        }, completion: nil)
    }
    
    func setImage(with urlString: String,
                  placeholder: UIImage? = nil,
                  progress: ImageProgressHandel? = nil,
                  completion: ImageCompletionHandel? = nil) {
        if urlString.isBlankString == true {
            self.image = placeholder
            return
        }
        self.kf.setImage(with: URL(string: urlString), placeholder: placeholder, options: nil, progressBlock: { (receivedSize, totalSize) in
            progress?(receivedSize,totalSize)
        }) { (image, error, type, url) in
            completion?(image, error, url)
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
