//
//  HMEmoticonTools.swift
//  SinaWeibo
//
//  Created by apple on 16/10/7.
//  Copyright © 2016年 itcast. All rights reserved.
//  加载表情数据

import UIKit

let KsaveRecentEmoticon = "KsaveRecentEmoticon"
let KSelectEmoticon =  "KSelectEmoticon"

private let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString).appendingPathComponent("recent.plist")
//每页有多少个表情
let emoticonPageCount = 20

class HMEmoticonTools: NSObject {

    
    static let sharedEmoticonTools = HMEmoticonTools()

    //所有的表情数组  二层数组 --> 三层数组 [[[HMEmoticon]]]
    lazy var allEmoticons : [[[HMEmoticon]]] = {
        return [[self.recentEmoticons],
                self.emoticonPages(emoticons: self.defaultEmoticons),
                self.emoticonPages(emoticons:self.emojiEmoticons),
                self.emoticonPages(emoticons:self.lxhEmoticons)]
    }()
    
    /// 将模型数组切割成二维数组
    ///
    /// - parameter emoticons: 模型数组
    ///
    /// - returns: 二维数组
    private func emoticonPages(emoticons: [HMEmoticon]) -> [[HMEmoticon]] {
        
        //按照每页20个表情 对模型数组进行切割(分页)
        // 108  -> 每页20 个 --> 6页
        let pageCount = (emoticons.count - 1) / emoticonPageCount + 1
        //分页截取
        var sectionEmoticon = [[HMEmoticon]]()
        for i in 0..<pageCount {
            //截取数组
            let loc = i * emoticonPageCount
            var len = emoticonPageCount
            //需要判断 loc + len > emoticons.count 108  -> 120
            if loc + len > emoticons.count {
                len = emoticons.count - loc
            }
            let array = (emoticons as NSArray).subarray(with: NSMakeRange(loc, len))
            print(array)
            //添加到二维数组中
            sectionEmoticon.append(array as! [HMEmoticon])
        }
        return sectionEmoticon
    }
    
    lazy var recentEmoticons : [HMEmoticon] = {
        
        //根据文件路径 解归档
        if let array = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [HMEmoticon] {
            return array
        }
        //返回空数组
        return [HMEmoticon]()
    }()
    
    //bundle对象的属性
    lazy var emoticonBundle : Bundle = {
        //1. 获取Emoticons.bundle的路径
        let path = Bundle.main.path(forResource: "Emoticons.bundle", ofType: nil)
        //根据路径获取bundle对象
        let emoticonBundle = Bundle.init(path: path!)!
        return emoticonBundle
    }()
    
    
    lazy var sourceBundle : Bundle = {
        //1. 获取Emoticons.bundle的路径
        let path = Bundle.main.path(forResource: "KeyboadBundle.bundle", ofType: nil)
        //根据路径获取bundle对象
        let emoticonBundle = Bundle.init(path: path!)!
        return emoticonBundle
    }()
    
    
    //默认表情的数组
    lazy var defaultEmoticons : [HMEmoticon] = {
        return self.loadEmoticon(path: "default/info.plist")
    }()
    
    //Emoji表情
    lazy var emojiEmoticons : [HMEmoticon] = {
        return self.loadEmoticon(path: "emoji/info.plist")
    }()
    
    //LXH表情
    lazy var lxhEmoticons : [HMEmoticon] = {
        return self.loadEmoticon(path: "lxh/info.plist")
    }()
    
    
    /// 根据不同的路径返回不同的表情模型数组
    ///
    /// - parameter path: 路径
    ///
    /// - returns: <#return value description#>
    private func loadEmoticon(path: String) -> [HMEmoticon] {
        //使用bundle的pathForResource方法读取bundle对象中的文件
        let infoPath = self.emoticonBundle.path(forResource: path, ofType: nil)
        
        //读取数组类型的plist文件
        let array = NSArray(contentsOfFile: infoPath!) as! [[String : Any]]
        
        
        var emoticons = [HMEmoticon]()
        for item in array {
            //字典转模型
            let e = HMEmoticon()
            //通过YYModel赋值
            e.yy_modelSet(with: item)
            if let img = e.png {
                //emoji 表情没有这个属性
                //(path as NSString).deletingLastPathComponent 删除info.plist
                e.imagePath = (path as NSString).deletingLastPathComponent + "/" +  img
            }
            emoticons.append(e)
        }
        
        return emoticons
    }
    
    
    func saveRecentEmoticons(em: HMEmoticon) {
        //在这里面完成存的操作
        // 1. 判断最近表情数组里面是否有该表情
        // 如果有的话，就移除
        //        if self.recentEmotions.contains(emoticon) {
        //            // 取到该表情模型对应数据中的索引（就是在第几个）
        //            let index = self.recentEmotions.index(of: emoticon)!
        //            // 移除数组中第几个元素
        //            self.recentEmotions.remove(at: index)
        //        }
        
        var index = 0
        
        
        let isContains = self.recentEmoticons.contains(where: { (value) -> Bool in
            
            // 自已的对比逻辑是什么？
            /**
             1. 如果两个表情模型都是图片表情或都是emoji表情，才有对比的必要
             2. 如果是图片表情，要对比png
             3. 如果是emoji表情，要对比code
             */
            
            // 1. 如果两个表情模型都是图片表情或都是emoji表情，才有对比的必要
            if value.type == em.type {
                // 2. 如果是图片表情，要对比png
                var result = false
                if value.type == 0 {
                    result = value.png == em.png
                }else{
                    // 3. 如果是emoji表情，要对比code
                    result = value.code == em.code
                }
                
                // 代表返回一个相同的元素
                if result == true {
                    // 那么在这个地方取到相同元素的索引
                    index = self.recentEmoticons.index(of: value)!
                }
                
                return result
            }
            return false
        })
        
        print(isContains)
        // 如果包含，就移除指定位置的元素
        if isContains {
            self.recentEmoticons.remove(at: index)
        }
        
        //1. 向数组中的角标为 0 的位置插入em
        //swift中的数组 是根据数据的元素数量 动态的申请内存空间的
        //let p = String(format: "%p", recentEmoticons)
        recentEmoticons.insert(em, at: 0)
        //let p1 = String(format: "%p", recentEmoticons)
        print(recentEmoticons)
        //给allEmoticons 赋值
        
        //2. 在存储数组之前需要判断数组的数量是否大于20 如果大于20就应该移除最后一个表情模型
        if recentEmoticons.count > 20 {
            recentEmoticons.removeLast()
        }
        //先删除再赋值
        allEmoticons[0][0] = recentEmoticons
        
        print(recentEmoticons.count)
        
        //3. 存储表情模型数组
        
        NSKeyedArchiver.archiveRootObject(recentEmoticons, toFile: path)
        
        //显示到最近的分组这一组 如何显示  需要刷新第0组
        // 当两个类之间没有明前前后关系  使用通知是最好的方式
        NotificationCenter.default.post(name: NSNotification.Name(KsaveRecentEmoticon), object: nil)
        print(path)
    }
    
    
    //根据chs查找模型数据
    func findEmoticon(chs: String) -> HMEmoticon? {
        
        //需要在default 和 lxh数组中查找模型对象
        let result1 = defaultEmoticons.filter { (em) -> Bool in
            return em.chs == chs
        }
        if result1.count > 0 {
            return result1.first
        }
        
        let result2 = lxhEmoticons.filter { (em) -> Bool in
            return em.chs == chs
        }
        if result2.count > 0 {
            return result2.first
        }
        return nil
    }
    
}
