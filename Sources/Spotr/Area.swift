//
//  Area.swift
//  Spotr
//
//  Created by Marcus on 12/05/2022.
//

import Foundation
import CoreLocation

public protocol Area: Entity {

				// The area name
				var name: String { get }


				associatedtype AreaPicture = Picture
				var pictures: [AreaPicture] { get }

				associatedtype AreaCoordinate = Coordinate
				var coordinate: AreaCoordinate { get }

				associatedtype AreaLocation = Location
				var locations: [AreaLocation] { get }
}
