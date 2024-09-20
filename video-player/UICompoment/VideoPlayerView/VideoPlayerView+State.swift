//
//  VideoPlayerView+State.swift
//  video-player
//
//  Created by SHI-BO LIN on 2024/9/20.
//

import Foundation

extension VideoPlayerView {
    enum State {
        case none
        case loading
        case playing
        case paused(playProgress: Double, bufferProgress: Double)
        case error(NSError)
    }
}

extension VideoPlayerView.State: Equatable {
    static func == (lhs: VideoPlayerView.State, rhs: VideoPlayerView.State) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none):
            return true
        case (.loading, .loading):
            return true
        case (.playing, .playing):
            return true
        case let (.paused(p1, b1), .paused(p2, b2)):
            return (p1 == p2) && (b1 == b2)
        case let (.error(e1), .error(e2)):
            return e1 == e2
        default:
            return false
        }
    }
}
