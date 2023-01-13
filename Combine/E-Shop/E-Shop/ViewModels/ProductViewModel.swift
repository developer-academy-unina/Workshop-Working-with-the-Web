//
//  ProductViewModel.swift
//  E-Shop
//
//  Created by Gianluca Orpello on 10/01/23.
//

import SwiftUI
import Combine

class ProductViewModel: ObservableObject {
    
    @Published var products = [Product]()
    
    private let productPath = "/products"
    private var observers: Set<AnyCancellable> = []
    
    func getProducts() {
        Network.shared.list(path: productPath)
            .sink {
                completion in
                switch completion {
                case .failure(let error):
                    let error = ResponseHandler.shared.mapError(error)
                    print(error.localizedDescription)
                case .finished:
                    print("\(#function) success")
                }
            } receiveValue: { [weak self] data in
                self?.products = data
            }
            .store(in: &observers)
        
    }
    
    func create(title: String, price: Int, description: String) {
        let parsedProduct = CreateProduct(title: title,
                                         price: price,
                                         description: description,
                                         categoryId: products.first?.category.id ?? 1,
                                         images: products.first?.images ?? [])
        
        Network.shared.create(path: productPath,
                              product: parsedProduct)
            .sink {
                completion in
                switch completion {
                case .failure(let error):
                    let error = ResponseHandler.shared.mapError(error)
                    print(error.localizedDescription)
                case .finished:
                    print("\(#function) success")
                }
            } receiveValue: { [weak self] data in
                self?.products.insert(data, at: 0)
            }
            .store(in: &observers)
    }
 
    func update(by id: Int, with newProduct: Product) {
        Network.shared.update(path: productPath.appending("/\(id)"), with: newProduct)
            .sink {
                completion in
                switch completion {
                case .failure(let error):
                    let error = ResponseHandler.shared.mapError(error)
                    print(error.localizedDescription)
                case .finished:
                    print("\(#function) success")
                }
            } receiveValue: { [weak self] data in
                if let row = self?.products.firstIndex(where: { $0.id == id }) {
                    self?.products[row] = data
                }
            }
            .store(in: &observers)
    }
    
    func delete(product: Product) {
        Network.shared.delete(path: productPath.appending("/\(product.id)"))
            .sink {
                completion in
                switch completion {
                case .failure(let error):
                    let error = ResponseHandler.shared.mapError(error)
                    print(error.localizedDescription)
                case .finished:
                    print("\(#function) success")
                }
            } receiveValue: { [weak self] data in
                if data,
                   let row = self?.products.firstIndex(where: { $0.id == product.id }) {
                    self?.products.remove(at: row)
                }
            }
            .store(in: &observers)
    }
    
}
