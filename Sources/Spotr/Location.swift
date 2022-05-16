//
//  Location.swift
//  Spotr
//
//  Created by Marcus on 12/05/2022.
//

import Foundation


public protocol LocationValue: Codable, Hashable {

				associatedtype Names = LocationNamesValue?
				var neighbourhood: Names { get }
				var city: Names { get }
				var region: Names { get }
				var country: Names { get }

}

// MARK: - Location Names

public protocol LocationNamesValue: Codable, Hashable {
				var longName: String { get }
}
