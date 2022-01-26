//
//  AddASpot.swift
//  
//
//  Created by Johann Petzold on 24/01/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct CreateSpotSuggestionCommand: Encodable {
    
    typealias PayloadType = Payload
    
    struct GeolocationPayload: Codable {
        let latitude: Double
        let longitude: Double
    }
    
    struct SpotPayload: Codable {
        let name: String
        let geolocation: GeolocationPayload
    }
    
    struct Payload: Codable {
        let id: String
        let author_id: String
        let pictures: [PayloadPicture]
        let spot: SpotPayload
    }
    
    let type: String = "content_suggestions.spots.create"
    let version: String = "1.0.0"
    let payload: Payload
    
    var id: String = "\(Date().timeIntervalSince1970)_\(UUID().uuidString)"
    var timestamp: Timestamp = Timestamp(date: Date())
    var trace_id: String = UUID().uuidString
    var event_id: String? = "null"
    var origin: String = "ios"
    var origin_version: Int? = 144
    
    init(id: String, author_id: String, pictures: [PayloadPicture], name: String, latitude: Double, longitude: Double) {
        let geo = GeolocationPayload(latitude: latitude, longitude: longitude)
        let spot = SpotPayload(name: name, geolocation: geo)
        self.payload = Payload(id: id, author_id: author_id, pictures: pictures, spot: spot)
    }
    
    static let collection = firestore.collection("commands_content_suggestions")
}

class CreatePictureSuggestionCommand: Encodable {
    
    typealias PayloadType = Payload
    
    struct Payload: Codable {
        let id: String
        let author_id: String
        let pictures: [PayloadPicture]
        let spot_id: String
    }
    
    let type: String = "content_suggestions.pictures.create"
    let version: String = "1.0.0"
    let payload: Payload
    
    var id: String = "\(Date().timeIntervalSince1970)_\(UUID().uuidString)"
    var timestamp: Timestamp = Timestamp(date: Date())
    var trace_id: String = UUID().uuidString
    var event_id: String? = "null"
    var origin: String = "iOS"
    var origin_version: Int? = 144
    
    init(id: String, author_id: String, pictures: [PayloadPicture], spot_id: String) {
        self.payload = Payload(id: id, author_id: author_id, pictures: pictures, spot_id: spot_id)
    }
    
    static let collection = firestore.collection("commands_content_suggestions")
}

public struct PayloadPicture: Codable {
    let url: String
    let storage_id: String
}
