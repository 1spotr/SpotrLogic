//
//  SetNotificationReadCommand.swift
//  SpotrLogic
//
//  Created by Johann Petzold on 27/01/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct SetNotificationReadCommand: Encodable {
    
    typealias PayloadType = Payload
    
    struct Payload: Codable {
        let user_id: String
    }
    
    let type: String = "users.notifications.mark_as_viewed"
    let version: String = "1.0.0"
    let payload: Payload
    
    var id: String = "\(Date().timeIntervalSince1970)_\(UUID().uuidString)"
    var timestamp: Timestamp = Timestamp(date: Date())
    var trace_id: String = UUID().uuidString
    var event_id: String? = "null"
    var origin: String = "ios"
    var origin_version: Int? = 144
    
    init(user_id: String) {
        self.payload = Payload(user_id: user_id)
    }
    
    static let collection = firestore.collection("commands_users_notifications")
}
