//
//  Location.swift
//  SpotrLogic
//
//  Created by Marcus on 29/06/2021.
//  Copyright © 2021 Spotr. All rights reserved.
//

import Foundation

public struct Location: Codable {
    enum CodingKeys: String, CodingKey {
        case neighbourhood = "neighbourhood"
        case city = "locality"
        case region = "administrative_area_level_1"
        case country = "country"
    }

    public let neighbourhood: LocationNames?
    public let city: LocationNames?       // 10km+
    public let region: LocationNames?     // 100km+
    public let country: LocationNames?    // other country
}

public struct LocationNames: Codable {

    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
    }

    public let longName: String
}
