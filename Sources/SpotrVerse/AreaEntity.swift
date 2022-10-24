//
//  Area.swift
//  Spotr
//
//  Created by Marcus on 12/05/2022.
//

import Foundation

public protocol AreaEntity: Entity {

				// The area name
				var name: String { get }


				associatedtype AreaPicture = PictureEntity
				var pictures: [AreaPicture] { get }

				associatedtype AreaCoordinate = CoordinateValue
				var coordinate: AreaCoordinate { get }

				associatedtype AreaLocation = LocationEntity
				var locations: [AreaLocation]? { get }
}

public extension AreaEntity {
				var locations: [AreaLocation]? { nil }
}
