//
//  Spot.swift
//  SpotrLogic
//
//  Created by Marcus on 28/06/2021.
//  Copyright © 2021 Spotr. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

public struct Spot: Identifiable, Codable, Hashable {

    /// The spot id.
    public var id: String?
    /// The spot name.
    public let name : String
    /// The spot location description.
    public let location: Location?
    /// The spot creation date.
    public let created: Date
    /// The spot updated date.
    public let updated: Date?

    public let picture : Picture?

    // MARK: Tag
    public let tags : [Tag.ID]?

    public let authors : [User]?

    
    public let geolocation: GeoPoint
//    public let interest : Double?


//    public let likeCount: Int?
//    public let latestLikeAuthor: User?


    // MARK: Coding

    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case name
        case location
        case picture
        case created = "dt_create"
        case updated = "dt_update"
        case tags
        case authors
        case geolocation
        //        case interest = "interest_score"
//        case likeCount
//        case latestLikeAuthor
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        location = try container.decodeIfPresent(Location.self, forKey: .location)
        picture = try container.decodeIfPresent(Picture.self, forKey: .picture)

        // Firebase timestamp decoding
        let createdTimestamp = try container.decode(Timestamp.self,
                                                    forKey: .created)
        created = createdTimestamp.dateValue()
        if let updatedTimestamp = try container.decodeIfPresent(Timestamp.self, forKey: .created) {
            updated = updatedTimestamp.dateValue()
        } else {
            updated = nil
        }
        

        tags = try container.decodeIfPresent([Tag.ID].self, forKey: .tags)
        authors = try container.decodeIfPresent([User].self, forKey: .authors)
        
        geolocation = try container.decode(GeoPoint.self, forKey: .geolocation)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(location, forKey: .location)
        try container.encodeIfPresent(picture, forKey: .picture)

        // Firebase timestamp encoding
        let createdTimestamp = Timestamp(date: created)
        try container.encode(createdTimestamp, forKey: .created)

        if let updated = updated {
            let updatedTimestamp = Timestamp(date: updated)
            try container.encodeIfPresent(updatedTimestamp, forKey: .updated)
        }

        try container.encodeIfPresent(tags, forKey: .tags)
        try container.encodeIfPresent(authors, forKey: .authors)
        
        try container.encodeIfPresent(geolocation, forKey: .geolocation)
    }


    // MARK: - Spots

    // MARK: Collection

    static let collection = firestore.collection("projection_spots_lists_spots")
}
