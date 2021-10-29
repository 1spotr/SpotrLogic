//
//  AreaCommand.swift
//  
//
//  Created by Marcus on 29/10/2021.
//

import Foundation

final class AreaCommand: Encodable {

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
