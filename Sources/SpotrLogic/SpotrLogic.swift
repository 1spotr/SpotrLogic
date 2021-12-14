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
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

// Crypto
import CryptoKit

public class SpotrLogic {

    public let logger: Logger


    public init(logger: Logger) {
        self.logger = logger
        
    }

    // MARK: - Authentications

    private var auth : Auth? = nil

    public private(set) var loggedUser : LoggedUser?

    public var isLogged : Bool {
        auth?.currentUser != nil
    }

    /// Restore properties
    public func restore() throws -> Void {
        auth = Auth.auth()
        try listenLoggedUserChanges()
    }

    public enum Authentication {
        case apple(token: String)
        case facebook(accessToken: String)
    }

    public let nonce : String? = {
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
            try listenLoggedUserChanges()
        } catch {
            completion(.failure(self.handle(error: error)))
        }
    }

    /// Authenticate an user using a third-party.
    /// - Parameters:
    ///   - authentication: The third party auth result.
    ///   - completion: The auth completion response.
    public func OAuth(_ authentication: Authentication,
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

    /// Logout the Auth and remove the listenters.
    public func logout() throws -> Void {
        removeListeners()

        do {
            try auth?.signOut()
        } catch {
            throw handle(error: error)
        }
    }

    // MARK: - Logged User

    
    public func listenLoggedUserChanges() throws -> Void {
        loggedUser = .init()
        try listenLoggedUserPrivateMetadata()
    }


    func listenLoggedUserPrivateMetadata() throws -> Void {
        guard let id = auth?.currentUser?.uid else { throw AuthErrors.notAuthenticated }

        let registration = PrivateMetadata.collection
            .document(id)
            .addSnapshotListener { document, error in
                do {
                    // Check if the query resolved with an error
                    if let error = error {
                        throw error
                    }

                    guard let document = document else { throw QueryErrors.noDocuments }

                    guard let result = try document.data(as: PrivateMetadata.self) else {
                        throw QueryErrors.undecodable(document: document.documentID)
                    }
                    self.loggedUser?.privateMetadata = result

                } catch {
                    _ = self.handle(error: error)
                }
            }

        registrations.append(registration)
    }


    /// Set the local user instagram username.
    /// - Parameters:
    ///   - username: The instagram user name to set.
    ///   - completion: The completion result.
    public func setInstagram(username: String, completion: @escaping(Result<Void, Error>) -> Void) throws {
        guard let id = auth?.currentUser?.uid else { throw AuthErrors.notAuthenticated }

        let usernameCommand = SetUsernameInstagramCommand(user_id: id, instagram_username: username)

        try SetUsernameInstagramCommand.collection
            .document(UUID().uuidString)
            .setData(from: usernameCommand, encoder: encoderFirestore) { error in
                if let error = error {
                    completion(.failure(self.handle(error: error)))
                } else {
                    completion(.success(()))
                }
            }
    }
    
    /// Set the local user username.
    /// - Parameters:
    ///   - username: The username to set.
    ///   - completion: The completion result.
    public func setUsername(username: String, completion: @escaping(Result<Void, Error>) -> Void) throws {
        guard let id = auth?.currentUser?.uid else {
            throw AuthErrors.notAuthenticated }
        
        let usernameCommand = SetUsernameCommand(user_id: id, username: username)
        
        try SetUsernameCommand.collection
            .document(UUID().uuidString)
            .setData(from: usernameCommand, encoder: encoderFirestore, completion: { error in
                if let error = error {
                    completion(.failure(self.handle(error: error)))
                } else {
                    completion(.success(()))
                }
            })
    }
    
    /// Check if the Instagram username is available.
    /// - Parameters:
    ///   - username: The username to compare with.
    ///   - completion: The completion result.
    public func checkInstagramUsernameAvailable(username: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        User.collection
            .whereField("social.instagram.username", isEqualTo: username)
            .getDocuments(completion: { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                }
                guard let snapshot = snapshot else {
                    completion(.success(false))
                    return
                }
                completion(.success(snapshot.isEmpty))
            })
    }
    
    /// Check if the username is available.
    /// - Parameters:
    ///   - username: The username to compare with.
    ///   - completion: The completion result.
    public func checkUsernameAvailable(username: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        User.collection
            .whereField("username", isEqualTo: username)
            .getDocuments(completion: { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                }
                guard let snapshot = snapshot else {
                    completion(.success(false))
                    return
                }
                completion(.success(snapshot.isEmpty))
            })
    }
    
    // MARK: Settings
    
    /// Send email verification to user.
    /// - Parameter completion: The completion error result.
    public func sendEmailVerification(completion: @escaping (Result<Void, Error>) -> Void) {
        auth?.currentUser?.sendEmailVerification(completion: { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        })
    }
    
    /// Send email for password reset.
    /// - Parameters:
    ///   - email: The entered email.
    ///   - completion: The completion error result.
    public func sendPasswordResetEmail(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let resetAuth = Auth.auth()
        
        resetAuth.sendPasswordReset(withEmail: email, completion: { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        })
    }
    
    /// Update user email.
    /// - Parameters:
    ///   - password: The actual user password.
    ///   - newEmail: The user's new email.
    ///   - completion: The completion error result.
    public func updateUserEmail(password: String, newEmail: String, completion: @escaping (Result<Void, Error>) -> Void) throws {
        guard let currentUser = auth?.currentUser, let email = currentUser.email else {
            throw UserErrors.noCurrentUser
        }
        reauthenticate(with: email, password: password) { result in
            switch result {
            case .success:
                currentUser.updateEmail(to: newEmail) { error in
                    if error != nil {
                        completion(.failure(UpdateUserErrors.invalidEmail))
                    }
                    completion(.success(()))
                }
            case .failure:
                completion(.failure(UpdateUserErrors.failReauthenticate))
            }
        }
    }
    
    /// Update user password.
    /// - Parameters:
    ///   - password: The actual user password.
    ///   - newPassword: The new user password.
    ///   - completion: The completion error result.
    public func updateUserPassword(password: String, newPassword: String, completion: @escaping (Result<Void, Error>) -> Void) throws {
        guard let currentUser = auth?.currentUser, let email = currentUser.email else {
            throw UserErrors.noCurrentUser
        }
        reauthenticate(with: email, password: password) { result in
            switch result {
            case .success:
                currentUser.updatePassword(to: newPassword) { error in
                    if error != nil {
                        completion(.failure(UpdateUserErrors.weakPassword))
                    }
                    completion(.success(()))
                }
            case .failure:
                completion(.failure(UpdateUserErrors.failReauthenticate))
            }
        }
    }
    
    /// Reauthenticate the user to confirm provide credential.
    /// - Parameters:
    ///   - email: The user email.
    ///   - password: The user password.
    ///   - completion: The completion error result.
    private func reauthenticate(with email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        let signAuth = Auth.auth()
        
        auth?.currentUser?.reauthenticate(with: credential, completion: { authResult, error in
            self.handleAuthResult(currentAuth: signAuth,
                                  authResult: authResult, error: error,
                                  completion: completion)
        })
    }

    // MARK: Favorites

    public func listenUserFavorites(completion: @escaping(Result<[Spot], Error>)->Void) throws -> Void {
        guard let localUser = auth?.currentUser else {
            throw AuthErrors.notAuthenticated
        }


        let registration = Interaction.collection
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

        registrations.append(registration)
    }


    // MARK: - Favorites

    public func addToFavorite(spot: Spot, completion: @escaping(Result<Void, Error>)->Void) throws -> Void {
        let favoriteCommand = FavoriteCommand(id: UUID().uuidString, author_id: auth?.currentUser?.uid ?? "", spot_id: spot.id ?? "")

        try FavoriteCommand.collection
            .document(UUID().uuidString)
            .setData(from: favoriteCommand, encoder: encoderFirestore) { error in
                if let error = error {
                    completion(.failure(self.handle(error: error)))
                } else {
                    completion(.success(()))
                }
            }
    }


    public func removeFromFavorite(spot: Spot, completion: @escaping(Result<Void, Error>)->Void) throws -> Void {
        let favoriteCommand = DeleteFavoriteCommand(author_id: auth?.currentUser?.uid ?? "", spot_id: spot.id ?? "")

        try DeleteFavoriteCommand.collection
            .document(UUID().uuidString)
            .setData(from: favoriteCommand, encoder: encoderFirestore) { error in
                if let error = error {
                    completion(.failure(self.handle(error: error)))
                } else {
                    completion(.success(()))
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


    /// Set the user residence area in the user private metadata
    /// - Parameters:
    ///   - area: The seleted area.
    ///   - completion: The completion callbac
    public func setResidence(area: Area, completion: @escaping(Result<Void, Error>) -> Void) throws {
        guard let id = auth?.currentUser?.uid else { throw AuthErrors.notAuthenticated }

        guard let areaId = area.id else { throw QueryErrors.noGetterID }

        let areaCommand = AreaCommand(user_id: id, area_id: areaId)

        try AreaCommand.collection
            .document(UUID().uuidString)
            .setData(from: areaCommand, encoder: encoderFirestore) { error in
                if let error = error {
                    completion(.failure(self.handle(error: error)))
                } else {
                    completion(.success(()))
                }
            }
    }

    // MARK: - Tag

    public func tags(for area: Area, completion: @escaping(Result<[TagGrid.Tag], Error>) -> Void) throws {
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

                completion(.success(result.tags))
            } catch {
                completion(.failure(self.handle(error: error)))
            }
        }
    }


    public func tag(for id: Tag.ID, completion: @escaping(Result<Tag, Error>) -> Void) -> Void {

        Tag.collection.document(id).getDocument { documentResult, error in
            do {
                // Check if the query resolved with an error
                if let error = error {
                    throw error
                }

                guard let documentResult = documentResult else { throw QueryErrors.noDocuments }

                guard let result = try documentResult.data(as: Tag.self) else {
                    throw QueryErrors.undecodable(document: id)
                }

                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }

    }

    public func newSpot(for tag: Tag, in area: Area, limit : Int = 5,
                 completion: @escaping(Result<[Spot], Error>) -> Void) throws  -> Void {

        guard let areaID = area.id else { throw  QueryErrors.noGetterID }

        Spot.collection
            .whereField("areas_ids", arrayContains: areaID)
            .whereField("tags", arrayContains: tag.id)
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



    // MARK: - Spots

    public func newSpots(for area: Area, limit : Int = 5,
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

    public func popularSpots(for area: Area, limit : Int = 5,
                             completion: @escaping(Result<[Spot], Error>) -> Void) throws {

        guard let areaID = area.id else { throw  QueryErrors.noGetterID }



        Spot.collection
            .whereField("areas_ids", arrayContains: areaID)
            .whereField("discover", isEqualTo: true)
            .order(by: "interest_score", descending: true)
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


    /// Fetch the spot that the user contributed to.
    /// - Parameters:
    ///   - user: The user
    ///   - completion: The completion result.
    public func spots(for user: User?, completion: @escaping(Result<[Spot], Error>) -> Void) throws {
        guard let id = user?.id ?? self.auth?.currentUser?.uid else { return }

        Interaction.collection
            .whereField("hidden", isEqualTo: false)
            .whereField("type", isEqualTo: Interaction.Types.favorite.rawValue)
            .whereField("author.id", isEqualTo: id)
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
    
    // MARK: - Notifications
    
    /// Get all notifications from notifications collection.
    /// - Parameter completion: The completion result.
    public func allNotifications(completion: @escaping (Result<[SpotrNotification], Error>) -> Void) throws {
        SpotrNotification.notificationsCollection
            .order(by: "dt_create", descending: true)
            .getDocuments { query, error in
                do {
                    if let error = error {
                        throw error
                    }
                    
                    guard let documents = query?.documents else {
                        throw QueryErrors.noDocuments
                        
                    }
                    
                    let result = try documents.compactMap({ try $0.data(as: Notification.self )})
                    
                    completion(.success(.init(result)))
                } catch {
                    completion(.failure(self.handle(error: error)))
                }
            }
    }
    
    /// Check if user has unread notification.
    /// - Parameter completion: The completion result.
    public func hasUnreadNotification(completion: @escaping (Result<Bool, Error>) -> Void) throws {
        guard let id = loggedUser?.id else { throw UserErrors.noCurrentUser }
        SpotrNotification.notificationsCollectionForCurrentUser(id: id)
            .whereField("viewed", isEqualTo: false)
            .getDocuments { query, error in
                do {
                    if let error = error {
                        throw error
                    }
                    completion(.success(query?.count ?? 0 > 0))
                } catch {
                    completion(.failure(self.handle(error: error)))
                }
            }
    }
    
    /// Get all notifications for logged user.
    /// - Parameter completion: The completion result.
    public func notificationsForLoggedUser(completion: @escaping (Result<[SpotrNotification], Error>) -> Void) throws {
        guard let id = loggedUser?.id else { throw UserErrors.noCurrentUser }
        SpotrNotification.notificationsCollectionForCurrentUser(id: id)
            .order(by: "dt_create", descending: true)
            .getDocuments { query, error in
                do {
                    if let error = error {
                        throw error
                    }
                    
                    guard let documents = query?.documents else {
                        throw QueryErrors.noDocuments
                    }
                    
                    let result = try documents.compactMap({ try $0.data(as: Notification.self)})
                    
                    completion(.success(.init(result)))
                } catch {
                    completion(.failure(self.handle(error: error)))
                }
            }
    }



    // MARK: - Pictures

    public func pictures(for spot: Spot, limit: Int = 10,
                  completion: @escaping(Result<[Picture], Error>) -> Void) throws {

        guard let spotID = spot.id else { throw QueryErrors.noGetterID }


        Picture.collection
            .whereField("spot_id", isEqualTo: spotID)
            .whereField("valid", isEqualTo: true)
            .order(by: "dt_update", descending: true)
            .limit(to: limit)
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
    
    public enum UserErrors: Error {
        case noCurrentUser
    }
    
    public enum UpdateUserErrors: Error {
        case weakPassword
        case invalidEmail
        case failReauthenticate
    }

    private func handle(error: Error) -> Error {
        error
    }


    // MARK: - Listeners

    private var registrations : [ListenerRegistration] = []

    public func removeListeners() -> Void {
        registrations.forEach { registration in
            registration.remove()
        }
    }

    // MARK: - Tear down

    deinit {
        removeListeners()
    }
}
