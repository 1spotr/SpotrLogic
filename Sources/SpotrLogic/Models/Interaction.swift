//
//  Interaction.swift
//  SpotrLogic
//
//  Created by Marcus on 15/08/2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


// MARK: - Interaction

public struct Interaction: Identifiable, Hashable, Codable {
    
    public let id: String? // Can be empty and then setted when ready
//    public let mentionedTags: [Tag]
//    public let mentionedUsers: [User]
    public let spot: Spot
    public let text: String?
    public let type: Types
//    public let author: User
//    public let timestamp: Timestamp

//    public struct InteractionSpot: Codable {
//        public let id: String?
//        public let created: Data
//        public let geolocation: GeoPoint
//        public let name: String
//        public let location: Location?
//        public let picture: Picture?
//        
//        enum CodingKeys: String, CodingKey {
//            case id
//            case created = "dt_create"
//            case geolocation
//            case name
//            case location
//            case picture
//        }
//    }
    
    // MARK: Type

    public enum `Types`: String, Codable {
        case comment
        case favorite
        case pictureSuggestion = "content_suggestion"
    }

//    // MARK: Equatable
//    
//    public static func == (lhs: Interaction, rhs: Interaction) -> Bool {
//        lhs.id == rhs.id
//    }
//    
//    // MARK: Hashable
//    
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }

    // MARK: Collection

    static let collection = firestore.collection("social_interactions")

}
