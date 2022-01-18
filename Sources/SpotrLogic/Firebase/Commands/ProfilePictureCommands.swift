//
//  ProfilePictureCommands.swift
//  SpotrLogic
//
//  Created by Johann Petzold on 13/01/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ProfilePictureCommand: Encodable {
    
    typealias PayloadType = Payload
    
    struct Payload: Codable {
        let user_id: String
        let profile_picture_url: String?
        let profile_picture_storage_id: String?
    }
    
    let type: String = "users.profile_picture_update"
    let version: String = "1.0.0"
    let payload: Payload
    
    var id: String = "\(Date().timeIntervalSince1970)_\(UUID().uuidString)"
    var timestamp: Timestamp = Timestamp(date: Date())
    var trace_id: String = UUID().uuidString
    var event_id: String? = nil
    var origin: String = "iOS"
    var origin_version: Int? = 144
    
    init(user_id: String, profile_picture_url: String?, profile_picture_storage_id: String?) {
        self.payload = Payload(user_id: user_id, profile_picture_url: profile_picture_url, profile_picture_storage_id: profile_picture_storage_id)
    }
    
    static let collection = firestore.collection("commands_users")
}
