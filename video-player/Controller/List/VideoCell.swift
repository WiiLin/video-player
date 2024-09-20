//
//  VideoCell.swift
//  video-player
//
//  Created by SHI-BO LIN on 2024/9/20.
//

import Kingfisher
import UIKit

class VideoCell: UITableViewCell {
    @IBOutlet var thumbImageView: UIImageView!

    @IBOutlet var videoTitleLabel: UILabel!

    @IBOutlet var videoSubtitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbImageView.kf.cancelDownloadTask()
    }

    func configure(data: Video) {
        thumbImageView.kf.setImage(with: URL(string: data.thumb))
        videoTitleLabel.text = data.title
        videoSubtitleLabel.text = data.subtitle
    }
}
