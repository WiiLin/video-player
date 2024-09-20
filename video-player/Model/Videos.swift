//
//  Videos.swift
//  video-player
//
//  Created by SHI-BO LIN on 2024/9/20.
//

import Foundation

struct Video: Decodable {
    let description: String
    let subtitle: String
    let thumb: String
    let title: String
    let sources: [String]
}

extension Video {
    static func loadVideosFromFile() -> [Video] {
        guard let path = Bundle.main.path(forResource: "Datasource", ofType: "json") else { return [] }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))

            let decoder = JSONDecoder()
            let videoResponse = try decoder.decode(VideoResponse.self, from: data)
            return videoResponse.categories.flatMap { $0.videos }
        } catch {
            print("\(error)")
        }
        return []
    }
}

// http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg

struct Category: Decodable {
    let name: String
    let videos: [Video]
}

struct VideoResponse: Decodable {
    let categories: [Category]
}
