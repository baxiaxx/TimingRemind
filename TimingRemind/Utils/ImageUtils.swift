//
//  ImageUtils.swift
//  PasswordKeeper-swift
//
//  Created by Channing on 2017/1/12.
//  Copyright © 2017年 Channing Kuo. All rights reserved.
//

import UIKit

// 图片处理相关帮助类
class ImageUtils {
    // UIImage -> Base64
    class func imageToBase64String(image: UIImage, headerSign: Bool = false) -> String? {
        // 根据图片得到对应的二进制编码
        guard let imageData = UIImagePNGRepresentation(image) else {
            return nil
        }
        // 根据二进制编码得到对应的base64字符串
        var base64String = imageData.base64EncodedString()
        // 判断是否需要带有头部base64标识信息
        if headerSign {
            // 根据格式拼接数据头 添加header信息，扩展名信息
            base64String = "data:image/png;base64," + base64String
        }
        return base64String
    }
    
    // image's Name -> Base64
    class func imageToBase64String(imageName: String, headerSign: Bool = false) -> String? {
        //根据名称获取图片
        guard let image: UIImage = UIImage.init(named: imageName) else {
            return nil
        }
        return self.imageToBase64String(image: image, headerSign: headerSign)
    }
    
    // Base64 -> UIImage
    class func base64StringToUIImage(base64String: String) -> UIImage? {
        var base64 = base64String
        if base64.hasPrefix("data:image") {
            guard let newBase64String = base64.components(separatedBy: ",").last else {
                return nil
            }
            base64 = newBase64String
        }
        // 将处理好的base64String代码转换成NSData
        guard let imgNSData = NSData(base64Encoded: base64, options: NSData.Base64DecodingOptions()) else {
            return nil
        }
        // 将NSData的图片，转换成UIImage
        guard let codeImage = UIImage(data: imgNSData as Data) else {
            return nil
        }
        return codeImage
    }
    //TODO 3、图片压缩
}
