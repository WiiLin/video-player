//
//  RootCoordinator.swift
//  video-player
//
//  Created by SHI-BO LIN on 2024/9/20.
//

import UIKit

class RootCoordinator: Coordinator {
    private var navigationController: UINavigationController

    lazy var listCoordinator = ListCoordinator(navigationController: navigationController)

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        listCoordinator.start()
    }
}
