//
//  Endpoint.swift
//  Pokedex
//
//  Created by Tim Gunnarsson on 2024-07-21.
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var httpMethod: HTTPMethod { get }
}

extension Endpoint {
    func createURL(base: String) -> URL? {
        URL(string: base + path)
    }
    
    func createURLRequest(base: String, cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy) throws -> URLRequest {
        guard let url = createURL(base: base) else {
            throw HTTPError.invalidRequest
        }
        
        return createURLRequest(url: url, cachePolicy: cachePolicy)
    }
    
    private func createURLRequest(url: URL, cachePolicy: URLRequest.CachePolicy) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: cachePolicy)
        request.httpMethod = self.httpMethod.rawValue
        return request
    }
}
