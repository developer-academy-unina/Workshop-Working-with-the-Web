//
//  Network.swift
//  E-Shop
//
//  Created by Gianluca Orpello on 10/01/23.
//

import Foundation
import Combine

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
    
    func list(path: String) -> AnyPublisher<[Product], NetworkError> {
        let request = buildRequest(
            method: "GET",
            path: path
        )
        return perform(request: request, decoder: decodeProducts(from:))
    }
 
    func create(path: String, product: CreateProduct) -> AnyPublisher<Product, NetworkError> {
        
        let request = buildRequest(
            method: "POST",
            path: path,
            body: product
        )
        return perform(request: request, decoder: decodeProduct(from:))
    }
    
    func update(path: String, with newProduct: Product) -> AnyPublisher<Product, NetworkError> {
        
        let request = buildRequest(
            method: "PUT",
            path: path,
            body: newProduct
        )
        
        return perform(request: request, decoder: decodeProduct(from:))
    }
    
    func delete(path: String) -> AnyPublisher<Bool, NetworkError> {
        
        let request = buildRequest(
            method: "DELETE",
            path: path
        )
        return perform(request: request, decoder: decodeBool(from:))
    }
}
