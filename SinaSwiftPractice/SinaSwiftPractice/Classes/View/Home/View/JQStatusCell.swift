//
//  JQStatusCell.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/16.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit
import SDWebImage
import YYText
import SVProgressHUD

let commonMargin: CGFloat = 8

//图片之间的间距
private let pictureCellMargin: CGFloat = 3

//计算图片的宽度
private let maxWidth =  ScreenWidth - 2 * commonMargin
private let itemWidth = (maxWidth - 2 * pictureCellMargin) / 3

private var isFirst = true
class JQStatusCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var memberImage: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var sourceLabel: UILabel!
    
    @IBOutlet weak var contentLabel: YYLabel!
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var pictureViewWidthCons: NSLayoutConstraint!
    
    @IBOutlet weak var pictureViewHeightCons: NSLayoutConstraint!
    
    @IBOutlet weak var pictureViewTopCons: NSLayoutConstraint!
    
    @IBOutlet weak var pictureView: JQPictureView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var commentBtn: UIButton!
    
    @IBOutlet weak var repostBtn: UIButton!
    
    @IBOutlet weak var ohYeahBtn: UIButton!
    
    @IBOutlet weak var retweetedText: UILabel!
    
    @IBOutlet weak var toolBarView: UIView!
    
    
    var viewmodel: JQStatusViewModel? {
        didSet {
           
            iconView.sd_setImage(with: viewmodel?.iconURL)
            memberImage.image = viewmodel?.memberImage
            avatarImage.image = viewmodel?.avatarImage
            nameLabel.text = viewmodel?.status?.user?.name
            timeLabel.text = viewmodel?.dateString
            sourceLabel.text = viewmodel?.sourceText
//            contentLabel.text = viewmodel?.status?.text
            contentLabel.attributedText = viewmodel?.originalAttributeString
            
            //计算配图视图大小
            let count = viewmodel?.pictureInfos?.count ?? 0
            let size = changePictureViewSize(count: count)
            
            pictureViewWidthCons.constant = size.width
            pictureViewHeightCons.constant = size.height
            
            flowLayout.itemSize = count == 1 ? size : CGSize(width: itemWidth, height: itemWidth)
            
            //传递数据给配图视图
            pictureView.pictureInfo = viewmodel?.pictureInfos
            if !isFirst {
                isFirst = false
            }
            
            retweetedText?.text = viewmodel?.status?.retweeted_status?.text
            //根据是否有配图调整顶部间距
            pictureViewTopCons.constant = (count == 0 ? 0 : commonMargin)
            //设置工具条按钮
            commentBtn.setTitle(viewmodel?.comment_text, for: .normal)
            repostBtn.setTitle(viewmodel?.repost_text, for: .normal)
            ohYeahBtn.setTitle(viewmodel?.ohYeah_text, for: .normal)
            
            //高亮文本点击响应
            contentLabel.highlightTapAction = {(containerView, text, range, rect)  in
                
                let subStr = (text.string as NSString).substring(with: range)
                SVProgressHUD.showInfo(withStatus: subStr)
                
                if subStr.contains("http") {
                    
                    let temp = JQTempController()
                    temp.URLString = subStr
                    self.navController()?.pushViewController(temp, animated: true)
                }
            }
        }
    }
    
    func ToolBarHeight(viewmodel: JQStatusViewModel) -> CGFloat {
        
        //调用set方法
        self.viewmodel = viewmodel
        
        self.contentView.layoutIfNeeded()
        
        return toolBarView.frame.maxY
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none

        contentLabel.preferredMaxLayoutWidth = ScreenWidth - 2 * commonMargin
        retweetedText?.preferredMaxLayoutWidth =  ScreenWidth - 2 * commonMargin
        contentLabel.numberOfLines = 0
        retweetedText?.numberOfLines = 0
        
        //设置配图视图流水布局
//        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        flowLayout.minimumLineSpacing = pictureCellMargin
        flowLayout.minimumInteritemSpacing = pictureCellMargin
    }
    
    

    private func changePictureViewSize(count: Int) -> CGSize {
        
        //0 图
        if count == 0{
            return CGSize.zero
        }
        
        // 1 图
        if count == 1 {
            
            let urlString = viewmodel?.pictureInfos?.first?.wap_pic ?? ""
            //获取磁盘中的图片根据路径
            let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: urlString)
            
            guard let imageSize = image?.size else {
                return CGSize.zero
            }
            return CGSize(width: imageSize.width, height: imageSize.height)
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
