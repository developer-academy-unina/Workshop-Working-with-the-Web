//
//  Network+URLSessionDelegate.swift
//  E-Shop
//
//  Created by Gianluca Orpello on 10/01/23.
//

import Foundation
import Combine

extension Network: URLSessionDelegate {
    
    /// This function allows you to be able to perform the request after executing it.
    ///
    /// This function is implemented in three different ways based on the patter design.
    ///
    /// - Parameters:
    ///   - request: The `URLRequest` that needs to be performed
    ///   - decoder: The object that will allow the data received from the call to be decoded.
    func perform<T: Codable>(request: URLRequest?,
                 decoder: @escaping (Data) throws -> T)
    -> AnyPublisher<T, NetworkError> {
        
        guard let urlRequest = request else {
            let error = NetworkError.invalidParameters(operation: #function, parameters: [request as Any])
            return Fail(error: error).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: urlRequest)
            .tryMap(ResponseHandler.shared.mapResponse(_:))
            .tryMap(decoder)
            .mapError(ResponseHandler.shared.mapError(_:))
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    ///This function allows you to be able to create the URLRequest object, which can be used to be able to make a network call
    ///
    /// - Parameters:
    ///   - method: The HTTP Method
    ///   - path: The path of the request
    ///   - apiKey: The Bearer Token useful for authentication of the request if needed.
    ///   - queryItems: The Query items of the request if needed.
    ///   - body: The body of the request if needed.
    func buildRequest(method: String,
                      path: String,
                      apiKey: String? = nil,
                      queryItems: [URLQueryItem]? = nil,
                      body: (any Codable)? = nil)
    -> URLRequest? {
        urlComponent?.path = "/api/v1"+path
        
        if let queryItems = queryItems {
            urlComponent?.queryItems = queryItems
        }
        guard let theURL = urlComponent?.url else { return nil }

        var request = URLRequest(url: theURL)
        request.httpMethod = method
        
        if let apiKey {
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        }
        
        if let body {
            do {
                request.httpBody = try encoder.encode(body) // asData(json: body)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                return nil
            }
        }
        
        return request
    }
    
    /// Decodes a JSON `Data` as an array of `Product`.
    ///
    /// - Throws: `NetworkError`.
    func decodeProducts(from data: Data) throws -> [Product] {
        try decoder.decode([Product].self, from: data)
    }
    
    /// Decodes a JSON `Data` as a `Product`.
    ///
    /// - Throws: `NetworkError`.
    func decodeProduct(from data: Data) throws -> Product {
        try decoder.decode(Product.self, from: data)
    }
    
    /// Decodes a JSON `Data` as a `Bool`.
    ///
    /// - Throws: `NetworkError`.
    func decodeBool(from data: Data) throws -> Bool {
        try decoder.decode(Bool.self, from: data)
    }
}
