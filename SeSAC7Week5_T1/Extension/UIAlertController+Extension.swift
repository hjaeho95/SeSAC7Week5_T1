//
//  UIAlert+Extension.swift
//  SeSAC7Week5_T1
//
//  Created by ez on 7/28/25.
//

import UIKit

extension UIAlertController {
    convenience init(title: String?, message: String?, handler: ((UIAlertAction) -> Void)?) {
        self.init(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "확인", style: .default, handler: handler)
        addAction(action)
    }
}
