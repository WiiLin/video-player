//
//  DetailCoordinator.swift
//  video-player
//
//  Created by SHI-BO LIN on 2024/9/20.
//

import UIKit

class DetailCoordinator: Coordinator {
    private var navigationController: UINavigationController

    private let video: Video

    init(video: Video, navigationController: UINavigationController) {
        self.video = video
        self.navigationController = navigationController
    }

    func start() {
        let detailView = makeDetailView()

        setupFlows(of: detailView)

        navigationController.push(detailView, animated: true)
    }
}

// MARK: - Private

private extension DetailCoordinator {
    func makeDetailView() -> DetailView {
        let detailView: DetailView = VideoDetailViewController(viewModel: VideoDetailViewModel(video: video))

        return detailView
    }

    func setupFlows(of detailView: DetailView) {
        detailView.onFlowComplete = { [weak self] in
            guard let self = self else { return }

            self.navigationController.popViewController(animated: true)
        }
    }
}
