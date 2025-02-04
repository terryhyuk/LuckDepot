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
                  
                HStack(content: {
                    Text("quantity: \(product.quantity)")
                    
                    Spacer()
                    
                    Text("$"+String(format : "%.2f", product.price))
                        .bold()
                })
                
                HStack(content: {
                    Text("Total")
                        .bold()
                        .foregroundStyle(.blue)
                    Spacer()
                    Text("$"+String(format : "%.2f", product.price * Double(product.quantity)))
                        .bold()
                        .foregroundStyle(.blue)
                })
            })
            
            Spacer()
        }
    }
}

#Preview {
    OrderProduct(product: RealMProduct())
}
