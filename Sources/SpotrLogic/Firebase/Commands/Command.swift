//
//  File.swift
//  
//
//  Created by Marcus on 23/08/2021.
//

import Foundation

import FirebaseFirestore
import FirebaseFirestoreSwift

protocol CommandDataProtocol: Encodable {

    associatedtype PayloadType: Encodable

    var id: String { get }
    var timestamp: Timestamp { get }
    var type: String { get }
    var version: String { get }
    var trace_id: String { get }
    var event_id: String? { get }
    var origin: String { get }
    var origin_version: Int? { get }
    var payload: PayloadType { get }
}

extension CommandDataProtocol {

    var id: String {
        "\(Date().timeIntervalSince1970)_\(UUID().uuidString)"
    }
    var timestamp: Timestamp {
        Timestamp(date: Date())
    }
    var trace_id: String {
        UUID().uuidString
    }
    var event_id: String? {
        nil
    }
    var origin: String {
        "ios"
    }
    var origin_version: Int? {
        guard let str = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
            return nil
        }
        return Int(str)
    }
}

protocol CommandProtocol {

    associatedtype CommandData: CommandDataProtocol

    var collection: String { get }
    var data: CommandData { get }
}
