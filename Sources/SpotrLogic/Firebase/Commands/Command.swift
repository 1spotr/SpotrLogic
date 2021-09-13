//
//  File.swift
//  
//
//  Created by Marcus on 23/08/2021.
//

import Foundation

import FirebaseFirestore
import FirebaseFirestoreSwift

struct Command: Encodable {

    let id: String = "\(Date().timeIntervalSince1970)_\(UUID().uuidString)"
    let timestamp: Timestamp = Timestamp(date: Date())
    let trace_id: String = UUID().uuidString
    let version: String = "1.0.0"
    let event_id: String? = nil
    let origin: String = "ios"
    let origin_version: Int? = 113


    let type : String = "social_interactions.favorites.create"
    enum PayloadType: String, Encodable {
        case createFavorite = "social_interactions.favorites.create"
    }

    let payload : Encodable

    init(_ payload: Encodable, type: PayloadType) {
        self.payload = payload
//        self.type = type
    }


    // MARK: - Encodable

    enum CodingKeys: String, CodingKey {
        case id
        case timestamp
        case trace_id
        case event_id
        case origin
        case origin_version
        case type
        case payload
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(trace_id, forKey: .trace_id)
        try container.encode(event_id, forKey: .event_id)
        try container.encode(origin, forKey: .origin)
        try container.encode(origin_version, forKey: .origin_version)
        try container.encode(type, forKey: .type)

        switch type {
            case "social_interactions.favorites.create":
                try container.encode(payload as! FavoritePayload, forKey: .payload)

            default:
                break
        }

    }

}
