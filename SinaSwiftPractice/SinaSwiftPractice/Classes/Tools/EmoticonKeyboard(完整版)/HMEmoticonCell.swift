//
//  HMEmoticonCell.swift
//  SinaWeibo
//
//  Created by apple on 16/10/7.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit

class HMEmoticonCell: UICollectionViewCell {
    
    var emoticons: [HMEmoticon]? {
        didSet {
            
            //在设置数据之前将所有的按钮都隐藏
            for btn in buttonArray {
                btn.isHidden = true
            }
            
            //一个萝卜对应一个坑
            for (index,em) in emoticons!.enumerated() {
                //获取按钮
                let btn = buttonArray[index]
                //显示能够设置数据的按钮
                btn.isHidden = false
                btn.emoticon = em
            }
        }
    }
    
    lazy var buttonArray: [HMEmoticonButtton] = [HMEmoticonButtton]()
    
    var indexPath: IndexPath? {
        didSet {
            //给testlabel设置文字
            testLabel.text = "第\(indexPath!.section)组,第\(indexPath!.item)行"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(testLabel)
        testLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        addChildButtons()
        
        //添加手势
        let longPre = UILongPressGestureRecognizer(target: self, action: #selector(longPress(ges:)))
        //添加到contentView上
        contentView.addGestureRecognizer(longPre)
    }
    
    @objc private func longPress(ges: UILongPressGestureRecognizer) {
        //1. 根据手势触摸的点 --> 查找按钮  --> 模型数据  -> popoView需要模型数据
        let point = ges.location(in: contentView)
        //print(point)
        //根据触摸点 找到表情
        guard let btn = findEmoticonBtn(point: point) else {
            popoView.removeFromSuperview()
            return
        }
        
        //判断按钮是否是显示的 如果不是显示的就直接return
        if btn.isHidden == true {
            popoView.removeFromSuperview()
            return
        }
        
        switch ges.state {
        case .began,.changed:
            //显示popoView
            //添加到contentView上
            let window = UIApplication.shared.windows.last!
            //转换左边  按钮需要将坐标转换到哪一个视图上
            //转换的坐标填什么有规律: 转换自己的坐标的时候就是用bounds 如果转换父视图的坐标的就用frame
            let rect = btn.superview!.convert(btn.frame, to: window)
            //let rect =  btn.convert(btn.bounds, to: window)
            popoView.center.x = rect.midX
            popoView.frame.origin.y = rect.maxY - popoView.bounds.height
            //给表情按钮设置模型
            popoView.emoticonButton.emoticon = btn.emoticon
            window.addSubview(popoView)
        default:
            //移除popoView
            popoView.removeFromSuperview()
        }
    }
    
    private func findEmoticonBtn(point: CGPoint) -> HMEmoticonButtton? {
        //循环按钮数组
        for btn in buttonArray {
            if btn.frame.contains(point) {
                return btn
            }
        }
        return nil
    }
    
    private func addChildButtons() {
        //添加20个坑(按钮)
        let bottomMargin: CGFloat = 30  // pageControl的显示范围
        let btnW = UIScreen.main.bounds.width / 7
        let btnH = (emoticonKeyboardHeight - emoticonToolBarHeight - bottomMargin) / 3
        for i in 0..<emoticonPageCount {
            let btn = HMEmoticonButtton()
            
            //计算 行 和 列
            let colIndex = i % 7
            let rowIndex = i / 7
            
            let btnX = CGFloat(colIndex) * btnW
            let btnY = CGFloat(rowIndex) * btnH
            
            btn.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
            //设置随机色
            //btn.backgroundColor = randomColor()
            //设置字体大小 显示emoji表情的
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            //添加到contentView上
            contentView.addSubview(btn)
            //添加到数组中
            buttonArray.append(btn)
            //监听按钮的点击事件
            btn.addTarget(self, action: #selector(emoticonBtnDidClick(btn:)), for: .touchUpInside)
        }
        
        //添加删除按钮
        let deleteBtn = UIButton()
        deleteBtn.frame = CGRect(x: UIScreen.main.bounds.width - btnW, y: 2 * btnH, width: btnW, height: btnH)
        let deleteImage = UIImage(named: "compose_emotion_delete_highlighted", in: HMEmoticonTools.sharedEmoticonTools.sourceBundle, compatibleWith: nil)
        deleteBtn.setImage(deleteImage, for: .normal)
        //添加删除按钮的监听事件
        deleteBtn.addTarget(self, action: #selector(deleteBtnDiDclick), for: .touchUpInside)
        contentView.addSubview(deleteBtn)
    }
    
    @objc private func deleteBtnDiDclick() {
        //发出通知
        NotificationCenter.default.post(name: NSNotification.Name(KSelectEmoticon), object: nil)
    }
    
    @objc private func emoticonBtnDidClick(btn: HMEmoticonButtton) {
        //如何从按钮中比较优雅获取一个模型
        //将表情模型存储到本地
        HMEmoticonTools.sharedEmoticonTools.saveRecentEmoticons(em: btn.emoticon!)
        //发出通知
        NotificationCenter.default.post(name: NSNotification.Name(KSelectEmoticon), object: btn.emoticon)
    }
    
    lazy var popoView : HMEmoticonPopoView = {
        let popo = HMEmoticonPopoView.loadPopoView()
        
        return popo
    }()
    
    lazy var testLabel: UILabel = {
        let l = UILabel()
        l.textColor = UIColor.red
        l.font = UIFont.systemFont(ofSize: 25)
        return l
    }()
    
}
