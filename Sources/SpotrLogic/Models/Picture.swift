//
//  Picture.swift
//  SpotrLogic
//
//  Created by Marcus on 29/06/2021.
//  Copyright © 2021 Spotr. All rights reserved.
//

import Foundation

public struct Picture: Codable {
    public let id: String?
    public let url: URL?
    public let author: User?
    public let created: Date?
}
