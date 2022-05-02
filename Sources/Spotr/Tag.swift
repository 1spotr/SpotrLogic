//
//  Tag.swift
//  Spotr
//
//  Created by Marcus on 03/05/2022.
//

import Foundation

public struct Tag: Identifiable, Codable, Hashable {

				public typealias ID = String

				public let id: ID

				public let name: String

				public let childrenIDs : [ID]?

				public let parentIDS : [ID]?

				public let siblingsIDs : [ID]?
}
