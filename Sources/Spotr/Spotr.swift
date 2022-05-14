//
//  Spotr.swift
//  Spotr
//
//  Created by Marcus on 25/04/2022.
//

import Foundation

public protocol Entity: Identifiable, Hashable {

				var id: ID { get }
}


public typealias ID = String?
