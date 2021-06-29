//
//  Picture.swift
//  SpotrLogic
//
//  Created by Marcus on 29/06/2021.
//  Copyright © 2021 Spotr. All rights reserved.
//

import Foundation

struct Picture: Codable {
    let id: String?
    let url: URL?
    let author: User?
    let created: Date?
}
