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
import FirebaseFunctions

public class SpotrLogic {

    public let logger: Logger

    private var functions = Functions.functions(region: Function.Regions.europeWest.rawValue)

    public init(logger: Logger) {
        self.logger = logger
        
    }

    // MARK: - Authentications

    private var auth : Auth? = nil

    /// Login anonymously.
    public func loginAnonymously(completion: @escaping(Result<Void, Error>)-> Void) -> Void {
        let loginAuth = Auth.auth()

        loginAuth.signInAnonymously { authData, error in
            do {
                // Check if the query resolved with an error
                if let error = error {
                    throw error
                }

                if authData == nil {
                    throw AuthErrors.failed
                }
                self.auth = loginAuth
                completion(.success(()))
            } catch {
                completion(.failure(self.handle(error: error)))
            }
        }
    }

    /// Login with user credential (email & password
    /// - Parameters:
    ///   - credential: The user credentials (email & password)
    ///   - completion: The auth completion response
    public func login(with credential: URLCredential,
                      completion: @escaping(Result<Void, Error>)-> Void) throws -> Void {

        guard let email = credential.user, let password = credential.password else {
            throw AuthErrors.missingCredentials
        }

        let loginAuth = Auth.auth()

        loginAuth.signIn(withEmail: email, password: password) { authResult, error in
            do {
                // Check if the query resolved with an error
                if let error = error {
                    throw error
                }

                if authResult == nil {
                    throw AuthErrors.failed
                }

                self.auth = loginAuth
                completion(.success(()))
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

    public func featuredSpots(for area: Area,
                              completion: @escaping(Result<[Spot], Error>) -> Void) throws {

        guard let areaID = area.id else { throw  QueryErrors.noGetterID }

        functions.httpsCallable(Function.getFeatured.rawValue).call(["area_id" : areaID]) { result, error in
            do {
                // Check if the query resolved with an error
                if let error = error {
                    throw error
                }

                guard let dict = result?.data as? [String: Any] else {
                    throw QueryErrors.noDocuments
                }
                let result = try decoderFirestore.decode(FeaturedSpots.self, from: dict)

                guard let spots = result.result?.compactMap(\.spot) else {
                    throw QueryErrors.undecodable(document: nil)
                }

                completion(.success(.init(spots)))
            } catch {
                completion(.failure(self.handle(error: error)))
            }
        }

    }


    // MARK: - Errors

    public enum AuthErrors: Error {
        case failed
        case missingCredentials
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
