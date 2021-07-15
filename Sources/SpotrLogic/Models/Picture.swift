//
//  Picture.swift
//  SpotrLogic
//
//  Created by Marcus on 29/06/2021.
//  Copyright © 2021 Spotr. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift

public struct Picture: Identifiable, Codable, Hashable {

    public private(set) var id: String?
    public let url: URL?
    public let author: User?
    public let created: Date?

    // MARK: Equtable

    public static func == (lhs: Picture, rhs: Picture) -> Bool {
        lhs.id == rhs.id
    }
}
