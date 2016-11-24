//
//  HMEmoticonKeyboardView.swift
//  SinaWeibo
//
//  Created by apple on 16/10/7.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit
import SnapKit
let emoticonKeyboardHeight: CGFloat = 220
let emoticonToolBarHeight: CGFloat = 37


private let EmoticonCellId = "EmoticonCellId"

class HMEmoticonKeyboardView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        //backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        setupUI()
        
        //测试调用
       print(HMEmoticonTools.sharedEmoticonTools.allEmoticons)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(toolBar)
        addSubview(collectionView)
        addSubview(pageControl)
        addSubview(recentLabel)
        
        //设置约束
        toolBar.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(self)
            make.height.equalTo(emoticonToolBarHeight)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.bottom.equalTo(toolBar.snp.top)
        }
        
        pageControl.snp.makeConstraints { (make) in
            //pageControl 内容显示默认是居中的
            make.left.right.equalTo(self)
            make.bottom.equalTo(toolBar.snp.top)
        }
        
        recentLabel.snp.makeConstraints { (make) in
            make.center.equalTo(pageControl)
        }
        
        
        //实现toolBar闭包
        toolBar.emoticonTypeSelectClosure = { type in
            print(type)
            //滚动collectionView
            let indexPath = IndexPath(item: 0, section: type.rawValue)
            //animated: false 为了解决pageControl出现跑马灯的特效
            self.collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: false)
            self.updatePageControlData(indexPath: indexPath)
        }
        
        //设置UI界面的时候 就手动调用更新数据的方法
        //主队列异步 实际上还是主队列 当前任务的优先级是比较低优先级 等到主队列空闲的时候 才会执行代码块中的任务
        DispatchQueue.main.async {
//           self.updatePageControlData(indexPath: IndexPath(item: 0, section: 0))
        }
        
        
        regsiterNotification()
    }
    
    private func regsiterNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(KsaveRecentEmoticon), object: nil)
    }
    
    @objc private func reloadData() {
        //刷新第0组
        //如果当前显示的就是第0组 就不执行刷新
        let indexPath = collectionView.indexPathsForVisibleItems.last!
        if indexPath.section != 0 {
            collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updatePageControlData(indexPath: IndexPath(item: 0, section: 0))
    }
    
    
    
    /// 根据indexPath 更新pageControl的显示数据
    ///
    /// - parameter indexPath: 索引对象
    func updatePageControlData(indexPath: IndexPath) {
        //1. 根据indexPath.section  --> 获取到allEmoticons对应的二维数组
        let pageEmoticons = HMEmoticonTools.sharedEmoticonTools.allEmoticons[indexPath.section]
        //设置pageControl的数据
        pageControl.numberOfPages = pageEmoticons.count
        pageControl.currentPage = indexPath.item
        //设置最近文本的显示 和 pageControl的显示
        pageControl.isHidden = indexPath.section == 0
        recentLabel.isHidden = indexPath.section != 0
    }
    
    //懒加载子控件
    lazy var collectionView: UICollectionView = {
        //实例化流水布局对象
        let layout = UICollectionViewFlowLayout()
        //设置滚动方向
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: emoticonKeyboardHeight - emoticonToolBarHeight)
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        //注册cell
        cv.register(HMEmoticonCell.self, forCellWithReuseIdentifier: EmoticonCellId)
        //实现数据源方法
        //设置数据源代理
        cv.dataSource = self
        //设置代理
        cv.delegate = self
        cv.isPagingEnabled = true
        cv.bounces = false
        //设置背景颜色
        cv.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return cv
    }()
    
    //底部工具条
    lazy var toolBar: HMEmoticonToolBar = HMEmoticonToolBar()
    
    
    private lazy var pageControl : UIPageControl = {
        let page = UIPageControl()
        page.numberOfPages = 5
        page.currentPage = 2
        //OC项目运行环境下LLDB看的
        let selectedImage = UIImage(named: "compose_keyboard_dot_selected", in: HMEmoticonTools.sharedEmoticonTools.sourceBundle, compatibleWith: nil)
        let normalImage = UIImage(named: "compose_keyboard_dot_normal", in: HMEmoticonTools.sharedEmoticonTools.sourceBundle, compatibleWith: nil)
        page.setValue(selectedImage, forKey: "_currentPageImage")
        page.setValue(normalImage, forKey: "_pageImage")
        return page
    }()
    
    //最近提示文字
    private lazy var recentLabel: UILabel = {
        let l = UILabel()
        l.text = "最近使用的表情"
        l.textColor = UIColor.orange
        l.font = UIFont.systemFont(ofSize: 10)
        l.sizeToFit()
        return l
    }()

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//collectionView的数据源方法
extension HMEmoticonKeyboardView: UICollectionViewDataSource, UICollectionViewDelegate {
    //实现必选的协议方法
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let sectionEmoticon = HMEmoticonTools.sharedEmoticonTools.allEmoticons
        return sectionEmoticon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //swift中非空数组和空数组的地址是不一样
        let sectionEmoticon = HMEmoticonTools.sharedEmoticonTools.allEmoticons
        return sectionEmoticon[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmoticonCellId, for: indexPath) as! HMEmoticonCell
        cell.indexPath = indexPath
        //获取模型数组 --> 一维数组
        let emoticons = HMEmoticonTools.sharedEmoticonTools.allEmoticons[indexPath.section][indexPath.item]
        cell.emoticons = emoticons
        return cell
    }
    
    
    //实现代理方法
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetx = scrollView.contentOffset.x + 0.5 * UIScreen.main.bounds.width
        let point = CGPoint(x: contentOffsetx, y: 1)
        //根据一个点来确定indexPath
        let indexPath = collectionView.indexPathForItem(at: point)
        //让toolBar去更新选中的按钮
        self.toolBar.setEmoticonTypeSelected(indexPath: indexPath!)
        //更新pageControl
        self.updatePageControlData(indexPath: indexPath!)
    }
}


