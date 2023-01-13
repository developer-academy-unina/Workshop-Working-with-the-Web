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

    
    func getProducts() async {
        do {
            products = try await Network.shared.list(path: productPath) ?? []
        } catch {
            let error = ResponseHandler.shared.mapError(error)
            print(error.localizedDescription)
        }
        
    }
    
    func create(title: String, price: Int, description: String) async {
        do {
            
            let parsedProduct = CreateProduct(title: title,
                                             price: price,
                                             description: description,
                                             categoryId: products.first?.category.id ?? 1,
                                             images: products.first?.images ?? [])
            
            let newProduct = try await Network.shared.create(path: productPath, product: parsedProduct)
            products.insert(newProduct, at: 0)
        } catch {
            let error = ResponseHandler.shared.mapError(error)
            print(error.localizedDescription)
        }
    }
 
    func update(by id: Int, with newProduct: Product) async {
        do {
            let updatedProduct = try await Network.shared.update(path: productPath.appending("/\(id)"), with: newProduct)
            if let row = products.firstIndex(where: { $0.id == id }) {
                   products[row] = updatedProduct
            }
        } catch {
            let error = ResponseHandler.shared.mapError(error)
            print(error.localizedDescription)
        }
    }
    
    func delete(product: Product) async {
        print("ID: \(product.id)")
        do {
            let deleted = try await Network.shared.delete(path: productPath.appending("/\(product.id)"))
            
            if deleted,
               let row = products.firstIndex(where: { $0.id == product.id }) {
                products.remove(at: row)
            }
        } catch {
            let error = ResponseHandler.shared.mapError(error)
            print(error.localizedDescription)
        }
    }
    
}
