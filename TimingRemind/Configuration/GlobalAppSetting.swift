//
//  GlobalAppSetting.swift
//  TimingRemind
//
//  Created by Channing Kuo on 2017/10/3.
//  Copyright © 2017年 Channing Kuo. All rights reserved.
//

import Foundation

class GlobalAppSetting{
    // 是否是第一次打开应用
    static var isFirstOpen: Bool{
        get{
            let v = UserDefaults.standard.value(forKey: "isFirstOpen")
            return v == nil ? false : v as! Bool
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isFirstOpen")
            UserDefaults.standard.synchronize()
        }
    }
}
