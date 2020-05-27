//
//  THTabarView.swift
//  Thor
//
//  Created by dengfeifei on 2018/9/12.
//  Copyright © 2018年 RRTV. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol SSTabBarViewDelegate: NSObjectProtocol {
    func tabbar(_ tabbar: SSTabBarView, select index: Int)
}

class SSTabBarView: UIView {
    
//    设置为直播的时候，背景为黑色。当左右滑动直播页面的时候，整个背景变成白的，滑动到中间为直播页面，又变成黑的
    func updateTabBgColor (isCenter: Bool) {
        if isCenter == true {
            backgroundColor = kAppWhiteColor
        }else {
            backgroundColor = kAppWhiteColor
        }
    }
    
    weak var delegate: SSTabBarViewDelegate?
    var items: [SSTabBarItem]
    var itemViews: [SSTabBarItemView]
    let disposeBag = DisposeBag()
    
    var currentIndex: Int! {
        didSet {
            if oldValue != currentIndex {
                guard itemViews.count > 0 else {
                    return
                }
                for index in 0..<itemViews.count  {
                    let itemView = itemViews[index]
                    itemView.isSelected = index == currentIndex
                }
            }
        }
    }
    
    init(tabbarItems: [SSTabBarItem]) {
        items = tabbarItems
        itemViews = []
        super.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: kTabBarHeight))
        reloadItems()
        backgroundColor = UIColor.init(hexString: "#FFFFFF")
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -5)
        layer.shadowOpacity = 0.2
        let tap = UITapGestureRecognizer()
        self.addGestureRecognizer(tap)
        tap.rx.event.subscribe(onNext:{[unowned self] recognizer in
            let point  = recognizer.location(in: self)
            let itemWith = kWidth / CGFloat((self.items.count))
            let index = Int(point.x) / Int(itemWith)
            if index < self.items.count {
                self.delegate?.tabbar(self, select: index)
            }
        }).disposed(by: disposeBag)
    }
    
    func reloadItems() {
        if (itemViews.count) > 0 {
            for itemView in itemViews {
                itemView.removeFromSuperview()
            }
            itemViews.removeAll()
        }
        guard items.count > 0 else {
            return
        }
        let itemWidth = kWidth / CGFloat(items.count)
        for index in 0..<items.count {
            let item = items[index]
            let itemView = SSTabBarItemView.init(item: item)
            addSubview(itemView)
            itemViews.append(itemView)
            itemView.snp.makeConstraints { (make) in
                make.width.equalTo(itemWidth)
                make.leading.equalToSuperview().offset(itemWidth * CGFloat(index));
                make.top.bottom.equalToSuperview()
            }
            itemView.isSelected = currentIndex == index
            itemView.reloadLayout()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
