//
//  YoutubeSearchModels.swift
//  Movie Selection
//
//  Created by Hafiz on 23/09/2024.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: VideoElementID
    let etag: String?
    let kind: String?
}

struct VideoElementID: Codable {
    let videoId: String?
    let kind: String?
}

