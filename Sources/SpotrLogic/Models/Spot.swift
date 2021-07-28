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

    public private(set) var identifier : String?

    public var id: String? {
        (identifier ?? "") + (documentID ?? "")
    }
    private let documentID : String?


    public let name : String
    public let location: Location
    public let created: Date
    public let updated: Date
//    public let likeCount: Int?
//    public let latestLikeAuthor: User?


    // MARK: Coding

    enum CodingKeys: String, CodingKey, CaseIterable {
        case identifier = "id"
        case name
        case documentID = "_id"
        case location
        case created = "dt_create"
        case updated = "dt_update"
//        case likeCount
//        case latestLikeAuthor
    }


    // MARK: - Spots

    // MARK: Collection

    static let collection = firestore.collection("spots")
}
