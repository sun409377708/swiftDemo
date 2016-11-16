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
    
    
    var status: JQStatus? {
        didSet {
            dealHeadImage()
            dealAvatarImage()
            dealMemberImage()
        }
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
