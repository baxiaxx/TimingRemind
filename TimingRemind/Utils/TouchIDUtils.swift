//
//  TouchIdUtils.swift
//  PasswordKeeper-swift
//
//  Created by Channing on 2017/1/17.
//  Copyright © 2017年 Channing Kuo. All rights reserved.
//

import LocalAuthentication

class TouchIdUtils : NSObject {
    
    class func figerprintAuthentication(localizedDescription: String = "verify the fingerprint", callBack: @escaping (Figerprint) -> Void) {
        let context = LAContext()
        var error: NSError?
        var resp: Figerprint = Figerprint(isAuthenticated: false, errorCode: -1, errorMsg: "")
        
        // 判断设备是否支持指纹解锁
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedDescription, reply: { (success, error) in
                if success {
                    // 回到主线程继续UI更新，不这样处理会有4-5秒的延迟
                    DispatchQueue.main.async(execute: {
                        resp.isAuthenticated = true
                        callBack(resp)
                    })
                }
                else {
                    switch Int32((error as? NSError)!.code) {
                    // 身份验证失败
                    case kLAErrorAuthenticationFailed:
                        resp.errorCode = kLAErrorAuthenticationFailed
                        resp.errorMsg += "The user failed to provide valid credentials | "
                        print("LAErrorAuthenticationFailed")
                    // 用户取消
                    case kLAErrorUserCancel :
                        resp.errorCode = kLAErrorUserCancel
                        resp.errorMsg += "Authentication was cancelled by the user | "
                        print("kLAErrorUserCancel")
                    //验证失败
                    case kLAErrorUserFallback:
                        resp.errorCode = kLAErrorUserFallback
                        resp.errorMsg += "he user chose to use the fallback | "
                        print("LAErrorUserFallback")
                    // 被系统取消，例如按下电源键
                    case kLAErrorSystemCancel:
                        resp.errorCode = kLAErrorSystemCancel
                        resp.errorMsg += "Authentication was cancelled by the system | "
                        print("kLAErrorSystemCancel")
                    // 设备上并不具备密码设置信息，也就是说Touch ID功能处于被禁用状态
                    case kLAErrorPasscodeNotSet:
                        resp.errorCode = kLAErrorPasscodeNotSet
                        resp.errorMsg += "Passcode is not set on the device | "
                        print("kLAErrorPasscodeNotSet")
                    // 设备本身并不具备指纹传感装置
                    case kLAErrorTouchIDNotAvailable:
                        resp.errorCode = kLAErrorTouchIDNotAvailable
                        resp.errorMsg += "TouchID is not available on the device | "
                        print("kLAErrorTouchIDNotAvailable")
                    // 已经设定有密码机制，但设备配置当中还没有保存过任何指纹内容
                    case kLAErrorTouchIDNotEnrolled:
                        resp.errorCode = kLAErrorTouchIDNotEnrolled
                        resp.errorMsg += "Figerprint is not available on the device | "
                        print("kLAErrorTouchIDNotEnrolled")
                    // 输入次数过多验证被锁
                    case kLAErrorTouchIDLockout:
                        resp.errorCode = kLAErrorTouchIDLockout
                        resp.errorMsg += "Too many failed attempts | "
                        print("kLAErrorTouchIDLockout")
                    // app取消验证
                    case kLAErrorAppCancel:
                        resp.errorCode = kLAErrorAppCancel
                        resp.errorMsg += "Authentication was cancelled by application | "
                        print("LAErrorAppCancel")
                    // 无效的上下文
                    case kLAErrorInvalidContext:
                        resp.errorCode = kLAErrorInvalidContext
                        resp.errorMsg += "The context is invalid"
                        print("LAErrorAppCancel")
                        callBack(resp)
                    default:
                        break
                    }
                }
            })
        } else {
            resp.errorCode = 404
            resp.errorMsg = "Device does not support the TouchID"
            callBack(resp)
        }
    }
    
    struct Figerprint {
        var isAuthenticated: Bool
        var errorCode: Int32
        var errorMsg: String
        
        init(isAuthenticated: Bool, errorCode: Int32, errorMsg: String) {
            self.isAuthenticated = isAuthenticated
            self.errorCode = errorCode
            self.errorMsg = errorMsg
        }
    }
}
