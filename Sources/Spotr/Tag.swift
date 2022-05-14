//
//  Tag.swift
//  Spotr
//
//  Created by Marcus on 03/05/2022.
//

import Foundation

public protocol Tag: Entity {

				var name: String { get }

				var children: [Self]? { get }

				var parents: [Self]? { get }

				var relatives: [Self]? { get }

				var siblings: [Self]? { get }
}
