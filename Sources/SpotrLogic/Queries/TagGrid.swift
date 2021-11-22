//
//  TagGrid.swift
//  SpotrLogic
//
//  Created by Marcus on 15/07/2021.
//

import Foundation
import FirebaseFirestoreSwift

// MARK: - TagGrid

public struct TagGrid: Identifiable, Codable, Hashable {

    public let id: Area.ID?

    public let tags: [TagGrid.Tag]

    // MARK: - TagGrids


    // MARK: - Tag

    public struct Tag: Identifiable, Codable, Hashable {

        public typealias ID = String

        public var id: String

        public let name: String
        public let index: Int?
        public let picture: Picture?


        public init(id: String, name: String, picture: Picture? = nil) {
            self.id = id
            self.name = name
            self.index = nil
            self.picture = picture
        }
    }


    // MARK: Collection

    static let collection = firestore.collection("tags_grids")

}
