//
//  JQCompose.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/21.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

class JQCompose: NSObject {
    
    var icon: String?
    
    var title: String?
    
    var className: String?
    
    init(dict: [String : AnyObject]) {
        super.init()
        
        setValuesForKeys(dict)
    }
}
