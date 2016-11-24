//
//  HMEmoticonPopoView.swift
//  SinaWeibo
//
//  Created by apple on 16/10/9.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit

class HMEmoticonPopoView: UIView {

    @IBOutlet weak var emoticonButton: HMEmoticonButtton!
    
    //增加类方法 加载该视图
    class func loadPopoView() -> HMEmoticonPopoView {
        let nib = UINib(nibName: "HMEmoticonPopoView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).last as! HMEmoticonPopoView
    }

}
