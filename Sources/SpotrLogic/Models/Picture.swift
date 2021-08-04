//
//  Picture.swift
//  SpotrLogic
//
//  Created by Marcus on 29/06/2021.
//  Copyright © 2021 Spotr. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

public struct Picture: Identifiable, Codable, Hashable {

    public private(set) var id: String?
    public let url: URL?
    public let author: User?
    public let created: Timestamp
    public let updated: Timestamp


    // MARK: Equtable

    public static func == (lhs: Picture, rhs: Picture) -> Bool {
        lhs.id == rhs.id
    }

    // MARK: - Coding

    enum CodingKeys: String, CodingKey {
        case id
        case url = "img_url"
        case author
        case created = "dt_create"
        case updated = "dt_update"
    }


    // MARK: - Pictures

    // MARK: Collection

    static var collection = firestore.collection("pictures")
}
