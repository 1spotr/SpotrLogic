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
				public init(id: String, createdAt: Date, localizationKey: String, localizedTitle: String, localizedBody: String, deepLink: String,
																thumbnail: String? = nil, icon: String? = nil
				) {
								self.id = id
								self.createdAt = createdAt
								self.localizationKey = localizationKey
								self.localizedTitle = localizedTitle
								self.localizedBody = localizedBody
								self.deepLink = deepLink
								self.thumbnail = thumbnail
								self.icon = icon
				}

    public var id: String
    public var createdAt: Date
    public var localizationKey: String
    public var localizedTitle: String
    public var localizedBody: String
    public var deepLink: String
				public var thumbnail: String?
				public var icon: String?

    public init(dummy: Bool) {
        self.id = UUID().uuidString
        self.localizedBody = "Test boyd notification \(Int.random(in: 0...100))"
        self.localizedTitle = "Test title notification \(Int.random(in: 0...100))"
        self.localizationKey = "Test_localized_key"
        self.createdAt = Date()
        self.deepLink = "deepLink"
								self.thumbnail = nil
								self.icon = nil
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
