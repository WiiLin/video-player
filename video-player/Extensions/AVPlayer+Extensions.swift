//
//  AVPlayer+Extensions.swift
//  video-player
//
//  Created by SHI-BO LIN on 2024/9/20.
//

import AVFoundation

extension AVPlayer {
    var bufferProgress: Double {
        return currentItem?.bufferProgress ?? -1
    }

    var currentBufferDuration: Double {
        return currentItem?.currentBufferDuration ?? -1
    }

    var currentDuration: Double {
        return currentItem?.currentDuration ?? -1
    }

    var playProgress: Double {
        return currentItem?.playProgress ?? -1
    }

    var totalDuration: Double {
        return currentItem?.totalDuration ?? -1
    }

    convenience init(asset: AVURLAsset) {
        self.init(playerItem: AVPlayerItem(asset: asset))
    }
}
