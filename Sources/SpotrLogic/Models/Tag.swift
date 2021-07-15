//
//  Tag.swift
//  SpotrLogic
//
//  Created by Marcus on 29/06/2021.
//  Copyright © 2021 Spotr. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift

public struct Tag: Identifiable, Codable, Hashable {
    public private(set) var id: String?
    public let name: String
    public let pictureId: String?
    public let pictureUrl: URL?

    public init(id: String, name: String, pictureId: String? = nil, pictureUrl: URL? = nil) {
        self.id = id
        self.name = name
        self.pictureId = pictureId
        self.pictureUrl = pictureUrl
    }
}
