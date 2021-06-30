//
//  User.swift
//  SpotrLogic
//
//  Created by Marcus Florentin on 13/06/2021.
//  Copyright © 2021 Spotr. All rights reserved.
//

import Foundation

public class User: Codable {
    public let id : String
    public let username : String
    public let profilePictureURL : URL?

	enum CodingKeys: String, CodingKey {
		case id
		case username
		case profilePictureURL = "profilePictureUrl"
	}
}
