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

    public typealias ID = String?

    public private(set) var id : ID
    public let username : String?
    public let profilePictureURL : URL?
    public let social: Social?
    
    public struct Social: Codable {
        public let instagram: Instagram?

        public struct Instagram: Codable {
            public let username: String?

            enum CodingKeys: String, CodingKey {
                case username
            }
        }
    }

    // MARK: Codable

	enum CodingKeys: String, CodingKey {
		case id
		case username
		case profilePictureURL = "profile_picture_url"
        case social
	}

    // MARK: Equatable

    public static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }

    // MARK: Hashable

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // MARK: - Users
    
    // MARK: Collection
    static let collection = firestore.collection("users_public_metadata")
}
