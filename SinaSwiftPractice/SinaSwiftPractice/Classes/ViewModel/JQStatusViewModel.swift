//
//  JQStatusViewModel.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/16.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit
import YYText

//表情正则表达式对象
let emoticonRegex = try! NSRegularExpression(pattern: "\\[.*?\\]", options: [])
//话题
let topicRegex = try! NSRegularExpression(pattern: "#.*?#", options: [])
//@某人
let atSomeOneRegex = try! NSRegularExpression(pattern: "@\\w+", options: [])
//url
let urlRegex = try! NSRegularExpression(pattern: "[a-zA-z]+://[^\\s]*", options: [])

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
//            let strM = NSMutableAttributedString(string: status?.text ?? "")
//            
//            let font = UIFont.systemFont(ofSize: 12)
//            strM.addAttributes([NSFontAttributeName : font, NSForegroundColorAttributeName : UIColor.orange], range: NSMakeRange(0, strM.length))
            
            originalAttributeString = dealStatueText(status: status?.text ?? "")
            
        }
    }
    
    private func dealStatueText(status: String) -> NSAttributedString {
        
        let strM = NSMutableAttributedString(string: status)

        //1. 根据正则表达式截取内容 -> 查找表情, 所以是[.*?], 因为[]在正则表达式中表示
        // 只占一位, 所以需要进行转译 \[ \]
        let matchResults = emoticonRegex.matches(in: status, options: [], range: NSRange(location: 0, length: status.characters.count))
        
        //2. 倒叙遍历数组
        for result in matchResults.reversed() {
            let range = result.rangeAt(0)
            
            let subStr = (status as NSString).substring(with: range)
            
            let font = UIFont.systemFont(ofSize: 15)
            let lineHeight = font.lineHeight
            
            // 3. 根据表情字符串 在EmotionTools 查找对于的模型
            if let em = HMEmoticonTools.sharedEmoticonTools.findEmoticon(chs: subStr) {
             
                let bundle = HMEmoticonTools.sharedEmoticonTools.emoticonBundle
                
                // 4. 模型中找图片对象
                let image = UIImage(named: em.imagePath!, in: bundle, compatibleWith: nil)
                
                // 5. 将图片包装成属性字符串
                let imageText = NSMutableAttributedString.yy_attachmentString(withContent: image, contentMode: .scaleAspectFill, attachmentSize: CGSize(width: lineHeight, height: lineHeight), alignTo: font, alignment: .center)

                // 6. 将图片属性字符串转到strM中
                strM.replaceCharacters(in: range, with: imageText)
            }
        }
        addHighLighted(regex: topicRegex, strM: strM)
        addHighLighted(regex: atSomeOneRegex, strM: strM)
        addHighLighted(regex: urlRegex, strM: strM)
        
        return strM
    }
    
    
    private func addHighLighted(regex: NSRegularExpression, strM: NSMutableAttributedString) {
        
        // 1. 拿到富文本中的字符串进行检索
        let text = strM.string
        // 2. 正则截取
        let matchResult = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.characters.count))
        
        for result in matchResult {
            let range = result.rangeAt(0)
            strM.addAttributes([NSForegroundColorAttributeName : UIColor.purple], range: range)
            
            // 3. 设置文本点击高亮
            let border = YYTextBorder.init(fill: UIColor.darkGray, cornerRadius: 3)
//            border.insets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
            let highLighted = YYTextHighlight()
            
            highLighted.setColor(UIColor.green)
            highLighted.setBackgroundBorder(border)
            strM.yy_setTextHighlight(highLighted, range: range)
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
