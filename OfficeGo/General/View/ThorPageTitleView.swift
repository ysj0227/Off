//
//  OfficeGoPageTitleView.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import HandyJSON
import RxSwift

class ThorPageTitleModel: HandyJSON {
    var text: String?
    var width: CGFloat = 0
    required init() {}
}

class ThorPageTitleView: UIView {
    
    var titles: [String?]? {
        didSet {
            if let data = titles {
                dataSource.removeAll()
                for str in data {
                    let model = ThorPageTitleModel()
                    model.text = NSLocalizedString(str ?? "", comment: "")
                    model.width = (model.text?.boundingRect(with: CGSize(width: 300, height: 65), font: .appBold(18)).width ?? 0)
                    dataSource.append(model)
                }
                selectedLine.isHidden = false
                collectionView.reloadData()
            } else {
                collectionView.snp.updateConstraints { (make) in
                    make.height.equalTo(0)
                }
            }
        }
    }
    @objc dynamic var selectedIndex: Int = 0 {
        didSet {
            if selectedIndex >= contentViewControllers.count{
                return
            }
            let indexPath = IndexPath(item: selectedIndex, section: 0)
            selectedCell = collectionView.cellForItem(at: indexPath)
            collectionView.reloadData()
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            scrollView.setContentOffset(CGPoint(x: CGFloat(selectedIndex) * scrollView.width, y: scrollView.contentOffset.y), animated: true)
            let vc = contentViewControllers[selectedIndex]
            if vc.parent == nil {
                fatherVC?.addChild(vc)
                vc.beginAppearanceTransition(true, animated: false)
                contentView.addSubview(vc.view)
                vc.endAppearanceTransition()
                vc.didMove(toParent: fatherVC)
                vc.view.snp.makeConstraints { (make) in
                    make.leading.equalToSuperview().inset(self.width * CGFloat(selectedIndex))
                    make.top.equalToSuperview()
                    make.size.equalTo(CGSize(width: self.width * CGFloat(selectedIndex), height: self.height - 40))
                }
                vc.view.layoutIfNeeded()
            }
            if selectedIndex == 1 {
                //TODO:
            }
        }
    }
    @objc dynamic var contentSize: CGSize = CGSize.zero {
        didSet {
            scrollView.contentSize = contentSize
            scrollView.isPagingEnabled = true
            scrollView.alwaysBounceVertical = false
            scrollView.showsVerticalScrollIndicator = false
        }
    }
    
    var fatherVC: UIViewController?
    
    fileprivate var dispseBag = DisposeBag()
    fileprivate var scrollView = UIScrollView()
    fileprivate var contentView = UIView()
    fileprivate var contentViewControllers = [BaseViewController]()
    fileprivate var dataSource = [ThorPageTitleModel]()
    fileprivate let cellIdentifier = "ThorPageTitleCell"
    fileprivate var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_999999
        return view
    }()
    fileprivate var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 20)
        return layout
    }()
    fileprivate var selectedLine: UIView = {
        let line = UIView()
        line.backgroundColor = kAppColor_FF9600
        line.layer.zPosition = 10
        line.frame = CGRect(x: 0, y: 38, width: 20, height: 4)
        line.layer.cornerRadius = 2
        line.isHidden = true
        return line
    }()
    fileprivate var selectedCell: UICollectionViewCell? {
        didSet {
            if let cell = selectedCell {
                UIView.animate(withDuration: 0.25) {
                    self.selectedLine.center = cell.center
                    self.selectedLine.bottom = self.collectionView.height
                }
            }
        }
    }
    fileprivate lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.addSubview(selectedLine)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.register(ThorPageTitleCell.self, forCellWithReuseIdentifier: cellIdentifier)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        addSubview(separatorLine)
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.delegate = self
        collectionView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        separatorLine.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(2)
            make.top.equalTo(collectionView.snp.bottom)
        }
        scrollView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(separatorLine.snp.bottom)
        }
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(1.0)
        }
        
    }
    
    func addContentViewController(_ viewController: BaseViewController) {
        contentViewControllers.append(viewController)
        contentView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(contentViewControllers.count)
        }
        if contentViewControllers.count == 1 {
            fatherVC?.addChild(viewController)
            viewController.beginAppearanceTransition(true, animated: true)
            contentView.addSubview(viewController.view)
            viewController.endAppearanceTransition()
            viewController.didMove(toParent: fatherVC)
            viewController.view.snp.makeConstraints { (make) in
                make.leading.equalToSuperview()
                make.top.equalToSuperview()
                var height:CGFloat = 0
                if titles != nil {
                    height = 40
                }
                make.width.equalTo(self)
                make.height.equalTo(self).offset(height)
            }
            viewController.view.layoutIfNeeded()
        }
        contentSize = CGSize(width: self.width * CGFloat(contentViewControllers.count), height: scrollView.height)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension ThorPageTitleView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         return collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let thisCell = cell as? ThorPageTitleCell
        if selectedCell == nil {
            selectedCell = thisCell
        }
        let model = dataSource[indexPath.item]
        thisCell?.titleLabel.text = model.text
        if indexPath.item == selectedIndex {
            thisCell?.isSelected = true
        } else {
            thisCell?.isSelected = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = dataSource[indexPath.item]
        return CGSize(width: model.width, height: 40)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            selectedIndex = Int(scrollView.contentOffset.x / scrollView.width)
        }
    }
}

fileprivate class ThorPageTitleCell: UICollectionViewCell {
    var titleLabel = BaseLabel.init(localTitle: nil, textColor: kAppColor_222222, textFont: .appBold(18))
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    override var isSelected: Bool {
        didSet {
            if isSelected {
                titleLabel.textColor = kAppColor_222222
            } else {
                titleLabel.textColor = kAppColor_777777
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
