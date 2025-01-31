//
//  CartProductCell.swift
//  Lucky_Depot
//
//  Created by 노민철 on 1/22/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct CartProductCell: View {
    
    @ObservedObject var shoppingBasketViewModel: ShoppingBasketViewModel
    
    var body: some View {
        ScrollView {
            VStack(content: {
                ForEach(shoppingBasketViewModel.products, id: \.id) { product in
                    HStack(content: {
                        WebImage(url: URL(string: product.imagePath))
                            .resizable()
                            .frame(width: 100, height: 100)
                            .scaledToFit()
                            .cornerRadius(8)

                        VStack(alignment: .leading, spacing: 10, content: {
                            // 제품명 및 삭제 버튼
                            HStack(content: {
                                Text(product.name)
                                    .foregroundStyle(.black)
                                Spacer()

                                Button("", systemImage: "trash", action: {
                                    // 삭제 로직
                                    shoppingBasketViewModel.deleteProduct(product)
                                })
                                .tint(.red.opacity(0.8))
                                .labelStyle(.iconOnly)
                            })
                            // 제품 금액
                            Text("$"+String(format : "%.2f", product.price)+" Each")
                                .font(.system(size:16))

                            // 제품 수량 조절
                            HStack(spacing : 10){

                                Button("", systemImage: "minus", action: {
                                    if product.quantity > 1 {
                                        // 빼기
                                        shoppingBasketViewModel.updateProductQuantity(product, quantity: -1)
                                    }
                                }).labelStyle(.iconOnly)

                                Text("\(product.quantity)")
                                Button("", systemImage: "plus", action: {
                                    // 더하기
                                    shoppingBasketViewModel.updateProductQuantity(product, quantity: 1)
                                }).labelStyle(.iconOnly)
                                Spacer()
                                Text("$"+String(format : "%.2f", product.price * Double(product.quantity)))
                                    .foregroundStyle(.price)
                                    .font(.system(size:20, weight: .bold))
                          }
                            .foregroundStyle(.black.opacity(0.9))
                            .padding(.top,10)




                        })
                        .padding(.horizontal)
                    })
                }
            })
            .padding(.horizontal)
        }
        
    }
}

#Preview {
//    CartProductCell()
}
