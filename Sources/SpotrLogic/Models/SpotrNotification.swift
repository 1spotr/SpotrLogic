//
//  Notification.swift
//  SpotrLogic
//
//  Created by Johann Petzold on 14/12/2021.
//

import Foundation

public struct Notification: Identifiable, Codable, Hashable {
				public init(id: String, createdAt: Date, localizationKey: String, localizedTitle: String, localizedBody: String, deepLink: String) {
								self.id = id
								self.createdAt = createdAt
								self.localizationKey = localizationKey
								self.localizedTitle = localizedTitle
								self.localizedBody = localizedBody
								self.deepLink = deepLink
				}

    public var id: String
    public var createdAt: Date
    public var localizationKey: String
    public var localizedTitle: String
    public var localizedBody: String
    public var deepLink: String

    // MARK: Equatable
    public static func == (lhs: Notification, rhs: Notification) -> Bool {
        lhs.id == rhs.id
    }
    
    // MARK: Hashable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
