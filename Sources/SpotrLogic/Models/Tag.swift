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

    // MARK: Relations

    public let childrenIDs : [ID]?

    public let parentsIDs : [ID]?

    public let relativesIDs : [ID]?

    public let siblingsIDs : [ID]?

    public init(id: String, name: String, picture: Picture? = nil) {
        self.id = id
        self.name = name
        self.index = nil
        self.picture = picture
    }

    // MARK: Coding

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case childrenIDs = "children_ids"
        case parentsIDs = "parents_ids"
        case relativesIDs = "relatives_ids"
        case siblingsIDs = "siblings_ids"
    }


    // MARK: - Tags

    // MARK: Collection

    static let collection = firestore.collection("tags")
}
