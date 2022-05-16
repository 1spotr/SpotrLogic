//
//  Coordinate.swift
//  Spotr
//
//  Created by Marcus on 14/05/2022.
//

import Foundation

public protocol CoordinateValue: Codable, Hashable {

				associatedtype FloatingValue = BinaryFloatingPoint
				var latitude: FloatingValue { get }
				var longitude: FloatingValue { get }
}
