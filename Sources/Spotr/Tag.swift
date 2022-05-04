//
//  Tag.swift
//  Spotr
//
//  Created by Marcus on 03/05/2022.
//

import Foundation

public struct Tag: Identifiable, Codable, Hashable {
				public init(id: Tag.ID, name: String, childrenIDs: [Tag.ID]?, parentsIDs: [Tag.ID]?, siblingsIDs: [Tag.ID]?) {
								self.id = id
								self.name = name
								self.childrenIDs = childrenIDs
								self.parentsIDs = parentsIDs
								self.siblingsIDs = siblingsIDs
				}


				public typealias ID = String

				public let id: ID

				public let name: String

				public let childrenIDs : [ID]?

				public let parentsIDs : [ID]?

				public let siblingsIDs : [ID]?

				// MARK: Coding

				enum CodingKeys: String, CodingKey {
								case id
								case name
								case childrenIDs = "children_ids"
								case parentsIDs = "parents_ids"
								case siblingsIDs = "siblings_ids"
				}
}
