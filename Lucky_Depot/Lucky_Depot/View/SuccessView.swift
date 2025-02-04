//
//  SuccessView.swift
//  PayView
//
//  Created by 노민철 on 1/21/25.
//

import SwiftUI

struct SuccessView: View {
    @ObservedObject var shoppingBasketViewModel: ShoppingBasketViewModel
    
    @Binding var navigationPath: NavigationPath
    @State var productList: [RealMProduct] = []
    @State var totalPrice:Double = 0
    
    var body: some View {
        VStack(content: {
            ZStack(content: {
                Circle()
                    .fill(Color(red: 0xDC / 255.0, green: 0xFC / 255.0, blue: 0xE7 / 255.0))
                    .frame(width: 80, height: 80) // 원의 크기
                Image(systemName: "checkmark")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(.green)
            })
            .padding(.top, 64)
            
            Text("Payment is complete")
                .fontWeight(.bold)
                .font(.system(size: 28))
                .padding(.top, 16)
                .padding(.bottom, 4)
            
            Text("Thank you for your order")
                .font(.system(size: 20))
                .foregroundStyle(.gray)
                .padding(.bottom, 16)
                
            Form{
                Section{
                    Text("Products ordered")
                        .font(.system(size: 17))
                        .foregroundStyle(.gray)
                    
                    ForEach(productList, id: \.id) { product in
                        OrderProduct(product: product)
                    }
                }
            }
            
            HStack(content: {
                Text("Total Price")
                Spacer()
                Text("$"+String(format : "%.2f", totalPrice))
            })
            .padding()
            
            Divider()
            
            Button(action: {
                navigationPath = NavigationPath()
            }, label: {
                Text("OK")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity) // 화면 너비에 맞게 확장
                    .padding() // 버튼 내부 여백
                    .background(Color.green)
                    .cornerRadius(10)
            })
            .padding(.bottom, 32)
            .padding()
            
        })
        .onAppear(perform: {
            // 보여줄 데이터를 따로 저장한뒤 장바구니 데이터 삭제
            productList = shoppingBasketViewModel.products.map{ RealMProduct(value: $0) }
            shoppingBasketViewModel.deleteAllProducts()
            totalPrice = 0
            for product in productList {
                totalPrice += product.price * Double(product.quantity)
            }
        })
    }
        
}

#Preview {
//    SuccessView()
}
