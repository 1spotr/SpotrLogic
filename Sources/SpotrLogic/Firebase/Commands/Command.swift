//
//  Command.swift
//  
//
//  Created by Marcus on 23/08/2021.
//

import Foundation

import FirebaseFirestore
import FirebaseFirestoreSwift

protocol Command: Encodable {

    var id : String { get }
    var timestamp : Timestamp { get }
    var trace_id: String { get }
    var version: String { get }
    var event_id: String? { get }
    var origin: String { get }
    var origin_version : Int? { get }

}

