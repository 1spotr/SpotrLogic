//
//  LocalUser.swift
//  SpotrLogic
//
//  Created by Marcus on 16/08/2021.
//

import Foundation
import FirebaseFirestore

public class LoggedUser: ObservableObject, Codable {

    public var id : String
    
    @Published public internal(set) var privateMetadata: PrivateMetadata? = nil
    @Published public internal(set) var publicMetadata: User? = nil

    /// The user status (type).
    enum Status {
        /// A Free `User` is a user without a `SpotrPro` subscription.
        case free
        /// A `Pro User` is an user who unlock all premium services of Spotr.
        case pro
    }
    
    var status : Status? {
        guard let metadata = privateMetadata else { return nil }

        guard let latestSubscription = metadata.billing?.latestSubscription else { return .free }

        if latestSubscription.end > Date() {
            return .pro
        } else {
            return .free
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case privateMetadata
        case publicMetadata
    }
    
    
    init(id: String) {
        self.id = id
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(privateMetadata, forKey: .privateMetadata)
        try container.encode(publicMetadata, forKey: .publicMetadata)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        privateMetadata = try container.decode(PrivateMetadata.self, forKey: .privateMetadata)
        publicMetadata = try container.decode(User.self, forKey: .publicMetadata)
    }
}


