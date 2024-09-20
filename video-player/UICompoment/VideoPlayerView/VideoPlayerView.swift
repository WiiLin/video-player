//
//  VideoPlayerView.swift
//  video-player
//
//  Created by SHI-BO LIN on 2024/9/20.
//

import AVFoundation
import UIKit

class VideoPlayerView: UIView {
    public enum PausedReason {
        case hidden
        case userInteraction
        case waitingKeepUp
    }

    // MARK: - SubViews

    public var player: AVPlayer? {
        get { return playerLayer.player }
        set { playerLayer.player = newValue }
    }

    public let playerLayer: AVPlayerLayer = .init()

    // MARK: - Properties

    var isPlaying: Bool {
        if let player = player {
            return player.rate != 0
        } else {
            return false
        }
    }

    var isMuted: Bool {
        get { return player?.isMuted ?? false }
        set { player?.isMuted = newValue }
    }

    var volume: Double {
        get { return player?.volume.double ?? 0 }
        set { player?.volume = newValue.float }
    }

    var playProgress: Double {
        return isLoaded ? player?.playProgress ?? 0 : 0
    }

    var currentDuration: Double {
        return isLoaded ? player?.currentDuration ?? 0 : 0
    }

    var bufferProgress: Double {
        return isLoaded ? player?.bufferProgress ?? 0 : 0
    }

    var currentBufferDuration: Double {
        return isLoaded ? player?.currentBufferDuration ?? 0 : 0
    }

    var totalDuration: Double {
        return isLoaded ? player?.totalDuration ?? 0 : 0
    }

    var speedRate: Float = 1.0

    private var isLoaded = false

    private(set) var pausedReason: PausedReason = .waitingKeepUp

    private(set) var playerURL: URL?

    private(set) var state: State = .none {
        didSet { stateDidChanged(state: state, previous: oldValue) }
    }

    private var playerBufferingObservation: NSKeyValueObservation?
    private var playerItemKeepUpObservation: NSKeyValueObservation?
    private var playerItemStatusObservation: NSKeyValueObservation?
    private var playerLayerReadyForDisplayObservation: NSKeyValueObservation?
    private var playerTimeControlStatusObservation: NSKeyValueObservation?

    // MARK: - Callback

    open var stateDidChanged: ((State) -> Void)?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureInit()
    }

    // MARK: - override

    override func layoutSubviews() {
        super.layoutSubviews()
        guard playerLayer.superlayer == layer else { return }

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        playerLayer.frame = bounds
        CATransaction.commit()
    }
}

// MARK: - Public methods

extension VideoPlayerView {
    func play(for url: URL) {
        guard playerURL != url else {
            player?.playImmediately(atRate: speedRate)
            return
        }

        observe(playerItem: nil)
        observe(player: nil)

        self.player?.currentItem?.cancelPendingSeeks()
        self.player?.currentItem?.asset.cancelLoading()

        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false

        let playerItem = AVPlayerItem(url: url)
        playerItem.canUseNetworkResourcesForLiveStreamingWhilePaused = true

        self.player = player
        playerURL = url
        isLoaded = false

        player.playImmediately(atRate: speedRate)

        player.replaceCurrentItem(with: playerItem)

        observe(player: player)
        observe(playerItem: playerItem)
    }

    func pause() {
        player?.pause()
    }

    func pause(reason: PausedReason) {
        pausedReason = reason
        pause()
    }

    func resume() {
        player?.play()
    }

    func seek(to time: CMTime, completion: ((Bool) -> Void)? = nil) {
        player?.seek(to: time) { completion?($0) }
    }

    @discardableResult
    func addPeriodicTimeObserver(forInterval interval: CMTime, queue: DispatchQueue? = nil, using: @escaping (CMTime) -> Void) -> Any? {
        return player?.addPeriodicTimeObserver(forInterval: interval, queue: queue, using: using)
    }

    func removeTimeObserver(_ observer: Any) {
        player?.removeTimeObserver(observer)
    }

    func destroy() {
        player = nil
        NotificationCenter.default.removeObserver(self)
        removeFromSuperview()
    }
}

// MARK: - Private methods

extension VideoPlayerView {
    func configureInit() {
        layer.addSublayer(playerLayer)
    }

    func stateDidChanged(state: State, previous: State) {
        guard state != previous else {
            return
        }

        switch state {
        case .playing, .paused: isHidden = false
        default: isHidden = true
        }
        stateDidChanged?(state)
    }

    func observe(player: AVPlayer?) {
        guard let player = player else {
            playerLayerReadyForDisplayObservation = nil
            playerTimeControlStatusObservation = nil
            return
        }

        playerLayerReadyForDisplayObservation = playerLayer.observe(\.isReadyForDisplay) { [unowned self, unowned player] playerLayer, _ in
            if playerLayer.isReadyForDisplay, player.rate > 0 {
                self.isLoaded = true
                self.state = .playing
            }
        }

        playerTimeControlStatusObservation = player.observe(\.timeControlStatus) { [unowned self] player, _ in

            switch player.timeControlStatus {
            case .paused:
                self.state = .paused(playProgress: self.playProgress, bufferProgress: self.bufferProgress)
                if self.pausedReason == .waitingKeepUp {
                    player.playImmediately(atRate: speedRate)
                }
            case .waitingToPlayAtSpecifiedRate:
                break
            case .playing:

                if self.playerLayer.isReadyForDisplay, player.rate > 0 {
                    self.isLoaded = true
                    self.state = .playing
                }
            @unknown default:
                break
            }
        }
    }

    func observe(playerItem: AVPlayerItem?) {
        guard let playerItem = playerItem else {
            playerBufferingObservation = nil
            playerItemStatusObservation = nil
            playerItemKeepUpObservation = nil
            return
        }

        playerBufferingObservation = playerItem.observe(\.loadedTimeRanges) { [unowned self] item, _ in
            if case .paused = self.state, self.pausedReason != .hidden {
                self.state = .paused(playProgress: self.playProgress, bufferProgress: self.bufferProgress)
            }
        }

        playerItemStatusObservation = playerItem.observe(\.status) { [unowned self] item, _ in
            if item.status == .failed, let error = item.error as NSError? {
                self.state = .error(error)
            }
        }

        playerItemKeepUpObservation = playerItem.observe(\.isPlaybackLikelyToKeepUp) { [unowned self] item, _ in
            if item.isPlaybackLikelyToKeepUp {
                if self.player?.rate == 0, self.pausedReason == .waitingKeepUp {
                    self.player?.playImmediately(atRate: speedRate)
                }
            }
        }
    }
}
