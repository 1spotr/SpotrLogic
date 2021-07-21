//
//  File.swift
//  
//
//  Created by Marcus on 21/07/2021.
//

import Foundation

struct FeaturedSpots: Codable {
    let result: [Result]?
    let count: Int?

    struct Result: Codable {
        let spot: Spot?
    }
}
