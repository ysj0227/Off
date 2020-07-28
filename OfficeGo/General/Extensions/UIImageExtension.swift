//
//  UIImageExtension.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 Senwei. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    static func create(with color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImage {
    
    //将图片裁剪成指定比例（多余部分自动删除）
    func crop(ratio: CGFloat) -> UIImage {
        //计算最终尺寸
        var newSize:CGSize!
        if size.width/size.height > ratio {
            newSize = CGSize(width: size.height * ratio, height: size.height)
        }else{
            newSize = CGSize(width: size.width, height: size.width / ratio)
        }
        
        ////图片绘制区域
        var rect = CGRect.zero
        rect.size.width  = size.width
        rect.size.height = size.height
        rect.origin.x    = (newSize.width - size.width ) / 2.0
        rect.origin.y    = (newSize.height - size.height ) / 2.0
        
        //绘制并获取最终图片
        UIGraphicsBeginImageContext(newSize)
        draw(in: rect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
    /**
     *  等比率缩放
     */
    func scaleImage(scaleSize:CGFloat) -> UIImage {
        //let reSize = CGSize(width:self.size.width * scaleSize,height:self.size.height * scaleSize)
        let reSize = CGSize(width:200,height:200)
        return reSizeImage(reSize: reSize)
    }
    
    /**
     *  重设图片大小
     */
    func reSizeImage(reSize:CGSize) -> UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,0.7)
        self.draw(in: CGRect(x:0,y:0,width:reSize.width,height:reSize.height))
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return reSizeImage
    }
    
    func getNewSize() ->CGSize{
        var width = self.size.width
        var height = self.size.height
        SSLog("图片原始尺寸比例----width=\(width)--height=\(height)")
        let boundary:CGFloat = maxImgWidthOrHeight_1500
        guard width > boundary && height > boundary else {
            return CGSize(width: width, height: height)
        }
//        if height > maxImgWidthOrHeight || width > maxImgWidthOrHeight {
//            if width > height {
//                width = maxImgWidthOrHeight
//                height = maxImgWidthOrHeight * widthMaxScale
//
//            }else {
//                height = maxImgWidthOrHeight
//                width = maxImgWidthOrHeight * heightMaxScale
//            }
//        }
        let x = max(width, height) / boundary
        if width > height {
            width = boundary
            height = height / x
        } else {
            height = boundary
            width = width / x
        }
        return CGSize(width: width, height: height)
    }
    
    
    ///业主 - 认证图片处理 - 把图片处理为宽高最高为1500
    func resizeMax1500Image() -> UIImage? {
        let newSize = getNewSize()
        let rect = CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContext(newSize)
        var newImage = UIImage(cgImage: self.cgImage!, scale: 1, orientation: self.imageOrientation)
        newImage.draw(in: rect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        SSLog("图片裁剪尺寸比例----width=\(newImage.size.width)--height=\(newImage.size.height)")
        return newImage
    }
}
