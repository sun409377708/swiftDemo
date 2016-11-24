//
//  HMEmoticonButtton.swift
//  SinaWeibo
//
//  Created by apple on 16/10/9.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit

class HMEmoticonButtton: UIButton {

    var emoticon: HMEmoticon? {
        didSet {
            //设置数据
            let bundle = HMEmoticonTools.sharedEmoticonTools.emoticonBundle
            //只有图片表情才会有imagePath
            if emoticon!.type == 0 {
                //图片表情
                let image = UIImage(named: emoticon!.imagePath!, in: bundle, compatibleWith: nil)
                setImage(image, for: .normal)
                //将按钮的文字设置为 nil
                setTitle(nil, for: .normal)
            } else {
                
                setTitle(emoticon!.emojiStr, for: .normal)
                //解决图片表情和emoji表情的复用
                setImage(nil, for: .normal)
            }
        }
    }

}
