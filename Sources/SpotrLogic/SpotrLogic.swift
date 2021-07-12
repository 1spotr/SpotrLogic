//
//  SpotrLogic.swift
//  SpotrLogic
//
//  Created by Marcus on 29/06/2021.
//  Copyright © 2021 Spotr. All rights reserved.
//

import Foundation
import Logging


class SpotrLogic {

    public let logger: Logger

    init(logger: Logger) {
        self.logger = logger
        
    }

    // MARK: - Authentications


    // MARK: - Areas

    func areas(completion: @escaping(Result<Set<Area>, Error>) -> Void) -> Void {
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

    // MARK: - Errors

    enum QueryErrors: Error {
        case noDocuments
    }

    func handle(error: Error) -> Error {
        error
    }

}
