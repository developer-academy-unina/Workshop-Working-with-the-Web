//
//  Network.swift
//  E-Shop
//
//  Created by Gianluca Orpello on 09/01/23.
//

import Foundation

class Network: NSObject {
    
    /// Create a single instance on Network class
    static let shared = Network()
    
    /// Create a urlSession object, use this to perform requests
    let session: URLSession = URLSession(configuration: .default)
    
    /// URLComponents, use this to create and manipulate endpoints
    var urlComponent = URLComponents(string: "https://api.escuelajs.co/api/v1")
    
    /// Decoder for JSON `Data`.
    lazy var decoder = JSONDecoder()
    
    /// Encoder for JSON `Data`.
    lazy var encoder = JSONEncoder()
    
    func list(path: String) async throws -> [Product]? {
        
        let request = buildRequest(
            method: "GET",
            path: path
        )
        
        let data = try await perform(request: request)
        
        return try JSONDecoder().decode([Product].self, from: data)
    }
    
    func create(path: String, product: CreateProduct) async throws -> Product {
        
        let request = buildRequest(
            method: "POST",
            path: path,
            body: product
        )
        
        let data = try await perform(request: request)
        return try JSONDecoder().decode(Product.self, from: data)
    }
    
    func update(path: String, with newProduct: Product) async throws -> Product {
        
        let request = buildRequest(
            method: "PUT",
            path: path,
            body: newProduct
        )
        
        let data = try await perform(request: request)
        return try JSONDecoder().decode(Product.self, from: data)
    }
    
    func delete(path: String) async throws -> Bool {
        
        let request = buildRequest(
            method: "DELETE",
            path: path
        )
                
        let data = try await perform(request: request)
        return try decoder.decode(Bool.self, from: data)
    }
    
}
