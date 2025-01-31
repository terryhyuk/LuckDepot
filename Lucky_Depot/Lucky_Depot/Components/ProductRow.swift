////
////  ProductRow.swift
////  PayView
////
////  Created by 노민철 on 1/20/25.
////
//
import SwiftUI
import SDWebImageSwiftUI

struct ProductRow: View {
//    let product: Product
    let product: RealMProduct
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: product.imagePath))
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .cornerRadius(8)

            
            VStack(alignment: .leading, spacing: 4) {
                HStack(content: {
                    Text(product.name)
                        .padding(.bottom, 6)
                    
                    Spacer()
                    
                    Image(systemName: "cart")
                        .foregroundColor(.gray)
                })
                
                Text("\(product.price)원")
                    .foregroundColor(.blue)
                    .bold()
                
                HStack(content: {
                    Text("상품 상세보기")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.gray)
                })
                .padding(.top, 10)
            }
            
            Spacer()
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}

#Preview {
//    ProductRow(product: Product(id: "11", name: "123", price: 1234, imagePath: "https://zeushahn.github.io/Test/images/mov01.jpg", quantity: 1, category: "1"))
}

//
//struct ProductRow: View {
//    let name: String
//    let price: String
//    var imagePath: String
//    
//    var body: some View {
//        HStack {
//            WebImage(url: URL(string: "https://zeushahn.github.io/Test/images/mov01.jpg"))
//                .resizable()
//                .scaledToFit()
//                .frame(width: 100, height: 100)
//                .clipShape(.buttonBorder)
//            VStack(alignment: .leading) {
//                Text(name)
//                    .font(.headline)
//                
//                Text(price)
//                    .foregroundColor(.blue)
//                
//                HStack(content: {
//                    Text("상품 상세보기")
//                        .foregroundStyle(.black.opacity(0.6))
//                    
//                    Image(systemName: "chevron.right")
//                        .foregroundStyle(.black.opacity(0.6))
//                })
//                .padding(.vertical, 8)
//                
//            }
//            Spacer()
//            Button(action: {
//                // 장바구니 추가 로직
//            }) {
//                Image(systemName: "cart")
//            }
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    ProductRow(name: "물건이름", price: "가격", imagePath: "")
//}
