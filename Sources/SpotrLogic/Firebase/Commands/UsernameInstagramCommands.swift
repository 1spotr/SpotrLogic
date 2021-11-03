//
//  UsernameInstagramCommands.swift
//  SpotrLogic
//
//  Created by Marcus on 03/11/2021.
//

import Foundation

struct SetUsernameInstagramCommand: Encodable {

    typealias PayloadType = Payload

    struct Payload: Codable {
        let user_id: String
        let instagram_username: String
    }

    let type: String = "users.social.instagram.username_update"
    let version: String = "1.0.0"
    let payload: Payload

    init(user_id: String, instagram_username: String) {
        self.payload = Payload(user_id: user_id, instagram_username: instagram_username)
    }

    static let collection = firestore.collection("commands_users")
}
