//
//  VideoListViewModel.swift
//  video-player
//
//  Created by SHI-BO LIN on 2024/9/20.
//

import Combine
import Foundation

class VideoListViewModel: BaseViewModel {
    // MARK: - Input

    // MARK: - Output

    var fetchDataSuccessOutput = PassthroughSubject<Void, Never>()

    // MARK: - Properties

    var dataSource: [Video] = []

    // MARK: - Init

    // MARK: - Override

    override func observeOutputs() {
        super.observeOutputs()
    }
}

// MARK: - Public

extension VideoListViewModel {
    func fetchData() {
        dataSource = Video.loadVideosFromFile()
        fetchDataSuccessOutput.send(())
    }
}

// MARK: - Private

private extension VideoListViewModel {}
