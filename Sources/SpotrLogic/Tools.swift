//
//  Tools.swift
//  SpotrLogic
//
//  Created by Marcus on 30/07/2021.
//

import Foundation


func configure(firebase firebaseConfig: URL?, testing: Bool = false) -> Void {

    configureFirebase(with: firebaseConfig, testing: testing)
}
