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
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAnalytics
import FirebaseStorage

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
        guard let id = self.auth?.currentUser?.uid else {
            throw AuthErrors.missingID
        }
        self.loggedUser = LoggedUser(id: id)
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
            guard let id = self.auth?.currentUser?.uid else {
                throw AuthErrors.missingID
            }
            self.loggedUser = LoggedUser(id: id)
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
        try listenLoggedUserPublicMetadata()
        try listenLoggedUserPrivateMetadata()
    }
    
    
    /// Listen for logged user private metadata.
    func listenLoggedUserPrivateMetadata() throws -> Void {
        guard let id = loggedUser?.id else { throw AuthErrors.notAuthenticated }
        
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
    
    /// Listen for logged user public metadata.
    func listenLoggedUserPublicMetadata() throws -> Void {
        guard let id = loggedUser?.id else { throw AuthErrors.notAuthenticated }
        
        let registration = User.collection
            .document(id)
            .addSnapshotListener { document, error in
                do {
                    if let error = error {
                        throw error
                    }
                    
                    guard let document = document else { throw QueryErrors.noDocuments }
                    
                    guard let result = try document.data(as: User.self) else {
                        throw QueryErrors.undecodable(document: document.documentID)
                    }
                    self.loggedUser?.publicMetadata = result
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
        guard let id = loggedUser?.id else { throw AuthErrors.notAuthenticated }
        
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
        guard let id = loggedUser?.id else {
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
    
    // MARK: User
    
    /// Get User public metadata.
    /// - Parameter id: User id.
    /// - Returns: User.
    public func getUserPublicData(from id: String) async throws -> User {
        guard !id.isEmpty else { throw UserErrors.emptyId }
        
        do {
            let snapshot = try await User.collection.document(id).getDocument()
            guard let user = try snapshot.data(as: User.self) else { throw UserErrors.incorrectUserData }
            return user
        } catch {
            throw handle(error: error)
        }
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
        guard let id = loggedUser?.id else { throw AuthErrors.notAuthenticated }
        
        guard let areaId = area.id else { throw QueryErrors.noGetterID }
        
        let areaCommand = AreaCommand(user_id: id, area_id: areaId)
        
        let data = try encoderFirestore.encode(areaCommand)
        AreaCommand.collection
            .document(UUID().uuidString)
            .setData(data) { error in
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
    
    public func mapSpots(location: String) async throws -> [Spot] {
        do {
            let snapshot = try await Spot.collection
                .whereField("location.locality.long_name", isEqualTo: location)
                .limit(to: 100)
                .getDocuments()
            let result = try snapshot.documents.compactMap({ try $0.data(as: Spot.self) })
            return result
        } catch {
            throw handle(error: error)
        }
    }
    
    /// Fetch the spot that the user contributed to.
    /// - Parameters:
    ///   - user: The user
    ///   - completion: The completion result.
    public func spots(for user: User?, completion: @escaping(Result<[Spot], Error>) -> Void) throws {
        guard let id = user?.id ?? loggedUser?.id else { return }
        
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
                    
                    let result = try documents.compactMap({ try $0.data(as: SpotrNotification.self )})
                    
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
                    
                    let result = try documents.compactMap({ try $0.data(as: SpotrNotification.self)})
                    
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
    
    public func updateProfilePicture(imageData: Data, path: StoragePath, completion: @escaping (Result<String, Error>) -> Void) {
        uploadPicture(imageData: imageData, path: path) { result in
            switch result {
            case .success((let url, let storageId)):
                self.updatePictureCommand(stringUrl: url, storageId: storageId) { result in
                    switch result {
                    case .success():
                        completion(.success(url))
                    case .failure(let error):
                        completion(.failure(self.handle(error: error)))
                    }
                }
            case .failure(let error):
                completion(.failure(self.handle(error: error)))
            }
        }
    }
    
    private func updatePictureCommand(stringUrl: String, storageId: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let loggedUser = loggedUser else {
            completion(.failure(self.handle(error: StorageErrors.noLoggedUser)))
            return
        }
        let updatePictureCommand = ProfilePictureCommand(user_id: loggedUser.id, profile_picture_url: stringUrl, profile_picture_storage_id: storageId)
        do {
            try ProfilePictureCommand.collection
                .document(UUID().uuidString)
                .setData(from: updatePictureCommand, encoder: encoderFirestore, completion: { error in
                    if let error = error {
                        completion(.failure(self.handle(error: error)))
                    } else {
                        completion(.success(()))
                    }
                })
        } catch {
            completion(.failure(self.handle(error: error)))
        }
    }
    
    // MARK: - Add a Spot
    
    public func uploadSpotSuggestion(datas: [Data], name: String, latitude: Double, longitude: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        uploadPictures(datas: datas, path: .spot) { result in
            switch result {
            case .success(let payloads):
                self.createSpotCommand(pictures: payloads, name: name, latitude: latitude, longitude: longitude) { result in
                    switch result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(self.handle(error: error)))
                    }
                }
            case .failure(let error):
                completion(.failure(self.handle(error: error)))
            }
        }
    }
    
    public func uploadPictureSuggestion(datas: [Data], spotId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        uploadPictures(datas: datas, path: .spot) { result in
            switch result {
            case .success(let payloads):
                self.createPictureCommand(pictures: payloads, spotId: spotId) { result in
                    switch result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(self.handle(error: error)))
                    }
                }
            case .failure(let error):
                completion(.failure(self.handle(error: error)))
            }
        }
    }
    
    private func createSpotCommand(pictures: [PayloadPicture], name: String, latitude: Double, longitude: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let loggedUser = loggedUser else {
            completion(.failure(self.handle(error: StorageErrors.noLoggedUser)))
            return
        }
        let id = UUID().uuidString
        let createSpotCommand = CreateSpotSuggestionCommand(id: id, author_id: loggedUser.id, pictures: pictures, name: name, latitude: latitude, longitude: longitude)
        do {
            try CreateSpotSuggestionCommand.collection
                .document(id)
                .setData(from: createSpotCommand, encoder: encoderFirestore, completion: { error in
                    if let error = error {
                        completion(.failure(self.handle(error: error)))
                    } else {
                        completion(.success(()))
                    }
                })
        } catch {
            completion(.failure(self.handle(error: error)))
        }
    }
    
    private func createPictureCommand(pictures: [PayloadPicture], spotId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let loggedUser = loggedUser else {
            completion(.failure(self.handle(error: StorageErrors.noLoggedUser)))
            return
        }
        let id = UUID().uuidString
        let createPictureCommand = CreatePictureSuggestionCommand(id: id, author_id: loggedUser.id, pictures: pictures, spot_id: spotId)
        do {
            try CreatePictureSuggestionCommand.collection
                .document(id)
                .setData(from: createPictureCommand, encoder: encoderFirestore, completion: { error in
                    if let error = error {
                        completion(.failure(self.handle(error: error)))
                    } else {
                        completion(.success(()))
                    }
                })
        } catch {
            completion(.failure(self.handle(error: error)))
        }
    }
    
    
    // MARK: - Storage
    
    public enum StoragePath: String {
        case spot = "spot_images/"
        case profile = "profile_pictures/"
    }
    
    public func uploadPictures(datas: [Data], path: StoragePath, completion: @escaping (Result<[PayloadPicture], Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        var payloadPictures: [PayloadPicture] = []
        for data in datas {
            dispatchGroup.enter()
            let storageId = getStorageId(path: path)
            let imageRef = storage.child(storageId)
            imageRef.putData(data, metadata: nil) { storageMetadata, error in
                if let error = error {
                    completion(.failure(self.handle(error: error)))
                } else {
                    imageRef.downloadURL { url, error in
                        if let error = error {
                            completion(.failure(self.handle(error: error)))
                        }
                        if let urlString = url?.absoluteString {
                            payloadPictures.append(PayloadPicture(url: urlString, storage_id: storageId))
                        } else {
                            completion(.failure(self.handle(error: StorageErrors.noUrl)))
                        }
                        dispatchGroup.leave()
                    }
                }
            }
        }
        dispatchGroup.notify(queue: .global()) {
            completion(.success(payloadPictures))
        }
    }
    
    private func uploadPicture(imageData: Data, path: StoragePath, completion: @escaping (Result<(String, String), Error>) -> Void) {
        guard loggedUser != nil else {
            completion(.failure(self.handle(error: StorageErrors.noLoggedUser)))
            return
        }
        let storageId = getStorageId(path: path)
        let imageRef = storage.child(storageId)
        imageRef.putData(imageData, metadata: nil) { storageMetadata, error in
            if let error = error {
                completion(.failure(self.handle(error: error)))
            } else {
                imageRef.downloadURL { url, error in
                    if let error = error {
                        completion(.failure(self.handle(error: error)))
                    }
                    if let urlString = url?.absoluteString {
                        completion(.success((urlString, storageId)))
                    } else {
                        completion(.failure(self.handle(error: StorageErrors.noUrl)))
                    }
                }
            }
        }
    }
    
    private func getStorageId(path: StoragePath) -> String {
        let imageName: String
        switch path {
        case .spot: imageName = "\(UUID().uuidString)\(Date().timeIntervalSince1970)"
        case .profile: imageName = loggedUser?.id ?? ""
        }
        let storageId = "\(path.rawValue)\(imageName).jpg"
        return storageId
    }
    
    // MARK: - Errors
    
    public enum AuthErrors: Error {
        case failed
        case missingCredentials
        case notAuthenticated
        case missingID
    }
    
    public enum QueryErrors: Error {
        case noDocuments
        case noGetterID
        case undecodable(document: String?)
    }
    
    public enum UserErrors: Error {
        case noCurrentUser
        case emptyId
        case incorrectUserData
    }
    
    public enum UpdateUserErrors: Error {
        case weakPassword
        case invalidEmail
        case failReauthenticate
    }
    
    public enum StorageErrors: Error {
        case noLoggedUser
        case noUrl
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
