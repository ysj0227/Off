//
//  AnimateRefreshHeader.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import MJRefresh

class AnimateRefreshHeader: MJRefreshHeader {
    
    var isLoading = false
    lazy var animateImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "loading"))
        return view
    }()
    
    override func prepare() {
        super.prepare()
        self.mj_h = 50
        addSubview(animateImageView)
        animateImageView.center = CGPoint(x: kWidth / 2, y: self.mj_h / 2)
    }
    
    override var state: MJRefreshState {
        didSet {
            if oldValue == state {
                return
            }
            switch state {
            case .idle:
                stopAnimating()
            case .pulling:
                stopAnimating()
            case .willRefresh:
                stopAnimating()
            case .refreshing:
                startAnimating()
            default:
                stopAnimating()
            }
        }
    }
    
    override var pullingPercent: CGFloat {
        didSet {
            if pullingPercent >= 1.0 {
                animateImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi * (pullingPercent-1.0))
            } else {
                let scale = pullingPercent
                animateImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
    }
    
    private func startAnimating() {
        if isLoading {
            return
        }
        isLoading = true
        animateImageView.transform = CGAffineTransform.identity
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = Double.pi * 2
        animation.duration = 1.0
        animation.repeatCount = Float(Int.max)
        animation.autoreverses = false
        animation.isRemovedOnCompletion = false
        animateImageView.layer.add(animation, forKey: "rotate")
    }
    
    private func stopAnimating() {
        if isLoading == false {
            return
        }
        isLoading = false
        animateImageView.layer.removeAllAnimations()
        self.animateImageView.transform = .identity
    }
}
