//
//  HMEmoticonTextView.swift
//  SinaWeibo
//
//  Created by apple on 16/10/10.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit

class HMEmoticonTextView: UITextView {

    

    
    func imageEmoticon2Chs() -> String{
        //表情图片的属性中有 NSAttachment 对应的键值对 纯文本中就没有
        //遍历属性字符串的所有的属性
        var strM = String()
        attributedText.enumerateAttributes(in: NSRange(location: 0, length: attributedText.length), options: []) { (dict, range, stop) in
            //完成字符串的拼接
            if let attachment = dict["NSAttachment"] as? HMTextAttachment {
                //图片
                //获取的是chs 如何优雅的获取chs
                print(attachment)
                strM += (attachment.chs ?? "")
            } else {
                //文字
                let subStr = (self.text as NSString).substring(with: range)
                strM += subStr
            }
        }
        return strM
    }
    
    
    func inputEmoticon(em: HMEmoticon) {
        let attachment = HMTextAttachment()
        attachment.chs = em.chs
        let bundle = HMEmoticonTools.sharedEmoticonTools.emoticonBundle
        attachment.image = UIImage(named: em.imagePath!, in: bundle, compatibleWith: nil)
        //设置bounds
        let lineHeight = font?.lineHeight ?? 0
        //bounds 是相当于自己 一旦设置值 就是和frame是相反
        attachment.bounds = CGRect(x: 0, y: -5, width: lineHeight, height: lineHeight)
        //2. 将附件对象包装富文本  不可变的属性文本是不能够添加属性的
        let imagetext = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        //2.1 添加属性
        imagetext.addAttributes([NSFontAttributeName : font!], range: NSMakeRange(0, 1))
        //3. 获取textView的富文本 --> 可变的属性文本
        let strM = NSMutableAttributedString(attributedString: attributedText)
        //3.1 在替换之前 记录之前选中的range
        let range = selectedRange
        //4. 向可变的富文本中插入 图片富文本
        
        strM.replaceCharacters(in: selectedRange, with: imagetext)
        //5. 将插入完成之后的富文本赋值 给textView.attributeText
        attributedText = strM
        
        //6.赋值结束之后恢复光标位置
        selectedRange = NSMakeRange(range.location + 1, 0)
        
        //主动调用代理方法
        self.delegate?.textViewDidChange?(self)
    }
}
