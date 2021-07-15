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
    public let id: String?
    public let name: String
    public let pictureId: String?
    public let pictureUrl: URL?
    public let index : Int?

    public init(id: String, name: String, pictureId: String? = nil, pictureUrl: URL? = nil) {
        self.id = id
        self.name = name
        self.pictureId = pictureId
        self.pictureUrl = pictureUrl
        self.index = nil
    }

    // MARK: - Tags

    // MARK: Collection

    static let collection = firestore.collection("tags")
}
