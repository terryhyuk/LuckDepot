//
//  ProductHomeItem.swift
//  Lucky_Depot
//
//  Created by 노민철 on 1/24/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductHomeItem: View {
    let product: Product
    var body: some View {
        VStack(alignment: .leading) {
            WebImage(url: URL(string: product.imagePath))
                .resizable()
                .frame(width: 170, height: 150)
            
            VStack(alignment: .leading) {
                Text(product.name)
                    .foregroundStyle(.black)
                Spacer()
                Text("$\(String(format: "%.2f", product.price))")
                    .foregroundStyle(.black.opacity(0.7))
            }
            .padding(12)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.08), radius: 5, x: 2, y: 2)
    }
}

#Preview {
    ProductHomeItem(
        product: Product(
            id: 1,
            image: "제품1",
            category_id: 1,
            name: "https://zeushahn.github.io/Test/images/mov01.jpg",
            price: 1,
            quantity: 1
        )
    )
}
