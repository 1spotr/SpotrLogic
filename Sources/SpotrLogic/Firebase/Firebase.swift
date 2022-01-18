//
//  Firebase.swift
//  SpotrLogic
//
//  Created by Marcus on 29/06/2021.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAnalytics
import FirebaseStorage

/// Call this fontion to configure _Firebase_
public func configureFirebase(with file: URL? = nil, testing: Bool = false) -> Void {
    
    
    if let file = file, let options = FirebaseOptions(contentsOfFile: file.path) {
        FirebaseApp.configure(options: options)
    } else {
        FirebaseApp.configure()
    }
    
    
#if DEBUG
    if testing {
        Auth.auth().useEmulator(withHost: "localhost", port: 9099)
        Storage.storage().useEmulator(withHost: "localhost", port: 9199)
        let settings = firestore.settings
        settings.host = ProcessInfo.processInfo.environment["HOST"] ?? "localhost:8080"
        settings.isPersistenceEnabled = false
        settings.isSSLEnabled = false
        firestore.settings = settings
        firestore.useEmulator(withHost: "localhost", port: 8080)
        
    }
#endif

}

var firestore : Firestore = Firestore.firestore()
var storage = Storage.storage().reference()


// MARK: - Coding

/// Firestore encoder.
let encoderFirestore : Firestore.Encoder = .init()

/// Firestore decoder.
let decoderFirestore : Firestore.Decoder = .init()
