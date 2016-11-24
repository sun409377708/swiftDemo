//
//  HMEmoticonToolBar.swift
//  SinaWeibo
//
//  Created by apple on 16/10/7.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit
/*
 父视图默认就占用了tag = 0
 */
enum EmoticonType: Int {
    case RECENT = 0
    case DEFAULT
    case EMOJI
    case LXH
}

@available(iOS 9.0, *)
class HMEmoticonToolBar: UIStackView {

    var lastBtn: UIButton?
    
    var emoticonTypeSelectClosure: ((EmoticonType) -> ())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        //UIStackView 只是一个容器视图 不负责渲染
        backgroundColor = UIColor.blue
        
        setupUI()
        
        //设置轴
        axis = .horizontal
        //设置填充方式
        distribution = .fillEqually
        
        self.tag = 10000
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        //添加四个表情类型的按钮
        //最近
        addChildButtons(title: "最近", backImg: "compose_emotion_table_left",index: .RECENT)
        //默认
        addChildButtons(title: "默认", backImg: "compose_emotion_table_mid",index: .DEFAULT)
        //Emoji
        addChildButtons(title: "Emoji", backImg: "compose_emotion_table_mid",index: .EMOJI)
        //浪小花
        addChildButtons(title: "浪小花", backImg: "compose_emotion_table_right",index: .LXH)
    }
    
    private func addChildButtons(title: String, backImg: String,index: EmoticonType) {
        let btn = UIButton()
        //设置唯一标记
        // 获取枚举的原始值 rawValue
        btn.tag = index.rawValue
        let normalImage = UIImage(named: backImg + "_normal", in: HMEmoticonTools.sharedEmoticonTools.sourceBundle, compatibleWith: nil)
        let selectedImage = UIImage(named: backImg + "_selected", in: HMEmoticonTools.sharedEmoticonTools.sourceBundle, compatibleWith: nil)
        let normalStrechImage = normalImage?.stretchableImage(withLeftCapWidth: 3, topCapHeight: 18)
        let seletedStrechImage = selectedImage?.stretchableImage(withLeftCapWidth: 3, topCapHeight: 18)
        //默认状态
        btn.setBackgroundImage(normalStrechImage, for: .normal)
        //选中状态的背景图片
        btn.setBackgroundImage(seletedStrechImage, for: .selected)
        
        btn.setTitle(title, for: .normal)
        //设置文字颜色
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .selected)
        //监听按钮的点击事件
        btn.addTarget(self, action: #selector(emoticonTypeBtnDidClick(btn:)), for: .touchUpInside)
        //添加
        self.addArrangedSubview(btn)
        
        if index == .RECENT {
            btn.isSelected = true
            //记录上一次选中的按钮
            lastBtn = btn
        }
    }
    
    @objc private func emoticonTypeBtnDidClick(btn: UIButton) {
        
        //如果已经是选中状态就直接返回
        if btn.isSelected {
            return
        }
        lastBtn?.isSelected = false
        
        //记录上一次选中的按钮
        lastBtn = btn
        //被点击的按钮应该设置为选中状态
        btn.isSelected = true
        
        //执行闭包,对外抛出按钮的点击事件
        emoticonTypeSelectClosure?(EmoticonType.init(rawValue: btn.tag)!)
    }
    
    func setEmoticonTypeSelected(indexPath: IndexPath) {
        
        let btn = self.viewWithTag(indexPath.section) as! UIButton
        //如果已经是选中状态就直接返回
        if btn.isSelected {
            return
        }
        lastBtn?.isSelected = false
        
        //记录上一次选中的按钮
        lastBtn = btn
        //被点击的按钮应该设置为选中状态
        btn.isSelected = true
    }
    
}
