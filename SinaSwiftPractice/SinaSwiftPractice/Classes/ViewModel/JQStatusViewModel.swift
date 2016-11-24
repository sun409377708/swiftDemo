//
//  JQStatusViewModel.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/16.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

class JQStatusViewModel: NSObject {

    //富文本属性
    var originalAttributeString: NSAttributedString?
    
    var avatarImage:UIImage?
    var memberImage:UIImage?
    var iconURL:URL?
    
    //转为计算型属性,实时刷新
    var dateString:String? {
        let timeString = status?.created_at ?? ""
        
        // let timeString = "Thu Nov 17 19:09:10 +0800 2016"
        return Date.createDateStrint(createAtStr: timeString)
    }
    
    //评论文字
    var comment_text:String?
    var ohYeah_text:String?
    var repost_text:String?
    
    //设置配图
    var pictureInfos: [JQStatusPictureInfo]? {
        return status?.retweeted_status == nil ? status?.pic_urls : status?.retweeted_status?.pic_urls
    }
    
    //来源
    var sourceText: String?
    
    var status: JQStatus? {
        didSet {
            dealHeadImage()
            dealAvatarImage()
            dealMemberImage()
            sourceText = dealSource()
            
            comment_text = dealToolBarText(count: status?.comments_count ?? 0, defaultText: "评论")
            ohYeah_text = dealToolBarText(count: status?.attitudes_count ?? 0, defaultText: "赞")
            repost_text = dealToolBarText(count: status?.reposts_count ?? 0, defaultText: "转发")
            
            //处理文字富文本属性
            let strM = NSMutableAttributedString(string: status?.text ?? "")
            
            let font = UIFont.systemFont(ofSize: 12)
            strM.addAttributes([NSFontAttributeName : font, NSForegroundColorAttributeName : UIColor.orange], range: NSMakeRange(0, strM.length))
            
            originalAttributeString = strM
            
        }
    }
    
    private func dealToolBarText(count: Int, defaultText: String) -> String {
        if count == 0 {
            return defaultText
        }
        
        if count > 10000 {
            return "\(Double(count / 1000) / 10)万"
        }
        
        return "\(count)"
    }
    
    private func dealHeadImage() {
        let urlString = status?.user?.avatar_large ?? ""
        iconURL = URL(string: urlString)
    }
    
    private func dealAvatarImage() {
        let verified_type = status?.user?.verified_type ?? -1
        
        switch verified_type {
        case 0:
            avatarImage = #imageLiteral(resourceName: "avatar_vip")
        case 2,3,5:
            avatarImage = #imageLiteral(resourceName: "avatar_enterprise_vip")
        case 220:
            avatarImage = #imageLiteral(resourceName: "avatar_grassroot")
            
        default:
            avatarImage = nil
        }
    }
    
    private func dealMemberImage() {
        
        if let mbrank = status?.user?.mbrank, mbrank > 0 && mbrank < 7 {
            let imageName = "common_icon_membership_level\(mbrank)"
            memberImage = UIImage(named: imageName)
        }
    }
    
    private func dealSource() -> String {
        
        let str = status?.source ?? ""
        
        //定义标签
        let startFlag = "\">"
        let endFlag = "</a>"
        
        return str.subStringWithFlag(startFlag: startFlag, endFlag: endFlag)
    }
    
}
