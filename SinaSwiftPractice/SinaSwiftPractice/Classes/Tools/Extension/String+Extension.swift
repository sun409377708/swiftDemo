//
//  String+Extension.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/19.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

extension String {
    
    //MARK: - 处理字符串
    func subStringWithFlag(startFlag: String, endFlag: String) -> String {
        
        guard let startRangeIndex = self.range(of: startFlag),
            let endRangeIndex = self.range(of: endFlag) else {
                return "未知来源"
        }
        
        let startIndex = startRangeIndex.upperBound
        let endIndx = endRangeIndex.lowerBound
        
        let rangeIndx = startIndex..<endIndx
        
        let subStr = self.substring(with: rangeIndx)
        
        return subStr
    }
}
