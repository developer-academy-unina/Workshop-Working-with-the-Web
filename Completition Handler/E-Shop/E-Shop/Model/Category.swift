//
//  Category.swift
//  E-Shop
//
//  Created by Gianluca Orpello on 09/01/23.
//

import Foundation

struct Category: Identifiable, Codable {
    var id: Int
    var name: String
    var image: URL
}
