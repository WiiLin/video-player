//
//  VideoDetailViewController.swift
//  video-player
//
//  Created by SHI-BO LIN on 2024/9/20.
//

import UIKit

protocol DetailView: BaseView {
    var onFlowComplete: SimpleOutput? { get set }
}

class VideoDetailViewController: BaseViewController<VideoDetailViewModel>, DetailView {
    // MARK: - 📌 Constants

    // MARK: - 🔶 Properties

    var onFlowComplete: SimpleOutput?

    // MARK: - 🧩 Subviews

    @IBOutlet var videoControlView: VideoControlView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var descLabel: UILabel!

    // MARK: - 🔨 Initialization

    override init(viewModel: VideoDetailViewModel) {
        super.init(viewModel: viewModel)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 🖼 View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func observeViewModelOutputs() {
        super.observeViewModelOutputs()
        viewModel.updateInfoOutput
            .sink { [weak self] video in
                guard let self = self else { return }
                updateInfo(video: video)
            }
            .store(in: &cancellables)
        viewModel.playVideoOutput
            .sink { [weak self] url in
                guard let self = self else { return }
                videoControlView.play(for: url)
            }
            .store(in: &cancellables)
    }

    override func setupUI() {
        super.setupUI()
    }
}

// MARK: - 🏗 UI

private extension VideoDetailViewController {
    func updateInfo(video: Video) {
        titleLabel.text = video.title
        subtitleLabel.text = video.subtitle
        descLabel.text = video.description
    }
}

// MARK: - 👆 Actions

private extension VideoDetailViewController {}

// MARK: - 🔒 Private Methods

private extension VideoDetailViewController {}

// MARK: - 🚌 Public Methods

extension VideoDetailViewController {}
