//
//  Location.swift
//  SpotrLogic
//
//  Created by Marcus on 29/06/2021.
//  Copyright © 2021 Spotr. All rights reserved.
//

import Foundation

struct Location: Codable {
    enum CodingKeys: String, CodingKey {
        case neighbourhood = "neighbourhood"
        case city = "locality"
        case region = "administrative_area_level_1"
        case country = "country"
    }

    let neighbourhood: LocationNames?
    let city: LocationNames?       // 10km+
    let region: LocationNames?     // 100km+
    let country: LocationNames?    // other country
}

struct LocationNames: Codable {

    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
    }

    let longName: String
}
