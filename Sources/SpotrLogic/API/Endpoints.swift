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
								components.path = endpoint.rawValue
								return components.url
				}
}
