//
//  HMEmoticon.swift
//  SinaWeibo
//
//  Created by apple on 16/10/7.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit
import YYModel

class HMEmoticon: NSObject,NSCoding {
    
    //想服务器发送的表情文字
    var chs: String?
    //本地用来匹配文字 显示对应的图片
    var png: String?
    //0 就是图片表情 1 就是Emoji表情
    var type: Int = 0
    //Emoji表情的十六进制的字符串
    var code: String? {
        didSet {
            emojiStr = ((code ?? "") as NSString).emoji()
        }
    }
    
    //emoji表情的属性
    var emojiStr: String?
    
    var imagePath: String?
    
    //需要手动实现默认的构造函数
    override init() {
        super.init()
    }
    
    //实际上 不要求程序员面向运行时开发
    required init?(coder aDecoder: NSCoder) {
        //给对象发送消息 ,需要确保对象已经被实例化
        super.init()
        self.yy_modelInit(with: aDecoder)
    }
    
    func encode(with aCoder: NSCoder) {
        yy_modelEncode(with: aCoder)
    }
}
