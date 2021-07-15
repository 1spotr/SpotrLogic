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

    public let id: String?

    public let tags: [Tag]

    // MARK: - TagGrids

    // MARK: Collection

    static let collection = firestore.collection("tags_grids")

}
