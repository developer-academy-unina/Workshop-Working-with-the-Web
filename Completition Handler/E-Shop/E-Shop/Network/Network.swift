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
    
    func list(path: String,
              completion: @escaping ([Product]?, NetworkError?) -> Void) {
        
        let request = buildRequest(
            method: "GET",
            path: path
        )
        
        let task = perform(request: request!) { [weak self] data, response, error in
            guard let data, error == nil else {
                completion(nil, ResponseHandler.shared.mapError(error!))
                return
            }
            
            let products = try? self?.decoder.decode([Product].self, from: data)
            completion(products, nil)
        }
        
        task.resume()
    }
    
    func create(path: String,
                product: CreateProduct,
                completion: @escaping (Product?, NetworkError?) -> Void) {
        
        let request = buildRequest(
            method: "POST",
            path: path,
            body: product
        )
        
        let task = perform(request: request!) { [weak self] data, response, error in
            guard let data, error == nil else {
                completion(nil, ResponseHandler.shared.mapError(error!))
                return
            }
            
            let product = try? self?.decoder.decode(Product.self, from: data)
            completion(product, nil)
        }
        
        task.resume()
    }
    
    func update(path: String,
                with newProduct: Product,
                completion: @escaping (Product?, NetworkError?) -> Void) {
        
        let request = buildRequest(
            method: "PUT",
            path: path,
            body: newProduct
        )
        
        let task = perform(request: request!) { [weak self] data, response, error in
            guard let data, error == nil else {
                completion(nil, ResponseHandler.shared.mapError(error!))
                return
            }
            
            let product = try? self?.decoder.decode(Product.self, from: data)
            completion(product, nil)
        }
        task.resume()
    }
    
    func delete(path: String,
                completion: @escaping (Bool?, NetworkError?) -> Void) {
        
        let request = buildRequest(
            method: "DELETE",
            path: path
        )
            
        let task = perform(request: request!) { [weak self] data, response, error in
            guard let data, error == nil else {
                completion(nil, ResponseHandler.shared.mapError(error!))
                return
            }
            let isDeleted = try? self?.decoder.decode(Bool.self, from: data)
            completion(isDeleted, nil)
        }
        
        task.resume()
    }
    
}
