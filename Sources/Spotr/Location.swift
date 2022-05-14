//
//  Location.swift
//  Spotr
//
//  Created by Marcus on 12/05/2022.
//

import Foundation


public protocol Location: Codable, Hashable {

				associatedtype Names = LocationNames?
				var neighbourhood: Names { get }
				var city: Names { get }
				var region: Names { get }
				var country: Names { get }

}

// MARK: - Location Names

public protocol LocationNames: Codable, Hashable {
				var longName: String { get }
}
