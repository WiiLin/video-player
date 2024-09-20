//
//  VideoControlView.swift
//  video-player
//
//  Created by SHI-BO LIN on 2024/9/20.
//

import AVFoundation
import SnapKit
import UIKit

class VideoControlView: UIView {
    // MARK: - SubViews

    private let videoPlayerView = VideoPlayerView()
    private lazy var videoPlayVideoButton: UIButton = {
        let button = UIButton()
        button.setImage(nil, for: .normal)
        button.setImage(UIImage(named: "video_pause_icon"), for: .selected)
        button.tintColor = .white
        button.addTarget(self, action: #selector(onClickPlay), for: .touchUpInside)
        return button
    }()

    private let seekView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        return view
    }()

    private let currentDurationLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()

    private let totalDurationLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderTouchEnded(_:)), for: [.touchUpInside, .touchUpOutside])
        return slider
    }()

    // MARK: - Properties

    private var sliding: Bool = false

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

// MARK: - Public methods

extension VideoControlView {
    func play(for url: URL) {
        videoPlayerView.play(for: url)

        addVideoOBserver()
    }

    func resumeVideo() {
        videoPlayerView.resume()
    }

    func pauseVideo(reason: VideoPlayerView.PausedReason) {
        videoPlayerView.pause(reason: reason)
    }
}

// MARK: - Actions

private extension VideoControlView {
    @objc func onClickPlay() {
        if videoPlayVideoButton.isSelected {
            resumeVideo()
        } else {
            pauseVideo(reason: .userInteraction)
        }
    }

    @objc func sliderValueChanged(_ sender: UISlider) {
        sliding = true
        updateSlidingTime(value: sender.value)
    }

    @objc func sliderTouchEnded(_ sender: UISlider) {
        seekToTime(value: sender.value) { [weak self] _ in
            guard let self else { return }
            sliding = false
        }
    }
}

// MARK: - Private methods

private extension VideoControlView {
    func setupUI() {
        addSubview(videoPlayerView)
        videoPlayerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        addSubview(videoPlayVideoButton)
        videoPlayVideoButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        addSubview(seekView)

        seekView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(40)
        }

        let stackView = UIStackView.hstack([currentDurationLabel, slider, totalDurationLabel], spacing: 5, alignment: .center)
        seekView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(5)
            make.centerY.equalToSuperview()
        }
        for label in [currentDurationLabel, totalDurationLabel] {
            label.snp.makeConstraints { make in
                make.width.equalTo(50)
                make.height.equalTo(40)
            }
        }
    }

    func seekToTime(value: Float, completion: ((Bool) -> Void)? = nil) {
        let time = videoPlayerView.totalDuration * Double(value)
        let cmTime = CMTime(value: .init(time), timescale: 1)
        videoPlayerView.seek(to: cmTime, completion: completion)
    }

    func updateSlidingTime(value: Float) {
        let time = videoPlayerView.totalDuration * Double(value)
        currentDurationLabel.text = Int(time).displayTime
    }

    func addVideoOBserver() {
        videoPlayerView.stateDidChanged = { [weak self] state in
            guard let self else { return }

            let state = videoPlayerView.state
            let playVideoButtonIsSelected: Bool = {
                switch state {
                case .loading, .none, .error:
                    return false
                case .paused:
                    return true
                case .playing:
                    return false
                }
            }()
            videoPlayVideoButton.isSelected = playVideoButtonIsSelected
        }

        videoPlayerView.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 60), using: { [weak self] _ in
            guard let self else { return }
            guard sliding == false else { return }
            currentDurationLabel.text = Int(videoPlayerView.currentDuration).displayTime
            totalDurationLabel.text = Int(videoPlayerView.totalDuration).displayTime
            slider.value = Float(videoPlayerView.currentDuration / videoPlayerView.totalDuration)
        })
    }
}
