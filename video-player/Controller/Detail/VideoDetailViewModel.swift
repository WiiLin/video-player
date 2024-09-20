//
//  VideoDetailViewModel.swift
//  video-player
//
//  Created by SHI-BO LIN on 2024/9/20.
//

import Combine
import Foundation

class VideoDetailViewModel: BaseViewModel {
    // MARK: - Input

    // MARK: - Output

    var updateInfoOutput = PassthroughSubject<Video, Never>()
    var playVideoOutput = PassthroughSubject<URL, Never>()

    // MARK: - Properties

    let video: Video

    // MARK: - Init

    init(video: Video) {
        self.video = video
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    // MARK: - Override

    override func observeOutputs() {
        super.observeOutputs()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateInfoOutput.send(video)
        playVideo()
    }
}

// MARK: - Public

extension VideoDetailViewModel {
    func playVideo() {
        guard let source = video.sources.first, let url = URL(string: source) else { return }
        playVideoOutput.send(url)
    }
}

// MARK: - Private

private extension VideoDetailViewModel {}
