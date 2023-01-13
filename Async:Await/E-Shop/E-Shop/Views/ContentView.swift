//
//  ContentView.swift
//  E-Shop
//
//  Created by Gianluca Orpello on 09/01/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var productVM = ProductViewModel()
    @State private var isPresented = false
    @State private var editProduct: Product? = nil
    
    @ViewBuilder
    var content: some View {
        if productVM.products.isEmpty {
            ProgressView()
        } else {
            list
        }
    }
    
    var list: some View {
        List(productVM.products) { product in
            NavigationLink {
                ProductView(product: product)
            } label: {
                ProductCellView(product: product)
            }
            .swipeActions(allowsFullSwipe: false) {
                Button(role: .destructive) {
                    Task {
                        await productVM.delete(product: product)
                    }
                } label: {
                    Label("Delete", systemImage: "trash.fill")
                }
                
                Button {
                    editProduct = product
                } label: {
                    Label("Edit", systemImage: "square.and.pencil")
                }
                .tint(.indigo)
            
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Products")
                .toolbar {
                    Button {
                        isPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
        }
        .task {
            await productVM.getProducts()
        }
        .sheet(item: $editProduct, content: { product in
            AddProductView(product: product, vm: productVM)
        })
        .sheet(isPresented: $isPresented) {
            AddProductView(vm: productVM)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
