//
//  SpotrLogic.swift
//  SpotrLogic
//
//  Created by Marcus on 29/06/2021.
//  Copyright © 2021 Spotr. All rights reserved.
//

import Foundation
import Logging

// Firebase
import FirebaseFirestoreSwift
import FirebaseAuth
import CryptoKit

public class SpotrLogic {

    public let logger: Logger


    public init(logger: Logger) {
        self.logger = logger
        
    }

    // MARK: - Authentications

    private var auth : Auth? = nil

    public var isLogged : Bool {
        auth?.currentUser != nil
    }

    /// Restore properties
    public func restore() -> Void {
        auth = Auth.auth()
    }

    public enum Authentication {
        case apple(token: String)
        case facebook(accessToken: String)
    }

    private let nonce : String? = {
        let nonce = AES.GCM.Nonce()
        let nonceData = Data(nonce)
        let text = String(data: nonceData, encoding: .utf8)
        return text
    }()

    private func credentials(_ authentication: Authentication) -> AuthCredential {
        switch authentication {
            case .apple(let token):
                return OAuthProvider.credential(withProviderID: "apple.com", idToken: token, rawNonce: nonce)
            case .facebook(let accessToken):
                return FacebookAuthProvider.credential(withAccessToken: accessToken)
        }
    }

    /// Handle an authencation (or error) result.
    /// - Parameters:
    ///   - currentAuth: The auth used.
    ///   - authResult: The authentication result.
    ///   - error: The authentication error
    ///   - completion: The callback to call.
    private func handleAuthResult(currentAuth: Auth,
                                  authResult: AuthDataResult?, error: Error?,
                                  completion: @escaping(Result<Void, Error>)-> Void) {
        do {
            // Check if the query resolved with an error
            if let error = error {
                throw error
            }
            if authResult == nil {
                throw AuthErrors.failed
            }

            self.auth = currentAuth
            completion(.success(()))
        } catch {
            completion(.failure(self.handle(error: error)))
        }
    }

    /// Authenticate an user using a third-party.
    /// - Parameters:
    ///   - authentication: The third party auth result.
    ///   - completion: The auth completion response.
    func OAuth(_ authentication: Authentication,
               completion: @escaping(Result<Void, Error>)-> Void) {

        let creds = credentials(authentication)

        let remoteAuth = Auth.auth()

        remoteAuth.signIn(with: creds) { authResult, error in
            self.handleAuthResult(currentAuth: remoteAuth,
                             authResult: authResult, error: error,
                             completion: completion)
        }
    }

    // MARK: Sign

    /// Sign an user.
    /// - Parameters:
    ///   - credential: The credentials to use for the user.
    ///   - completion: The auth completion response.
    public func sign(with credential: URLCredential,
                     completion: @escaping(Result<Void, Error>)-> Void) throws {
            guard let email = credential.user, let password = credential.password else {
                throw AuthErrors.missingCredentials
            }

        let signAuth = Auth.auth()

        signAuth.createUser(withEmail: email, password: password) { authResult, error in
            self.handleAuthResult(currentAuth: signAuth,
                                  authResult: authResult, error: error,
                                  completion: completion)
        }
    }


    // MARK: Login

    /// Login anonymously.
    public func loginAnonymously(completion: @escaping(Result<Void, Error>)-> Void) -> Void {
        let loginAuth = Auth.auth()

        loginAuth.signInAnonymously { authResult, error in
            self.handleAuthResult(currentAuth: loginAuth,
                                  authResult: authResult, error: error,
                                  completion: completion)
        }
    }

    /// Login with user credential (email & password).
    /// - Parameters:
    ///   - credential: The user credentials (email & password).
    ///   - completion: The auth completion response.
    public func login(with credential: URLCredential,
                      completion: @escaping(Result<Void, Error>)-> Void) throws {

        guard let email = credential.user, let password = credential.password else {
            throw AuthErrors.missingCredentials
        }

        let loginAuth = Auth.auth()

        loginAuth.signIn(withEmail: email, password: password) { authResult, error in
            self.handleAuthResult(currentAuth: loginAuth,
                                  authResult: authResult, error: error,
                                  completion: completion)
        }
    }

    // MARK: - Local User


    // MARK: Favorites

    public func listenUserFavorites(completion: @escaping(Result<[Spot], Error>)->Void) throws -> Void {
        guard let localUser = auth?.currentUser else {
            throw AuthErrors.notAuthenticated
        }


        Interaction.collection
            .whereField("hidden", isEqualTo: false)
            .whereField("type", isEqualTo: Interaction.Types.favorite.rawValue)
            .whereField("author.id", isEqualTo: localUser.uid)
            .addSnapshotListener { (query, error) in
                do {
                    // Check if the query resolved with an error
                    if let error = error {
                        throw error
                    }

                    guard let documents = query?.documents else { throw QueryErrors.noDocuments }

                    let result = try documents.compactMap({ try $0.data(as: Interaction.self) })

                    completion(.success(result.map(\.spot)))
                } catch {
                    completion(.failure(self.handle(error: error)))
                }

            }
    }



    // MARK: - Areas

    public func areas(completion: @escaping(Result<Set<Area>, Error>) -> Void) -> Void {
        Area.collection.getDocuments { query, error in
            do {
                // Check if the query resolved with an error
                if let error = error {
                    throw error
                }

                guard let documents = query?.documents else { throw QueryErrors.noDocuments }

                let result = try documents.compactMap({ try $0.data(as: Area.self) })

                completion(.success(.init(result)))
            } catch {
                completion(.failure(self.handle(error: error)))
            }
        }
    }

    // MARK: - Tag

    public func tags(for area: Area, completion: @escaping(Result<Set<Tag>, Error>) -> Void) throws {
        guard let areaID = area.id else { throw  QueryErrors.noGetterID }

        TagGrid.collection.document(areaID).getDocument { document, error in
            do {
                // Check if the query resolved with an error
                if let error = error {
                    throw error
                }

                guard let document = document else { throw QueryErrors.noDocuments }

                guard let result = try document.data(as: TagGrid.self) else {
                    throw QueryErrors.undecodable(document: document.documentID)
                }

                completion(.success(.init(result.tags)))
            } catch {
                completion(.failure(self.handle(error: error)))
            }
        }
    }

    // MARK: - Spots

    public func featuredSpots(for area: Area, limit : Int = 5,
                              completion: @escaping(Result<[Spot], Error>) -> Void) throws {

        guard let areaID = area.id else { throw  QueryErrors.noGetterID }



        Spot.collection
            .whereField("areas_ids", arrayContains: areaID)
            .whereField("discover", isEqualTo: true)
            .order(by: "dt_update", descending: true)
            .limit(to: limit)
            .getDocuments { query, error in
                do {
                    // Check if the query resolved with an error
                    if let error = error {
                        throw error
                    }

                    guard let documents = query?.documents else { throw QueryErrors.noDocuments }

                    let result = try documents.compactMap({ try $0.data(as: Spot.self) })

                    completion(.success(.init(result)))
                } catch {
                    completion(.failure(self.handle(error: error)))
                }
            }

    }


    // MARK: - Pictures

    public func pictures(for spot: Spot,
                  completion: @escaping(Result<[Picture], Error>) -> Void) throws {

        guard let spotID = spot.id else { throw QueryErrors.noGetterID }


        Picture.collection
            .whereField("spot_id", isEqualTo: spotID)
            .whereField("valid", isEqualTo: true)
            .order(by: "dt_update", descending: true)
            .limit(to: 10)
            .getDocuments { query, error in

                do {
                    // Check if the query resolved with an error
                    if let error = error {
                        throw error
                    }

                    guard let documents = query?.documents else { throw QueryErrors.noDocuments }

                    let result = try documents.compactMap({ try $0.data(as: Picture.self) })

                    completion(.success(.init(result)))
                } catch {
                    completion(.failure(self.handle(error: error)))
                }
            }
    }



    // MARK: - Errors

    public enum AuthErrors: Error {
        case failed
        case missingCredentials
        case notAuthenticated
    }

    public enum QueryErrors: Error {
        case noDocuments
        case noGetterID
        case undecodable(document: String?)
    }

    private func handle(error: Error) -> Error {
        error
    }

}
