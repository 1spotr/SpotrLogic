//
//  Tag.swift
//  Spotr
//
//  Created by Marcus on 03/05/2022.
//

import Foundation

public protocol TagEntity: Entity {

				var name: String { get }

				associatedtype Thumbnail = PictureEntity
				var thumbnail: Thumbnail? { get }

				var children: [Self]? { get }

				var parents: [Self]? { get }

				var relatives: [Self]? { get }

				var siblings: [Self]? { get }
}


// Optional fields
public extension TagEntity {

				var thumbnail: URL? {
								nil
				}

				var children: [Self]? {
								nil
				}

				var parents: [Self]? {
								nil
				}

				var relatives: [Self]? {
								nil
				}

				var siblings: [Self]? {
								nil
				}
}
