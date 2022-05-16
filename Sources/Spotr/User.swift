//
//  User.swift
//  Spotr
//
//  Created by Marcus on 12/05/2022.
//

import Foundation

public protocol UserEntity: Entity {

				associatedtype Social = UserSocialValue

				var username: String? { get }
				var profilePictureURL: URL? { get }
				var social: Social? { get }
}

public protocol UserSocialValue: Codable, Hashable {
				var instagram: String? { get }
}

/// Optional fields
public extension UserEntity {

				var social: Social? {
								nil
				}
}
