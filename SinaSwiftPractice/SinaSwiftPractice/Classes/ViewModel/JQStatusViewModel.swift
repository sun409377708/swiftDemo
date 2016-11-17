//
//  JQStatusViewModel.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/16.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

class JQStatusViewModel: NSObject {

    var avatarImage:UIImage?
    var memberImage:UIImage?
    var iconURL:URL?
    
    //评论文字
    var comment_text:String?
    var ohYeah_text:String?
    var repost_text:String?
    
    
    var status: JQStatus? {
        didSet {
            dealHeadImage()
            dealAvatarImage()
            dealMemberImage()
            
            comment_text = dealToolBarText(count: status?.comments_count ?? 0, defaultText: "评论")
            ohYeah_text = dealToolBarText(count: status?.attitudes_count ?? 0, defaultText: "赞")
            repost_text = dealToolBarText(count: status?.reposts_count ?? 0, defaultText: "转发")
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
}
