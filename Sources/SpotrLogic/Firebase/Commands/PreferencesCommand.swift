//
//  PreferencesCommand.swift
//  SpotrLogic
//
//  Created by Johann Petzold on 27/01/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct PreferencesCommand: Encodable {
    
    typealias PayloadType = Payload
    
    struct Payload: Codable {
        let user_id: String
        let mentions: Bool
        let moderation: Bool
    }
    
    let type: String = "users.preferences.notifications.update"
    let version: String = "1.0.0"
    let payload: Payload
    
    var id: String = "\(Date().timeIntervalSince1970)_\(UUID().uuidString)"
    var timestamp: Timestamp = Timestamp(date: Date())
    var trace_id: String = UUID().uuidString
    var event_id: String? = "null"
    var origin: String = "ios"
    var origin_version: Int? = 144
    
    init(user_id: String, mentions: Bool, moderation: Bool) {
        self.payload = Payload(user_id: user_id, mentions: mentions, moderation: moderation)
    }
    
    static let collection = firestore.collection("commands_users")
}
