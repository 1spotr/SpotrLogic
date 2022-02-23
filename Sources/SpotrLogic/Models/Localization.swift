//
//  Localization.swift
//  
//
//  Created by Marcus on 19/02/2022.
//

import Foundation

/// A entity for application locazization.
public struct Localization: Codable, Identifiable, Hashable {
				/// The localization id.
				public let id: String
				/// The localization value with language id.
				public let values: [String : String]
}
