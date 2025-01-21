//
//  SuccessView.swift
//  PayView
//
//  Created by 노민철 on 1/21/25.
//

import SwiftUI

struct SuccessView: View {
//    @State var productList: [Product] = [
//        Product(id: "1", name: "제품", price: 1234, imagePath: "https://zeushahn.github.io/Test/images/mov01.jpg", quantity: 1, category: "1"),
//        Product(id: "2", name: "제품2", price: 2334, imagePath: "https://zeushahn.github.io/Test/images/mov01.jpg", quantity: 1, category: "1"),
//    ]
    @StateObject private var shoppingBasketViewModel = ShoppingBasketViewModel()
    
    @Binding var navigationPath: NavigationPath
    
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
            
            Text("결제가 완료되었습니다")
                .fontWeight(.bold)
                .font(.system(size: 28))
                .padding(.top, 16)
                .padding(.bottom, 4)
            
            Text("주문해 주셔서 감사합니다")
                .font(.system(size: 20))
                .foregroundStyle(.gray)
                .padding(.bottom, 16)
                
            Form{
                Section{
                    Text("주문 상품")
                        .font(.system(size: 17))
                        .foregroundStyle(.gray)
                    
                    ForEach(shoppingBasketViewModel.products, id: \.id) { product in
                        OrderProduct(product: product)
                    }
                }
            }
            
            HStack(content: {
                Text("총 결제금액")
                Spacer()
                Text("\(10000)원")
            })
            .padding()
            
            Divider()
            
            Button(action: {
                navigationPath = NavigationPath()
            }, label: {
                Text("확인")
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
    }
}

#Preview {
//    SuccessView()
}
