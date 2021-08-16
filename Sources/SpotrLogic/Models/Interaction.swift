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
    public let text: String
    public let type: Types
    public let author: User
//    public let timestamp: Timestamp


    // MARK: Type

    public enum `Types`: String, Codable {
        case comment
        case favorite
        case pictureSuggestion = "content_suggestion"
    }

    // MARK: - Interactions


    // MARK: Collection

    static let collection = firestore.collection("social_interactions")

}
