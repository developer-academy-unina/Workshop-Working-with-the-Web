//
//  Network+URLSessionDelegate.swift
//  E-Shop
//
//  Created by Gianluca Orpello on 09/01/23.
//

import Foundation

extension Network: URLSessionDelegate {
    
    /// This function allows you to be able to perform the request after executing it.
    ///
    /// This function is implemented in three different ways based on the patter design.
    ///
    /// - Parameters:
    ///   - request: The `URLRequest` that needs to be performed
    ///   - completionHandler: The function that will be executed when the request is finished
    func perform(request: URLRequest,
                completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    -> URLSessionDataTask {
        return session.dataTask(with: request,
                                completionHandler: completionHandler)
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
    
}
