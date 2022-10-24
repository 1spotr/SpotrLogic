//
//  Location.swift
//  Spotr
//
//  Created by Marcus on 12/05/2022.
//

import Foundation

public enum LocationEntityType: String, Codable, CaseIterable {
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

public protocol LocationEntity: Codable, Hashable {
				var id: EntityID { get }
				var name: String? { get }
				var type: LocationEntityType?  { get }
}

public extension LocationEntity {
				var name : String? {
								nil
				}

				var type: LocationEntityType? {
								nil
				}
}
