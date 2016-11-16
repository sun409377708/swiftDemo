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
    
    var viewmodel: JQStatusViewModel? {
        didSet {
           
            iconView.sd_setImage(with: viewmodel?.iconURL)
            memberImage.image = viewmodel?.memberImage
            avatarImage.image = viewmodel?.avatarImage
            nameLabel.text = viewmodel?.status?.user?.name
            timeLabel.text = viewmodel?.status?.created_at
            sourceLabel.text = viewmodel?.status?.source
            contentLabel.text = viewmodel?.status?.text
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor.randomColor()
        
        contentLabel.preferredMaxLayoutWidth = screenSize.width - 2 * commonMargin
    }

    
}
