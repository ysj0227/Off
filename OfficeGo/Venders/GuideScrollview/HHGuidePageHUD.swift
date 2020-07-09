//
//  HHGuidePageHUD.swift
//  HHGuidePageHUDExample
//
//  Created by df on 2018/1/14.
//  Copyright © 2018年 df. All rights reserved.
//

import UIKit

class HHGuidePageHUD: UIView {
    
    var imageArray:[String]?
    var guidePageView: UIScrollView!
    var imagePageControl: UIPageControl?
    
    
    // MARK: - /************************View life************************/
    /// init
    ///
    /// - Parameters:
    ///   - imageNameArray: 引导页图片数组
    ///   - isHiddenSkipButton:  跳过按钮是否隐藏
    init(imageNameArray:[String], isHiddenSkipButton: Bool) {
        let frame = CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight)
        super.init(frame: frame)
        self.imageArray = imageNameArray
        if self.imageArray == nil || self.imageArray?.count == 0 {
            return
        }
        self.addScrollView(frame: frame)
        //self.addSkipButton(isHiddenSkipButton: isHiddenSkipButton)
        self.addImages()
        self.addPageControl()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("deinit")
    }
}

// MARK: - /************************普通方法************************/
extension HHGuidePageHUD {
    func addScrollView(frame: CGRect)  {
        self.guidePageView = UIScrollView.init(frame: frame)
        guidePageView.backgroundColor = UIColor.lightGray
        guidePageView.contentSize = CGSize.init(width: kWidth * (CGFloat)((self.imageArray?.count)!), height: kHeight)
        guidePageView.bounces = false
        guidePageView.isPagingEnabled = true
        guidePageView.showsHorizontalScrollIndicator = false
        guidePageView.delegate = self
        self.addSubview(guidePageView)
    }
    // 跳过按钮
    func addSkipButton(isHiddenSkipButton: Bool) -> Void {
        if isHiddenSkipButton {
            return
        }
        let skipButton = UIButton.init(frame: CGRect.init(x: kWidth - 70 - 10, y: kStatusBarHeight + 5, width: 70, height: 30))
        skipButton.setTitle("跳过", for: .normal)
        skipButton.backgroundColor = UIColor.gray
        skipButton.setTitleColor(UIColor.white, for: .normal)
        skipButton.layer.cornerRadius = skipButton.frame.size.height * 0.5
        skipButton.addTarget(self, action: #selector(skipButtonClick), for: .touchUpInside)
        self.addSubview(skipButton)
    }
    @objc func skipButtonClick() -> Void {
        UIView.animate(withDuration: 1, animations: {
            self.alpha = 0
        }) { (finish) in
            UserTool.shared.isShowGuide = true
            self.removeFromSuperview()
        }
    }
    // 图片
    func addImages() -> Void {
        guard let imageArray = self.imageArray else {
            return
        }
        for i in 0..<imageArray.count {
            let imageView = UIImageView.init(frame: CGRect.init(x: kWidth * CGFloat(i), y: 0, width: kWidth, height: kHeight))
            imageView.contentMode = .scaleAspectFill
            let idString = (imageArray[i] as NSString).substring(from: imageArray[i].count - 3)
            if idString == "gif" {
                //imageView.image = UIImage.gifImageWithName(imageArray[i])
                self.guidePageView.addSubview(imageView)
            } else {
                imageView.image = UIImage.init(named: imageArray[i])
                self.guidePageView.addSubview(imageView)
            }
            
            // 在最后一张图片上显示开始体验按钮
            if i == imageArray.count - 1 {
                imageView.isUserInteractionEnabled = true
                let startButton = UIButton.init(frame: CGRect.init(x: kWidth*0.3, y: kHeight*0.8, width: kWidth*0.4, height: 50))
                startButton.setTitle("开始体验", for: .normal)
                startButton.layer.cornerRadius = startButton.frame.size.height * 0.5
                startButton.setTitleColor(kAppWhiteColor, for: .normal)
                startButton.backgroundColor = kAppBlueColor
                startButton.addTarget(self, action: #selector(skipButtonClick), for: .touchUpInside)
                imageView.addSubview(startButton)
            }
        }
    }
    func addPageControl() -> Void {
        // 设置引导页上的页面控制器
        self.imagePageControl = UIPageControl.init(frame: CGRect.init(x: 0, y: kHeight*0.9, width: kWidth, height: kHeight*0.1))
        self.imagePageControl?.currentPage = 0
        self.imagePageControl?.numberOfPages = self.imageArray?.count ?? 0
        self.imagePageControl?.pageIndicatorTintColor = UIColor.gray
        self.imagePageControl?.currentPageIndicatorTintColor = UIColor.white
        self.addSubview(self.imagePageControl!)
    }
}
// MARK: - /************************代理方法************************/
extension HHGuidePageHUD: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        self.imagePageControl?.currentPage = Int(page)
    }
    
}
