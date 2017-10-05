//
//  NSObjectExtension.swift
//  PasswordKeeper-swift
//
//  Created by Channing on 2017/1/9.
//  Copyright © 2017年 Channing Kuo. All rights reserved.
//

import Foundation

extension NSObject {
    // 扩展NSObject，添加获取NSObject类的属性名称及属性值
    // Retrieves an array of property names found on the current object
//    func propertyNames() -> [String] {
//        var results = [String]()
//
//        // retrieve the properties via the class_copyPropertyList function
//        var count: UInt32 = 0
//        let myClass: AnyClass = self.classForCoder
//        let properties = class_copyPropertyList(myClass, &count)
//
//        // iterate each objc_property_t struct
//        for i in 0 ..< count {
//            let property = properties?[Int(i)]
//            let cname = property_getName(property)
//            //convert the c string into a Swift string
//            let name = String.init(cString: cname!, encoding: String.Encoding.utf8)
//            results.append(name!)
//        }
//        return results
//    }
}

