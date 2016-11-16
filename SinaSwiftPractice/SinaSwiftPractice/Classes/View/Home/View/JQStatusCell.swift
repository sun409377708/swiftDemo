//
//  JQStatusCell.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/16.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit
import SDWebImage

let commonMargin: CGFloat = 8

//图片之间的间距
private let pictureCellMargin: CGFloat = 3

//计算图片的宽度
private let maxWidth =  ScreenWidth - 2 * commonMargin
private let itemWidth = (maxWidth - 2 * pictureCellMargin) / 3


class JQStatusCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var memberImage: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var sourceLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var pictureViewWidthCons: NSLayoutConstraint!
    
    @IBOutlet weak var pictureViewHeightCons: NSLayoutConstraint!
    
    @IBOutlet weak var pictureView: JQPictureView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var viewmodel: JQStatusViewModel? {
        didSet {
           
            iconView.sd_setImage(with: viewmodel?.iconURL)
            memberImage.image = viewmodel?.memberImage
            avatarImage.image = viewmodel?.avatarImage
            nameLabel.text = viewmodel?.status?.user?.name
            timeLabel.text = viewmodel?.status?.created_at
            sourceLabel.text = viewmodel?.status?.source
            contentLabel.text = viewmodel?.status?.text
            
            //计算配图视图大小
            let count = viewmodel?.status?.pic_urls?.count ?? 0
            let size = changePictureViewSize(count: count)
            
            pictureViewWidthCons.constant = size.width
            pictureViewHeightCons.constant = size.height
            
            //传递数据给配图视图
            pictureView.pictureInfo = viewmodel?.status?.pic_urls
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none

        contentLabel.preferredMaxLayoutWidth = ScreenWidth - 2 * commonMargin
        
        //设置配图视图流水布局
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        flowLayout.minimumLineSpacing = pictureCellMargin
        flowLayout.minimumInteritemSpacing = pictureCellMargin
    }

    private func changePictureViewSize(count: Int) -> CGSize {
        
        //0 图
        if count == 0{
            return CGSize.zero
        }
        
        //4 图
        if count == 4 {
            
            let width = 2 * itemWidth + pictureCellMargin
            return CGSize(width: width, height: width)
        }
        
        //其他图
        let rowCount = CGFloat((count - 1) / 3 + 1)
        
        let height = rowCount * itemWidth + (rowCount - 1) * pictureCellMargin
        
        return CGSize(width: maxWidth, height: height)
    }
}
