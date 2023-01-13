//
//  AddProductView.swift
//  E-Shop
//
//  Created by Gianluca Orpello on 09/01/23.
//

import SwiftUI

struct AddProductView: View {
    
    @Environment(\.dismiss) private var dismiss
    let productVM: ProductViewModel
    
    var product: Product?
    
    @State private var title: String
    @State private var price = 0
    @State private var description = ""
    
    init(product: Product? = nil, vm productVM: ProductViewModel) {
        self.product = product
        self.productVM = productVM
        self._title = State(initialValue: product?.title ?? "")
        self._price = State(initialValue: product?.price ?? 0)
        self._description = State(initialValue: product?.description ?? "")
    }
    
    var form: some View {
        Form {
            Section() {
                TextField("Title", text: $title)
                TextField(
                    "Price",
                    value: $price,
                    format: .number
                )
            }
            
            Section() {
                TextEditor(text: $description)
                    .frame(height: 250)
                    .background(
                        VStack {
                            HStack(alignment: .top) {
                                description.isBlank ? Text("Description") : Text("")
                                Spacer()
                            }
                            Spacer()
                        }
                            .foregroundColor(Color.primary.opacity(0.25))
                            .padding(.top, 8)
                            .padding(.leading, 5)
                    )
                
            }
        }
    }

    var body: some View {
        NavigationStack {
            form
                .navigationTitle(product?.title ?? "Create Product")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            Task {
                                saveElement()
                                dismiss()
                            }
                        }
                        .disabled(title == "")
                    }
                }
        }
        
    }
    
    @MainActor
    private func saveElement() {
        if let product {
            let newProduct = Product(id: product.id,
                                     title: title,
                                     price: price,
                                     description: description,
                                     category: product.category,
                                     images: product.images)
            productVM.update(
                by: product.id,
                with: newProduct)
        } else {
            productVM.create(title: title,
                                   price: price,
                                   description: description)
        }
    }
}

extension String {
    var isBlank: Bool {
        return allSatisfy({ $0.isWhitespace })
    }
}

struct AddProductView_Previews: PreviewProvider {
    static var previews: some View {
        AddProductView(vm: ProductViewModel())
    }
}
