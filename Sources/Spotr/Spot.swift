//
//  Spot.swift
//  Spotr
//
//  Created by Marcus on 12/05/2022.
//

import Foundation


public protocol Spot: Entity {

				/// The spot id.
				var id: ID { get }

				/// The spot name.
				var name: String { get }

				/// The spot creation date.
				var created: Date { get }

				/// The spot updated date.
				var updated: Date { get }

				associatedtype SpotLocation = Location
				/// The spot location description.
				var location: SpotLocation? { get }

				associatedtype SpotPicture = Picture
				var picture: SpotPicture? { get }

				associatedtype SpotTag = Tag
				var tags: [SpotTag]? { get }

				associatedtype SpotAuthor = User
				var authors: [SpotAuthor]? { get }

				associatedtype SpotCoordinate = Coordinate
				var coordinate: SpotCoordinate { get }
}
