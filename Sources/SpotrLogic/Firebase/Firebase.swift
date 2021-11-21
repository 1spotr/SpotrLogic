//
//  Firebase.swift
//  SpotrLogic
//
//  Created by Marcus on 29/06/2021.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

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
        let settings = Firestore.firestore().settings
        settings.host = ProcessInfo.processInfo.environment["HOST"] ?? "localhost:8080"
        settings.isPersistenceEnabled = false
        settings.isSSLEnabled = false
        firestore.settings = settings
    }
    #endif

}

let firestore : Firestore = Firestore.firestore()


// MARK: - Coding

/// Firestore encoder.
let encoderFirestore : Firestore.Encoder = .init()

/// Firestore decoder.
let decoderFirestore : Firestore.Decoder = .init()
