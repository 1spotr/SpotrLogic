//
//  SpotrNotification.swift
//  SpotrLogic
//
//  Created by Johann Petzold on 14/12/2021.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

public struct SpotrNotification: Identifiable, Codable, Hashable {
    public let id: String
    public let createdAt: Date
    public let localizationKey: String
    public let localizedTitle: String
    public let localizedBody: String
    public let deepLink: String
    
    // MARK: Equatable
    public static func == (lhs: SpotrNotification, rhs: SpotrNotification) -> Bool {
        lhs.id == rhs.id
    }
    
    // MARK: Hashable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
