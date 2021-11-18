//
//  AreaCommand.swift
//  SpotrLogic
//
//  Created by Marcus on 29/10/2021.
//

import Foundation
import FirebaseFirestore

struct AreaCommand: Command {

    var event_id: String? = "null"

    var id: String = "\(Date().timeIntervalSince1970)_\(UUID().uuidString)"
    var timestamp: Timestamp = Timestamp(date: Date())
    var trace_id: String = UUID().uuidString
    var origin: String = "ios"
    var origin_version: Int?

    typealias PayloadType = Payload

    struct Payload: Codable {
        let user_id: String
        let area_id: String
    }

    let type: String = "users.settings.area.update"
    let version: String = "1.0.0"
    let payload: Payload

    init(user_id: String, area_id: String) {
        self.payload = Payload(user_id: user_id, area_id: area_id)
    }

    static let collection = firestore.collection("commands_users")
}
