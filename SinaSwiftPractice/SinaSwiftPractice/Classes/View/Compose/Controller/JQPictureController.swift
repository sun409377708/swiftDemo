//
//  JQPictureController.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/22.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit
import SVProgressHUD

private let maxImageCount = 3

let selectCellMargin: CGFloat = 4
let colCount = 3

let itemW = (ScreenWidth - (CGFloat(colCount) + 1) * selectCellMargin) / CGFloat(colCount)

private let reuseIdentifier = "Cell"

class JQPictureController: UICollectionViewController {
    
    var images: [UIImage] = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(JQPictureSelCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let imageCount = images.count
        
        let count = (imageCount == maxImageCount) ? (imageCount + 0) : (imageCount + 1)
        
        return count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! JQPictureSelCell
    
        cell.backgroundColor = UIColor.randomColor()
        
        if indexPath.item == images.count {
            cell.image = nil
        }else {
            cell.image = self.images[indexPath.item]
        }
        
        cell.delegate = self
        
        return cell
    }

}

@objc protocol JQPictureSelCellDelegate: NSObjectProtocol {
    
    @objc optional func userWillAddPic()
    
    @objc optional func userWllRemovePic(cell: JQPictureSelCell)
}

class JQPictureSelCell : UICollectionViewCell {
    
    //图片
    var image: UIImage? {
        didSet {
            addBtn.setImage(image, for: .normal)
            //设置删除按钮的隐藏与显示
            removeBtn.isHidden = image == nil
            
            //遇到透明视图时, 需要将addBtn背景图片设置nil
            let backImage: UIImage? = (image == nil ? #imageLiteral(resourceName: "compose_pic_add") : nil)
            addBtn.setBackgroundImage(backImage, for: .normal)
        }
    }
    
    //声明delegate
    weak var delegate: JQPictureSelCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        contentView.addSubview(addBtn)
        contentView.addSubview(removeBtn)
        
        addBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
        
        removeBtn.snp.makeConstraints { (make) in
            make.top.right.equalTo(self.contentView)
        }
    }
    
    //MARK: - 按钮点击
    @objc private func btnAddClick() {
        
        if self.image != nil {
            return
        }
        self.delegate?.userWillAddPic?()
    }
    
    @objc private func btnRemoveClick() {
        self.delegate?.userWllRemovePic?(cell: self)
    }
    
    private lazy var addBtn: UIButton = {
        
        let btn = UIButton()
        btn.setBackgroundImage(#imageLiteral(resourceName: "compose_pic_add"), for: .normal)
        btn.setBackgroundImage(#imageLiteral(resourceName: "compose_pic_add_highlighted"), for: .highlighted)
        
        //设置视图显示模式
        btn.imageView?.contentMode = .scaleAspectFill
        
        btn.addTarget(self, action: #selector(btnAddClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var removeBtn: UIButton = {
        
        let btn = UIButton()
        btn.setBackgroundImage(#imageLiteral(resourceName: "compose_photo_close"), for: .normal)
        btn.addTarget(self, action: #selector(btnRemoveClick), for: .touchUpInside)

        return btn
    }()
}


extension JQPictureController: JQPictureSelCellDelegate {
    
    func userWillAddPic() {
        print("添加")
        /*
         //iOS 10 之前的判断方法
         if  UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
         
         SVProgressHUD.showInfo(withStatus: "请您到->设置->新浪微博->开启相册访问权限")
         return
         }
         */
        //进入照片选择器
        let imagePicker = UIImagePickerController()
        
//        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func userWllRemovePic(cell: JQPictureSelCell) {
        
        let indexPath = collectionView?.indexPath(for: cell)
        
        self.images.remove(at: indexPath!.item)
    
        //删除时, 如果是最后一张, 则直接影藏
        self.view?.isHidden = images.count == 0
        
        self.collectionView?.reloadData()
    }
}

extension JQPictureController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //数组记录图片
        self.images.append(image.jq_scaleToWidth(width: 600))
        
        self.collectionView?.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
}
