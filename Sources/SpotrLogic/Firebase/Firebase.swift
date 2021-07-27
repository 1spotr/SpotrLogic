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

//    FirebaseApp.configure(options: .init(googleAppID: <#T##String#>, gcmSenderID: <#T##String#>))

    if let file = file, let options = FirebaseOptions(contentsOfFile: file.path) {
        FirebaseApp.configure(options: options)
    } else {
        FirebaseApp.configure()
    }


    if testing {
        let settings = Firestore.firestore().settings
        settings.host = ProcessInfo.processInfo.environment["HOST"] ?? "localhost:8080"
        settings.isPersistenceEnabled = false
        settings.isSSLEnabled = false
        firestore.settings = settings
    }

}

let firestore : Firestore = Firestore.firestore()


// MARK: - Coding

/// Firestore encoder.
let encoderFirestore : Firestore.Encoder = .init()

/// Firestore decoder.
let decoderFirestore : Firestore.Decoder = .init()
