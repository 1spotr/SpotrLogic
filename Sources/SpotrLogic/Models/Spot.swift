//
//  Spot.swift
//  SpotrLogic
//
//  Created by Marcus on 28/06/2021.
//  Copyright © 2021 Spotr. All rights reserved.
//

import Foundation

struct Spot: Identifiable, Codable {
    let id : String
    let name : String
    let tags : [Tag]
    var pictures: [Picture]
    let thumbnail: Picture
//    let geolocation: SpotrGeoloc
    let location: Location
    let timestamp: Date
    let likeCount: Int?
    let latestLikeAuthor: User?
    // Spot preview
    let authors: [User]
}
