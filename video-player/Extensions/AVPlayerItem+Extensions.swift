//
//  AVPlayerItem+Extensions.swift
//  video-player
//
//  Created by SHI-BO LIN on 2024/9/20.
//

import AVFoundation

public extension AVPlayerItem {
    var bufferProgress: Double {
        return currentBufferDuration / totalDuration
    }

    var currentBufferDuration: Double {
        guard let range = loadedTimeRanges.first else { return 0 }
        return Double(CMTimeGetSeconds(CMTimeRangeGetEnd(range.timeRangeValue)))
    }

    var currentDuration: Double {
        return Double(CMTimeGetSeconds(currentTime()))
    }

    var playProgress: Double {
        return currentDuration / totalDuration
    }

    var totalDuration: Double {
        return Double(CMTimeGetSeconds(asset.duration))
    }
}
