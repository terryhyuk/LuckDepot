//
//  DetailView.swift
//  final_project
//
//  Created by Eunji Kim on 1/15/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailView: View {
    @ObservedObject var productViewModel :ProductViewModel
    @ObservedObject var shoppingBasketViewModel: ShoppingBasketViewModel
    @Binding var navigationPath: NavigationPath
    
    @State var product: Product?
    @State private var quantity: Int = 1

    var body: some View {
        VStack {
            if product == nil {
                ProgressView("데이터 로딩 중...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(height: 200)
                    .padding()
            } else {
                ScrollView {
                    VStack(alignment: .leading ,spacing: 20) {
                        // Product Image
                        HStack {
                            Spacer()
                            WebImage(url: URL(string: product!.imagePath))
                                .resizable()
                                .scaledToFit()
                                
                                .cornerRadius(8)
                            Spacer()
                        }
                        .frame(width: .infinity, height: 300)
                        
                        // Title and Price
                        VStack(alignment: .leading, spacing: 5) {
                            Text(product!.name)
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("$"+String(format : "%.2f", product!.price)+" Each")
                                .font(.title3)
                                .foregroundColor(.blue)
                        }
                        
                        // Quantity Selector
                        HStack {
                            Stepper(value: $quantity, in: 1...10) {
                                Text("수량: \(quantity)")
                                    .font(.body)
                            }
                            .frame(width: 150)
                        }
                        
                        // Action Buttons
                        VStack(spacing: 10) {
                            Button(action: {
                                navigationPath.append("PaymentsView")
                            }) {
                                Text("바로 구매하기")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                            
                            Button(action: {
                                // 알러트 후
                                // 장바구니 이동
                                // 뒤로가기
                                shoppingBasketViewModel.addProduct(product: product!, quantity: quantity)
                            }) {
                                Text("장바구니 담기")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.blue, lineWidth: 2)
                                    )
                            }
                        }
                        
                        // Icons Section
                        HStack(spacing: 20) {
                            VStack {
                                Image(systemName: "shippingbox")
                                    .font(.title)
                                    .foregroundColor(.gray)
                                Text("무료 배송\n평균 3일 이내 도착")
                                    .font(.footnote)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            
                            VStack {
                                Image(systemName: "shield")
                                    .font(.title)
                                    .foregroundColor(.gray)
                                Text("1년 제품 보증")
                                    .font(.footnote)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
//                        Divider()
//                        
//                        // Product Details
//                        VStack(alignment: .leading, spacing: 10) {
//                            Text("제품 상세 정보")
//                                .font(.headline)
//                            
//                            Text("최고급 메쉬 소재를 사용한 프리미엄 사무용 의자입니다. 인체공학적 설계로 장시간 착석에도 편안함을 제공합니다. 통기성이 우수한 메쉬 소재로 쾌적한 사용이 가능합니다.")
//                                .font(.body)
//                            
//                            Text("- 인체공학적 설계\n- 고급 메쉬 소재 사용\n- 조절 가능한 팔걸이\n- 최대 하중: 120kg")
//                                .font(.body)
//                                .lineSpacing(5)
//                        }
                    }
                    .padding()
                }
                .navigationTitle("제품 상세")
                
            }
        }
        .onAppear(perform: {
            Task{
                product = try await productViewModel.fetchDetail()
            }

        })
    }
}

//#Preview {
//    DetailView(
////        product: Product(id: "1", name: "제품", price: 1234, imagePath: "https://zeushahn.github.io/Test/images/mov01.jpg", quantity: 1, category: "1")
////        productViewModel: ProductViewModel(),
////        navigationPath: .constant(NavigationPath())
//    )
//}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var productViewModel = ProductViewModel()
        @StateObject var shoppingBasketViewModel = ShoppingBasketViewModel()
        DetailView(
            productViewModel: productViewModel,
            shoppingBasketViewModel: shoppingBasketViewModel,
            navigationPath: .constant(NavigationPath())
        )
    }
}

