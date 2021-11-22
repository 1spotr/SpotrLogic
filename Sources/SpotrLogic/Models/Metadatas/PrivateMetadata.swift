//
//  PrivateMetadata.swift
//  SpotrLogic
//
//  Created by Marcus on 08/11/2021.
//

import Foundation
import FirebaseFirestore

public struct PrivateMetadata: Decodable {

    public struct Settings: Decodable {
        public let selectedAreaId: String?

        enum CodingKeys: String, CodingKey {
            case selectedAreaId = "selected_area_id"
        }
    }

    public struct Subscription: Codable {
        let start: Date
        let end: Date
        let type: String

        enum CodingKeys: String, CodingKey {
            case start = "dt_start"
            case end = "dt_end"
            case type
        }

        public init(from decoder: Decoder) throws {

            let container = try decoder.container(keyedBy: CodingKeys.self)
            type = try container.decode(String.self, forKey: .type)
            let startTimestamp = try container.decode(Timestamp.self, forKey: .start)
            start = startTimestamp.dateValue()

            let endTimestamp = try container.decode(Timestamp.self, forKey: .end)
            end = endTimestamp.dateValue()


        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(type, forKey: .type)
            let startTimestamp = Timestamp(date: start)
            try container.encode(startTimestamp, forKey: .start)
            let endTimestamp = Timestamp(date: end)
            try container.encode(endTimestamp, forKey: .end)
        }
    }

    public struct Billing: Decodable {
        let latestSubscription: Subscription?

        enum CodingKeys: String, CodingKey {
            case latestSubscription = "latest_subscription"
        }
    }

    public struct Social: Decodable {
        let blocked_users: [String]?
    }

    // let preferences: FirestoreUserPreferences?
    //public let social: Social?
    public let settings: Settings?
    public let billing: Billing?




    static let collection = firestore.collection("users_private_metadata")
}
