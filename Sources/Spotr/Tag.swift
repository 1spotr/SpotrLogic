//
//  Tag.swift
//  Spotr
//
//  Created by Marcus on 03/05/2022.
//

import Foundation

public struct Tag: Identifiable, Codable, Hashable {
				public init(id: Tag.ID, name: String, childrenIDs: [Tag.ID]?, parentIDs: [Tag.ID]?, siblingsIDs: [Tag.ID]?) {
								self.id = id
								self.name = name
								self.childrenIDs = childrenIDs
								self.parentIDs = parentIDs
								self.siblingsIDs = siblingsIDs
				}


				public typealias ID = String

				public let id: ID

				public let name: String

				public let childrenIDs : [ID]?

				public let parentIDs : [ID]?

				public let siblingsIDs : [ID]?
}
