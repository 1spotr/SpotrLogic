//
//  Spot.swift
//  SpotrLogic
//
//  Created by Marcus on 28/06/2021.
//  Copyright © 2021 Spotr. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift

public struct Spot: Identifiable, Codable, Hashable {

    public private(set) var id : String?
    public let name : String
//    public let tags : [Tag]?
    public var pictures: [Picture]
    public let thumbnail: Picture
//    public let geolocation: SpotrGeoloc
    public let location: Location
    public let timestamp: Date
    public let likeCount: Int?
    public let latestLikeAuthor: User?
    // Spot preview
    public let authors: [User]


    // MARK: Equatable


    // MARK: - Spots

    // MARK: Collection

    static let collection = firestore.collection("spots")
}
