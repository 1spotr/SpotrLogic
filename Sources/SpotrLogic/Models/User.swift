//
//  User.swift
//  SpotrLogic
//
//  Created by Marcus Florentin on 13/06/2021.
//  Copyright © 2021 Spotr. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift

public class User: Identifiable, Codable, Hashable {

//    @DocumentID
    public var id : String?
    public let username : String
    public let profilePictureURL : URL?

    // MARK: Codable

	enum CodingKeys: String, CodingKey {
		case id
		case username
		case profilePictureURL = "profilePictureUrl"
	}

    // MARK: Equatable

    public static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }

    // MARK: Hashable

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}
