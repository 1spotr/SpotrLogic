//
//  User.swift
//  Spotr
//
//  Created by Marcus on 12/05/2022.
//

import Foundation

public protocol User: Entity {

				associatedtype Social = UserSocial

				var username: String? { get }
				var profilePictureURL: URL? { get }
				var social: Social { get }
}

public protocol UserSocial: Codable, Hashable {
				var instagram: String? { get }
}

