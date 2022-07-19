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
    public var id: String
    public var createdAt: Date
    public var localizationKey: String
    public var localizedTitle: String
    public var localizedBody: String
    public var deepLink: String
    
    // MARK: Equatable
    public static func == (lhs: SpotrNotification, rhs: SpotrNotification) -> Bool {
        lhs.id == rhs.id
    }
    
    // MARK: Hashable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
