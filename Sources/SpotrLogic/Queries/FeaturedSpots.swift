//
//  File.swift
//  
//
//  Created by Marcus on 21/07/2021.
//

import Foundation

// MARK: - Featured Spots

struct FeaturedSpots: Decodable {

    let result: [Result]?
    let count: Int?

    // MARK: - Featured spots result

    struct Result: Decodable {

        enum ResultType: String, Codable {
            case spot
            case event
        }

        /// "event" or "spot"
        let type: ResultType
        let spot: Spot?


        // MARK: Coding

        enum CodingKeys: String, CodingKey {
            case type, item
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self) // defining our (keyed) container
            type = try container.decode(ResultType.self, forKey: .type)

            switch type {
                case .spot:
                    spot = try container.decode(Spot.self, forKey: .item)
                default:
                    spot = nil
            }
        }


    }

}
