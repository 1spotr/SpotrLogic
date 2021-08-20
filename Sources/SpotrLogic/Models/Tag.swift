//
//  Tag.swift
//  SpotrLogic
//
//  Created by Marcus on 29/06/2021.
//  Copyright © 2021 Spotr. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift

// MARK: - Tag

public struct Tag: Identifiable, Codable, Hashable {

    public typealias ID = String

    public var id: String

    public let name: String
    public let index: Int?
    public let picture: Tag.Picture?


    public init(id: String, name: String, picture: Picture? = nil) {
        self.id = id
        self.name = name
        self.index = nil
        self.picture = picture
    }

    // MARK: - Tag Picture

    public struct Picture: Identifiable, Codable, Hashable {

        public private(set) var id: String?
        public let url: URL?
        public let author: User?
        //    public let created: Timestamp
        //    public let updated: Timestamp


        // MARK: Equtable

        public static func == (lhs: Picture, rhs: Picture) -> Bool {
            lhs.id == rhs.id
        }

        // MARK: - Coding

        enum CodingKeys: String, CodingKey {
            case id
            case url
            case author
            //        case created = "dt_create"
            //        case updated = "dt_update"
        }
    }


    // MARK: - Tags

    // MARK: Collection

    static let collection = firestore.collection("tags")
}
