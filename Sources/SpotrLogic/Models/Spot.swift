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
    public let location: Location
    /// The spot creation date.
//    public let created: Timestamp
    /// The spot updated date.
//    public let updated: Timestamp

    public let picture : Picture?

    // MARK: Tag
    public let tags : [Tag.ID]?

    public let authors : [User]

//    public let interest : Double?


//    public let likeCount: Int?
//    public let latestLikeAuthor: User?


    // MARK: Coding

    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case name
        case location
        case picture
//        case created = "dt_create"
//        case updated = "dt_update"
        case tags
//        case interest = "interest_score"

        case authors
//        case likeCount
//        case latestLikeAuthor
    }


    // MARK: - Spots

    // MARK: Collection

    static let collection = firestore.collection("projection_spots_lists_spots")
}
