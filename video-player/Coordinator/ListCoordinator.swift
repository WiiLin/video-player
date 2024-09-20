//
//  ListCoordinator.swift
//  video-player
//
//  Created by SHI-BO LIN on 2024/9/20.
//

import UIKit

class ListCoordinator: Coordinator {
    private let navigationController: UINavigationController

    var detailCoordinator: DetailCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let listView = makeListView()
        setupFlows(of: listView)
        navigationController.push(listView, animated: false)
    }

    func navigateToDetail(data: Video) {
        detailCoordinator = DetailCoordinator(video: data, navigationController: navigationController)
        detailCoordinator?.start()
    }
}

// MARK: - Private

private extension ListCoordinator {
    func makeListView() -> VideoListView {
        let listView: VideoListView = VideoListViewController(viewModel: .init())
        return listView
    }

    func setupFlows(of videoListView: VideoListView) {
        videoListView.onGoToDetail = { [weak self] video in
            guard let self = self else { return }
            self.navigateToDetail(data: video)
        }
    }
}
