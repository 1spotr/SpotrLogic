//
//  LocalUser.swift
//  SpotrLogic
//
//  Created by Marcus on 16/08/2021.
//

import Foundation
import FirebaseFirestore



public class LoggedUser: ObservableObject {

    public let id : String
    
    @Published public internal(set) var privateMetadata: PrivateMetadata?
    @Published public internal(set) var publicMetadata: User?

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
    
    init(id: String) {
        self.id = id
        self.privateMetadata = nil
        self.publicMetadata = nil
    }
}


