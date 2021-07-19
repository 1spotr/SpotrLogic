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
    public let index: Int?
    public let picture: Picture?

    public init(id: String, name: String, picture: Picture? = nil) {
        self.id = id
        self.name = name
        self.index = nil
        self.picture = picture
    }

    // MARK: - Tags

    // MARK: Collection

    static let collection = firestore.collection("tags")
}
