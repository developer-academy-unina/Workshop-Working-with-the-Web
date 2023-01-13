//
//  ProductCellView.swift
//  E-Shop
//
//  Created by Gianluca Orpello on 09/01/23.
//

import SwiftUI

struct ProductCellView: View {
    
    let product: Product
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(product.title)
                Text(product.description)
                    .font(.caption)
                    .opacity(0.8)
            }
            Spacer()
            Text(product.category.name)
                .padding(10)
                .foregroundColor(.white)
                .background {
                    Color.orange
                }
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
        }
    }
    
}

