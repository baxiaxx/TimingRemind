//
//  AlertControllerUtils.swift
//  PasswordKeeper-swift
//
//  Created by Channing on 2017/1/9.
//  Copyright © 2017年 Channing Kuo. All rights reserved.
//

import UIKit

// 会自动消失的UIAlertController
class AlertControllerUtils {

    class func alertAutoDismission(title: String?, message: String?, target: UIViewController) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        target.present(alertController, animated: true, completion: nil)
        // 2秒后UIAlertController自动消失
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            target.presentedViewController?.dismiss(animated: false, completion: nil)
        }
    }
}
