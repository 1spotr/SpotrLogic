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
public func confirgureFirebase() -> Void {

    FirebaseApp.configure()
}

let firestore : Firestore = Firestore.firestore()
