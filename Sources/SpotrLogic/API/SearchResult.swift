//
//  SearchResult.swift
//  API
//
//  Created by Marcus on 25/03/2022.
//

import Foundation

public struct ResultLocation: Codable, Equatable, Hashable {
				public enum LocationType: String, Codable, CaseIterable {
								case administrative_area_level_1
								case administrative_area_level_2
								case administrative_area_level_3
								case administrative_area_level_4
								case airport
								case colloquial_area
								case country
								case establishment
								case food
								case light_rail_station
								case locality
								case museum
								case natural_feature
								case neighborhood
								case park
								case point_of_interest
								case postal_town
								case premise
								case route
								case sublocality
								case sublocality_level_1
								case sublocality_level_2
								case sublocality_level_3
								case sublocality_level_4
								case subpremise
								case subway_station
								case tourist_attraction
								case train_station
								case transit_station
				}
				
			 public	let name: String
				public let `type`: LocationType
}

public struct SearchResult: Codable, Identifiable, Hashable {
				public init(id: SearchResult.ID, hit: SearchResult.Hit, name: String, values: Int?, news: Int?, thumbnail: URL?, firebaseId: String?, locations: [ResultLocation]? = nil) {
								self.id = id
								self.hit = hit
								self.name = name
								self.values = values
								self.news = news
								self.thumbnail = thumbnail
								self.firebaseId = firebaseId
								self.locations = locations
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
				public let locations: [ResultLocation]?
}
