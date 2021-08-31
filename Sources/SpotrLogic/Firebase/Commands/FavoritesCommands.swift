//
//  FavoritesCommands.swift
//  SpotrLogin
//
//  Created by Marcus on 23/08/2021.
//

import Foundation

final class CreateFavoriteCommandData: CommandDataProtocol {

    typealias PayloadType = Payload

    struct Payload: Codable {
        /// A V4 UUID generated at creation by the client
        let id: String
        let author_id: String
        let spot_id: String
    }

    let type: String = "social_interactions.favorites.create"
    let version: String = "1.0.0"
    let payload: Payload

    init(id: String, author_id: String, spot_id: String) {
        self.payload = Payload(id: id, author_id: author_id, spot_id: spot_id)
    }
}

final class CreateFavoriteCommand: CommandProtocol, Encodable {

    typealias CommandDate = CreateFavoriteCommandData

    let collection: String = "commands_social_interactions"
    let data: CreateFavoriteCommandData

    init(data: CreateFavoriteCommandData) {
        self.data = data
    }
}
