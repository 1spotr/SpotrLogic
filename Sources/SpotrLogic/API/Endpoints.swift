//
//  Enpoints.swift
//  
//
//  Created by Marcus on 19/02/2022.
//

import Foundation


struct Endpoints {

				// MARK: - Endpoints

				private let protectionSpace : URLProtectionSpace

				/// Main URL components, which will be used to create the endpoints.
				let main : URLComponents

				init(protection space: URLProtectionSpace) {
								protectionSpace = space

								// Creating main URL components
								var components = URLComponents()
								components.host = protectionSpace.host
								components.port = protectionSpace.port
								components.scheme = protectionSpace.protocol

								main = components
				}


				// MARK: - Remote

				/// Remote endpoint.
				enum Remote: String {
								/// `./localizations`.
								case localizations = "/localizations"
				}

				func remote(_ endpoint: Remote) -> URL? {
								var components = main
								components.path =  "/remote" + endpoint.rawValue
								return components.url
				}

				// MARK: - Search

				/// Search endpoint
				enum Search: String {
								/// `./search`
								case search = "/search"
				}

				func search(_ endpoint: Search, query items: Set<URLQueryItem>? = nil) -> URL? {
								var components = main
								components.path = endpoint.rawValue
								if let items = items {
												components.queryItems = Array(items)
								}
								return components.url
				}


}


extension URLQueryItem {

				init(search text: String) {
								self = .init(name: "text", value: text)
				}

}
