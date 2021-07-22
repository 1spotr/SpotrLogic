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

public class Spot: ObservableObject, Identifiable, Codable, Hashable {

    public private(set) var id : String?
    public let name : String
//    public let tags : [Tag]?
    public var pictures: [Picture]?
    public private(set) var thumbnail: Picture?
//    public let geolocation: SpotrGeoloc
    public let location: Location
    public let created: Date
    public let updated: Date
    public let likeCount: Int?
    public let latestLikeAuthor: User?
    // Spot preview
    public let authors: [User]?


    // MARK: Coding

    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case name
        case tags
        case pictures
        case thumbnail
        case location
        case created = "dt_create"
        case updated = "dt_update"
        case likeCount
        case latestLikeAuthor
        case authors
    }

    // MARK: Equate & Hashable

    public static func == (lhs: Spot, rhs: Spot) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // MARK: Loading

    public func load() -> Void {
        guard let id = id else { return }

        Picture.collection.whereField("spot_id", isEqualTo: id)
        .whereField("valid", isEqualTo: true)
        .order(by: "dt_update", descending: true)
            .getDocuments { query, error in
                if let document = query?.documents,
                   let result = try? document.compactMap({ try $0.data(as: Picture.self) }).first {
                    self.thumbnail = result
                    DispatchQueue.main.async {
                        self.objectWillChange.send()
                    }
                }
            }
    }


    // MARK: - Spots

    // MARK: Collection

    static let collection = firestore.collection("spots")
}
