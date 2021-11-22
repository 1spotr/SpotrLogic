//
//  Area.swift
//  SpotrLogic
//
//  Created by Marcus on 12/07/2021.
//

import Foundation
import FirebaseFirestoreSwift

public struct Area: Codable, Identifiable, Hashable {

    public typealias ID = String?

    public private(set) var id: ID
    public let name: String
    public let pictures: [Picture]
//    let pin_geolocation: GeoPoint
    public let locations: [Location]

    // MARK: Equatable

    public static func == (lhs: Area, rhs: Area) -> Bool {
        lhs.id == rhs.id
    }


    // MARK: - Areas

    /// Get the the best area for the user region locales
    /// - Parameter areas: The set of areas to search
    /// - Returns: The best area.
    public static func areaForRegion(in areas: [Area]) -> Area? {
        let locale = Locale.autoupdatingCurrent

        var city : String? = nil
        switch locale.regionCode {
            /// *France* region.
            case "FR": city = "Paris"
            /// *United Kingdom* region.
            case "GB": city = "London"
            /// *Spain* region.
            case "SP": city = "Barcelona"
            /// *Germany* region.
            case "DE": city = "Berlin"
            /// *Canada* region.
            case "CA": city = "Montreal"
            /// *Singapore* region.
            case "SG": city = "Singapore"
            /// *Belgium* region.
            case "BE": city = "Brussels"
            default: city = "Paris"
        }

        return areas.first(where: { $0.name == city })
            ?? areas.first(where: { $0.name == "Paris" })
    }

    // MARK: Collection

    static let collection = firestore.collection("areas")

}
