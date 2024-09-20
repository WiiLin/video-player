//
//  UIAlertController+Show.swift
//  video-player
//
//  Created by SHI-BO LIN on 2024/9/20.
//

import UIKit

extension UIAlertController {
    class func showError(_ error: Error, controller: UIViewController, handler: SimpleOutput? = nil) {
        let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "ok", style: .default) { _ in
            handler?()
        }
        alert.addAction(okAction)

        controller.present(alert, animated: true, completion: nil)
    }
}
