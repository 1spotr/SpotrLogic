//
//  FavoritesCommands.swift
//  SpotrLogin
//
//  Created by Marcus on 23/08/2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FavoriteCommand: Encodable {

    typealias PayloadType = Payload

    struct Payload: Codable {
        /// A V4 UUID generated at creation by the client
        let id: String
        let author_id: String
        let spot_id: String
    }

    let type: String = "social_interactions.favorites.create"
    let version: String = "1.0.0"
    let payload: Payload

    var id: String = "\(Date().timeIntervalSince1970)_\(UUID().uuidString)"
    var timestamp: Timestamp = Timestamp(date: Date())

    var trace_id: String = UUID().uuidString
    var event_id: String? = nil
    var origin: String = "ios"
    var origin_version: Int? = 144

    init(id: String, author_id: String, spot_id: String) {
        self.payload = Payload(id: id, author_id: author_id, spot_id: spot_id)
    }
}


struct FavoritePayload: Encodable {

    /// A V4 UUID generated at creation by the client
    let `id`: String
    let author_id: String
    let spot_id: String

    // MARK: - Favorites

    static let collection = firestore.collection("commands_social_interactions")
}
