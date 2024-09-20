//
//  Presentable.swift
//  video-player
//
//  Created by SHI-BO LIN on 2024/9/20.
//

import UIKit

protocol Presentable {
    func toPresent() -> UIViewController
}

extension UIViewController: Presentable {
    func toPresent() -> UIViewController { self }
}

protocol BaseView: AnyObject, Presentable {}

extension UIViewController {
    func present(_ presentable: Presentable, animated: Bool = true, completion: (() -> Void)? = nil) {
        present(presentable.toPresent(), animated: animated, completion: completion)
    }
}

extension UINavigationController {
    func push(_ presentable: Presentable, animated: Bool = true) {
        pushViewController(presentable.toPresent(), animated: animated)
    }

    func pop(animated: Bool = true) {
        popViewController(animated: animated)
    }
}
