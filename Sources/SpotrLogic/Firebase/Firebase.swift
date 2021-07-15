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
public func configureFirebase(with file: URL? = nil) -> Void {

//    FirebaseApp.configure(options: .init(googleAppID: <#T##String#>, gcmSenderID: <#T##String#>))

    if let file = file, let options = FirebaseOptions(contentsOfFile: file.path) {
        FirebaseApp.configure(options: options)
    } else {
        FirebaseApp.configure()
    }
}

let firestore : Firestore = Firestore.firestore()
