//
//  UsernameInstagramCommands.swift
//  SpotrLogic
//
//  Created by Marcus on 03/11/2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct SetUsernameInstagramCommand: Encodable {

    typealias PayloadType = Payload

    struct Payload: Codable {
        let user_id: String
        let instagram_username: String
    }

    let type: String = "users.social.instagram.username_update"
    let version: String = "1.0.0"
    let payload: Payload
    
    var id: String = "\(Date().timeIntervalSince1970)_\(UUID().uuidString)"
    var timestamp: Timestamp = Timestamp(date: Date())
    var trace_id: String = UUID().uuidString
    var event_id: String? = "null"
    var origin: String = "ios"
    var origin_version: Int? = 144

    init(user_id: String, instagram_username: String) {
        self.payload = Payload(user_id: user_id, instagram_username: instagram_username)
    }

    static let collection = firestore.collection("commands_users")
}

struct SetUsernameCommand: Encodable {
    
    typealias PayloadType = Payload

    struct Payload: Codable {
        let user_id: String
        let username: String
    }

    let type: String = "users.username_update"
    let version: String = "1.0.0"
    let payload: Payload
    
    var id: String = "\(Date().timeIntervalSince1970)_\(UUID().uuidString)"
    var timestamp: Timestamp = Timestamp(date: Date())
    var trace_id: String = UUID().uuidString
    var event_id: String? = "null"
    var origin: String = "ios"
    var origin_version: Int? = 144

    init(user_id: String, username: String) {
        self.payload = Payload(user_id: user_id, username: username)
    }

    static let collection = firestore.collection("commands_users")
}
