//
//  Spot.swift
//  Spotr
//
//  Created by Marcus on 12/05/2022.
//

import Foundation


public protocol SpotEntity: Entity {

				/// The spot name.
				var name: String { get }

				/// The spot creation date.
				var created: Date { get }

				/// The spot updated date.
				var updated: Date { get }

				associatedtype SpotLocation = LocationValue
				/// The spot location description.
				var location: SpotLocation? { get }

				associatedtype SpotPicture = PictureEntity
				var picture: SpotPicture? { get }

				associatedtype SpotTag = TagEntity
				var tags: [SpotTag]? { get }

				associatedtype SpotAuthor = UserEntity
				var authors: [SpotAuthor]? { get }

				associatedtype SpotCoordinate = CoordinateValue
				var coordinate: SpotCoordinate { get }
}
