//
//  Product.swift
//  E-Shop
//
//  Created by Gianluca Orpello on 10/01/23.
//

import Foundation

struct Product: Identifiable, Codable {
    
    var id: Int
    var title: String
    var price: Int
    var description: String
    var category: Category
    var images: [URL]
    
}

struct CreateProduct: Codable {
    var title: String
    var price: Int
    var description: String
    var categoryId: Int
    var images: [URL]
}
