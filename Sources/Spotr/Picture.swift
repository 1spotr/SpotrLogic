//
//  Picture.swift
//  Spotr
//
//  Created by Marcus on 12/05/2022.
//

import Foundation

// MARK: - Picture

public protocol Picture: Entity {

				var url: URL? { get }

				associatedtype Author = User
				var author: Author? { get }

				var created: Date { get }
				var updated: Date { get }
}


