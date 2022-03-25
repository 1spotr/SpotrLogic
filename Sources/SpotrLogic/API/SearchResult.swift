//
//  SearchResult.swift
//  API
//
//  Created by Marcus on 25/03/2022.
//

import Foundation

struct SearchResult: Codable {
				typealias ID = String

				enum Hit: String, Codable, CaseIterable {
								case spot
								case user
								case tag
								case area
				}

				let id: ID
				let hit : Hit

				let name: String
				let values : Int?
				let news : Int?
				let thumbnail : URL?
}
