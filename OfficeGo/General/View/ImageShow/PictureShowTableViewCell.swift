//
//  PictureShowTableViewCell.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

//class PictureShowTableViewCell: BaseTableViewCell {
//
//
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//
//    }
//
//    func deletePicture(vc: UIViewController?, index: Int, complete: (() -> Void)?) {
//        let alertVC = UIAlertController(title: "提示", message: "确定删除此附件吗？", preferredStyle: .alert)
//        let confirm = UIAlertAction(title: "确定", style: .destructive) { [weak self] _ in
//            if (self?.isDisplayAddButton())! {
//                self?.item.arrPictures.remove(at: index)
//                self?.collectionView.reloadData()
//            } else {
//                self?.item.arrPictures.remove(at: index)
//                self?.collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
//            }
//            self?.updateHeight()
//
//            if let handler = complete {
//                handler()
//            }
//        }
//
//        let cancel = UIAlertAction(title: "取消", style: .default, handler: nil)
//        alertVC.addAction(confirm)
//        alertVC.addAction(cancel)
//        if let superVC = vc {
//            superVC.present(alertVC, animated: true, completion: nil)
//        } else {
//            superVC.present(alertVC, animated: true, completion: nil)
//        }
//    }
//
//    func isDisplayAddButton() -> Bool {
//        return self.item.arrPictures.count == Int(self.item.maxNumber)
//    }
//
//    func showImage(index: Int, isShowDelete: Bool) {
//        let cell = self.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! ZJPictureCollectionCell
//
//        var images = [SKPhoto]()
//        for image in self.item.arrPictures {
//            var photo: SKPhoto!
//            if (image as AnyObject).isKind(of: UIImage.self) {
//                photo = SKPhoto.photoWithImage(image as! UIImage)
//            }
//
//            images.append(photo)
//            photo.shouldCachePhotoURLImage = false
//        }
//        SKPhotoBrowserOptions.displayDeleteButton = isShowDelete
//        SKPhotoBrowserOptions.displayStatusbar = true
//        SKPhotoBrowserOptions.displayAction = false
//        SKPhotoBrowserOptions.displayBackAndForwardButton = false
//        let browser = SKPhotoBrowser(originImage: cell.img.image!, photos: images, animatedFromView: cell.img)
//        browser.initializePageIndex(index)
//        browser.delegate = self as SKPhotoBrowserDelegate
//        self.item.superVC.present(browser, animated: true, completion: {})
//    }
//
//
//}

//extension PictureShowTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch self.item.type {
//        case .read: // 只是展示图片，返回图片数量
//            return self.item.arrPictures.count
//        case .edit:
//            // 如果是编辑状态，图片数量满了，就不显示添加按钮
//            if self.item.arrPictures.count == Int(self.item.maxNumber) {
//                return self.item.arrPictures.count
//            } else {
//                // 图片数量没有满，显示添加按钮（+1)
//                return self.item.arrPictures.count + 1
//            }
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZJPictureCollectionCell", for: indexPath) as! ZJPictureCollectionCell
//        cell.collectionView = self.collectionView
//        switch self.item.type {
//        case .read: // 只是展示图片
//            cell.btnDelete.isHidden = true
//            cell.config(imageModel: self.item.arrPictures[indexPath.item])
//        case .edit:
//            cell.btnDelete.isHidden = false
//            // 如果是编辑状态，图片数量满了，就不显示添加按钮
//            if self.item.arrPictures.count == indexPath.item {
//                cell.btnDelete.isHidden = true
//                cell.img.image = #imageLiteral(resourceName: "picture_add")
//            } else {
//                cell.config(imageModel: self.item.arrPictures[indexPath.item])
//            }
//        }
//
//        weak var weakSelf = self
//        cell.setDeleteHandler { currentIndex in
//            weakSelf?.deletePicture(vc: nil, index: currentIndex, complete: nil)
//        }
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        switch self.item.type {
//        case .read:
//            print("查看图片")
//            self.showImage(index: indexPath.item, isShowDelete: false)
//        case .edit:
//            if self.item.arrPictures.count == indexPath.item {
//                print("添加图片")
//                let imagePickerController = ImagePickerController()
//                imagePickerController.delegate = self
//                imagePickerController.imageLimit = Int(self.item.maxNumber - CGFloat(self.item.arrPictures.count))
//                self.item.superVC.present(imagePickerController, animated: true, completion: nil)
//            } else {
//                print("查看图片，可删除")
//                self.showImage(index: indexPath.item, isShowDelete: true)
//            }
//        }
//    }
//}

// MARK: - 拍照

//extension PictureShowTableViewCell: SKPhotoBrowserDelegate {
//    func removePhoto(_ browser: SKPhotoBrowser, index: Int, reload: @escaping (() -> Void)) {
//        self.deletePicture(vc: browser, index: index) {
//            reload()
//        }
//    }
//
//    func viewForPhoto(_ browser: SKPhotoBrowser, index: Int) -> UIView? {
//        let cell = self.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! ZJPictureCollectionCell
//        return cell.img
//    }
//}
