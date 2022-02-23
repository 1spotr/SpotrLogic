//
//  Coding.swift
//  
//
//  Created by Marcus on 23/02/2022.
//

import Foundation

// MARK: - Coding

// MARK: Encoding


public let encoder : JSONEncoder = {
				let coder = JSONEncoder()
				coder.keyEncodingStrategy = .convertToSnakeCase
				coder.dateEncodingStrategy = .millisecondsSince1970
				return coder
}()

// MARK: Decoding

public let decoder : JSONDecoder = {
				let coder = JSONDecoder()
				coder.keyDecodingStrategy = .convertFromSnakeCase
				coder.dateDecodingStrategy = .millisecondsSince1970
				return coder
}()
