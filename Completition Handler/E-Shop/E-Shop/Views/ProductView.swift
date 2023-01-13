//
//  ProductView.swift
//  E-Shop
//
//  Created by Gianluca Orpello on 09/01/23.
//

import SwiftUI

struct ProductView: View {
    
    let product: Product
    
    var imageSlider: some View {
        TabView {
            ForEach(product.images, id: \.self) { item in
                AsyncImage(
                    url: item,
                    content: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 300)
                    },
                    placeholder: {
                        ProgressView()
                    })
                
            }
        }
        .frame(width: 300, height: 300)
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .automatic))
        .background(Color(.systemBackground))
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = .black
            UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
        }
    }
    
    var header: some View {
        HStack {
            Text("\(product.price) €")
                .font(.title)
                .bold()
            Spacer()
            Text(product.category.name)
                .padding(10)
                .foregroundColor(.white)
                .background {
                    Color.orange
                }
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
        }
        .padding()
    }
    
    var body: some View {
        ScrollView {
            imageSlider
            header
            Text(product.description)
        }
        .padding()
        .navigationTitle(product.title)
    }
    
}
