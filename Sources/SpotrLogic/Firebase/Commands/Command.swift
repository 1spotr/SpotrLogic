//
//  File.swift
//  
//
//  Created by Marcus on 23/08/2021.
//

import Foundation

import FirebaseFirestore
import FirebaseFirestoreSwift

protocol CommandDataProtocol {

    associatedtype PayloadType: Codable

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

final class CommandService<A: CommandProtocol> {

    private let command: A

    init(command: A) {
        self.command = command
    }

    func export() -> [String: Any] {
        let dict: [String: Any] = [
            "id": command.data.id,
            "timestamp": command.data.timestamp,
            "type": command.data.type,
            "version": command.data.version,
            "trace_id": command.data.trace_id,
            "event_id": command.data.event_id as Any,
            "origin": command.data.origin,
            "origin_version": command.data.origin_version as Any,
            "payload": command.data.payload as Any,
        ]
        return dict
    }

    func perform(completion: ((Error?) -> Void)? = nil) {
        
        Firestore.firestore()
            .collection(command.collection)
            .document(UUID().uuidString)
            .setData(export(), completion: completion)
    }
}
