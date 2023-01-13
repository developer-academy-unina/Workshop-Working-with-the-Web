//
//  ProductViewModel.swift
//  E-Shop
//
//  Created by Gianluca Orpello on 09/01/23.
//

import SwiftUI

@MainActor
class ProductViewModel: ObservableObject {
    
    @Published var products = [Product]()
    private let productPath = "/products"

    func getProducts() {
        
        Network.shared.list(path: productPath) { [weak self] products, error in
            guard let products,
                  error == nil else {
                let networkError = ResponseHandler.shared.mapError(error!)
                print(networkError.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self?.products = products
            }
        }
        
    }
    
    func create(title: String, price: Int, description: String) {
        let parsedProduct = CreateProduct(title: title,
                                         price: price,
                                         description: description,
                                         categoryId: products.first?.category.id ?? 1,
                                         images: products.first?.images ?? [])
        
        Network.shared.create(path: productPath,
                              product: parsedProduct) { [weak self] product, error in
            guard let product,
                  error == nil else {
                let networkError = ResponseHandler.shared.mapError(error!)
                print(networkError.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                self?.products.insert(product, at: 0)
            }
            
        }
    }
 
    func update(by id: Int, with newProduct: Product) {
        
        Network.shared.update(path: productPath.appending("/\(id)"),
                              with: newProduct) { [weak self] product, error in
            
            guard let product,
                  error == nil else {
                let networkError = ResponseHandler.shared.mapError(error!)
                print(networkError.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                if let row = self?.products.firstIndex(where: { $0.id == id }) {
                    self?.products[row] = product
                }
            }
        }
    }
    
    func delete(product: Product) {
        
        Network.shared.delete(path: productPath.appending("/\(product.id)")) { [weak self] isDeleted, error in
            
            guard let isDeleted,
                  error == nil else {
                let networkError = ResponseHandler.shared.mapError(error!)
                print(networkError.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                if isDeleted,
                   let row = self?.products.firstIndex(where: { $0.id == product.id }) {
                    self?.products.remove(at: row)
                }
            }
        }
    }
    
}
