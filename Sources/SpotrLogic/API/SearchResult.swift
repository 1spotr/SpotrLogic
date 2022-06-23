//
//  SearchResult.swift
//  API
//
//  Created by Marcus on 25/03/2022.
//

import Foundation

public struct SearchResult: Codable, Identifiable, Hashable {
				public init(id: SearchResult.ID, hit: SearchResult.Hit, name: String, values: Int?, news: Int?, thumbnail: URL?, firebaseId: String?) {
								self.id = id
								self.hit = hit
								self.name = name
								self.values = values
								self.news = news
								self.thumbnail = thumbnail
								self.firebaseId = firebaseId
				}

				public typealias ID = String

				public enum Hit: String, Codable, CaseIterable {
								case spot
								case user
								case tag
								case area
				}

				public let id: ID
				public let hit : Hit

				public let name: String
				public let values : Int?
				public let news : Int?
				public let thumbnail : URL?
				public let firebaseId: String?
}
