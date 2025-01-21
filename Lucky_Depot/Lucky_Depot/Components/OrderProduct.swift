//
//  OrderProduct.swift
//  PayView
//
//  Created by 노민철 on 1/20/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct OrderProduct: View {
//    let product: Product
    let product: RealMProduct
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: product.imagePath))
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .cornerRadius(8)
            
            VStack(alignment: .leading, content: {
                Text(product.name)
                    
                Text("수량: \(product.quantity)")
                
                Text("\(product.price)원")
                    .bold()
                
                HStack(content: {
                    Image(systemName: "clock.arrow.circlepath")
                    
                    Text("예상 도착일: 2024. 1. 16.")
                        .foregroundStyle(.gray)
                })
            })
            
            Spacer()
        }
    }
}

#Preview {
//    OrderProduct(product: Product(id: "11", name: "123", price: 1234, imagePath: "https://zeushahn.github.io/Test/images/mov01.jpg", quantity: 1, category: "1"))
}
