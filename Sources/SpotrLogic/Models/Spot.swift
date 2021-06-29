//
//  Spot.swift
//  SpotrLogic
//
//  Created by Marcus on 28/06/2021.
//  Copyright © 2021 Spotr. All rights reserved.
//

import Foundation

public struct Spot: Identifiable, Codable {
    public let id : String
    public let name : String
    public let tags : [Tag]
    public var pictures: [Picture]
    public let thumbnail: Picture
//    public let geolocation: SpotrGeoloc
    public let location: Location
    public let timestamp: Date
    public let likeCount: Int?
    public let latestLikeAuthor: User?
    // Spot preview
    public let authors: [User]
}
