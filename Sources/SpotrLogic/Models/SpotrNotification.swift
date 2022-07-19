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

    public init(dummy: Bool) {
        self.id = UUID().uuidString
        self.localizedBody = "Test boyd notification \(Int.random(in: 0...100))"
        self.localizedTitle = "Test title notification \(Int.random(in: 0...100))"
        self.localizationKey = "Test_localized_key"
        self.createdAt = Date()
        self.deepLink = "deepLink"
    }

    // MARK: Equatable
    public static func == (lhs: SpotrNotification, rhs: SpotrNotification) -> Bool {
        lhs.id == rhs.id
    }
    
    // MARK: Hashable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
