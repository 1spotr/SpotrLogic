//
//  SpotrNotification.swift
//  SpotrLogic
//
//  Created by Johann Petzold on 14/12/2021.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

public struct SpotrNotification: Identifiable, Codable, Hashable {
    
    public let deeplinkUrl: String
    public let created: Date
    public let id: String
    public let mentionedTags: [Tag.ID]?
    public let mentionedUsers: [User]?
    public let spot: Spot?
    public let title: String
    public let text: String
    public let type: NotificationType
    public let user: User
    
    public enum NotificationType: String {
        case mention = "mention"
        case moderationAccepted = "pictures_suggestion_accepted"
        case moderationRefused = "pictures_suggestion_rejected"
    }
    
    // MARK: Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case deeplinkUrl = "url"
        case created = "dt_create"
        case id
        case mentionedTags = "mentioned_tags"
        case mentionedUsers = "mentioned_users"
        case spot
        case title
        case text
        case type
        case user = "author"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        deeplinkUrl = try container.decode(String.self, forKey: .deeplinkUrl)
        
        let createdTimestamp = try container.decode(Timestamp.self, forKey: .created)
        created = createdTimestamp.dateValue()
        
        id = try container.decode(String.self, forKey: .id)
        
        mentionedTags = try container.decodeIfPresent([Tag.ID].self, forKey: .mentionedTags)
        
        mentionedUsers = try container.decodeIfPresent([User].self, forKey: .mentionedUsers)
        
        spot = try container.decodeIfPresent(Spot.self, forKey: .spot)
        
        title = try container.decode(String.self, forKey: .title)
        
        text = try container.decode(String.self, forKey: .text)
        
        let newType = try container.decode(String.self, forKey: .type)
        type = NotificationType(rawValue: newType) ?? .mention
        
        user = try container.decode(User.self, forKey: .user)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(deeplinkUrl, forKey: .deeplinkUrl)
        
        let createdTimestamp = Timestamp(date: created)
        try container.encode(createdTimestamp, forKey: .created)
        
        try container.encode(id, forKey: .id)
        try container.encode(mentionedTags, forKey: .mentionedTags)
        try container.encode(mentionedUsers, forKey: .mentionedUsers)
        try container.encodeIfPresent(spot, forKey: .spot)
        try container.encode(title, forKey: .title)
        try container.encode(text, forKey: .text)
        try container.encode(type.rawValue, forKey: .type)
        try container.encode(user, forKey: .user)
        
    }
    
    // MARK: Collection
    
    static let notificationsCollection = firestore.collection("notifications")
    
    static func notificationsCollectionForCurrentUser(id: String) -> CollectionReference {
        return firestore.collection("users_private_metadata/\(id)/notifications")
    }
}
