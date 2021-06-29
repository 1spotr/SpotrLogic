//
//  User.swift
//  SpotrLogic
//
//  Created by Marcus Florentin on 13/06/2021.
//  Copyright © 2021 Spotr. All rights reserved.
//

import Foundation

class User: Codable {
	let id : String
	let username : String
	let profilePictureURL : String?

	enum CodingKeys: String, CodingKey {
		case id
		case username
		case profilePictureURL = "profilePictureUrl"
	}
}
