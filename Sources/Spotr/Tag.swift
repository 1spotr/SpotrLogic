//
//  Tag.swift
//  Spotr
//
//  Created by Marcus on 03/05/2022.
//

import Foundation

public struct Tag: Identifiable, Codable, Hashable {

				public init(id: String, name: String, childrenIDs: [Tag.ID]?, parentsIDs: [Tag.ID]?, relativesIDs: [Tag.ID]?, siblingsIDs: [Tag.ID]?) {
								self.id = id
								self.name = name
								self.childrenIDs = childrenIDs
								self.parentsIDs = parentsIDs
								self.relativesIDs = relativesIDs
								self.siblingsIDs = siblingsIDs
				}

				public typealias ID = String

				public let id: ID

				public let name: String

				public let childrenIDs : [ID]?

				public let parentIDS : [ID]?

				public let siblingsIDs : [ID]?
}
