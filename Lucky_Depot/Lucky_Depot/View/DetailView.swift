//
//  DetailView.swift
//  final_project
//
//  Created by Eunji Kim on 1/15/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailView: View {
    @EnvironmentObject var productViewModel :ProductViewModel
    @Binding var navigationPath: NavigationPath
    @ObservedObject var shoppingBasketViewModel: ShoppingBasketViewModel = ShoppingBasketViewModel()
    
    @State var product: Product?
    @State private var quantity: Int = 1
    
    @State var isAlert: Bool = false

    var body: some View {
        VStack {
            if product == nil {
                ProgressView("데이터 로딩 중...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(height: 200)
                    .padding()
                
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        // Product Image
                        WebImage(url: URL(string: product!.imagePath))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .cornerRadius(8)
                        // Title and Price
                        VStack(alignment: .leading, spacing: 5) {
                            Text(product!.name)
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("$\(String(format: "%.2f", product!.price))")
                                .font(.title3)
                                .foregroundColor(.blue)
                        }
                        
                        // Quantity Selector
                        HStack {
                            Stepper(value: $quantity, in: 1...Int.max) {
                                Text("quantity: \(quantity)")
                                    .font(.body)
                            }
                            .frame(width: 200)
                        }
                        
                        // Action Buttons
                        VStack(spacing: 10) {
                            Button(action: {
                                // Immediate Purchase Action
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
                                // Add to Cart Action
                                isAlert = true
                                // 알러트 확인시 수행으로 변경
                                shoppingBasketViewModel.addProduct(product: product!, quantity: quantity)
                            }) {
                                Text("Add to Cart")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.blue, lineWidth: 2)
                                    )
                            }
                            .alert("Result", isPresented: $isAlert) {
                                Button("OK", role: .cancel) {}
                            } message: {
                                Text("Item added to cart")
                            }
                        }
                        
                        
                        // Icons Section
                        HStack(spacing: 20) {
                            VStack {
                                Image(systemName: "shield")
                                    .font(.title)
                                    .foregroundColor(.gray)
                                Text("1년 제품 보증(?)")
                                    .font(.footnote)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        Divider()
                        
                        // Product Details
                        VStack(alignment: .leading, spacing: 10) {
                            Text("제품 상세 정보")
                                .font(.headline)
                            
                            Text("최고급 메쉬 소재를 사용한 프리미엄 사무용 의자입니다. 인체공학적 설계로 장시간 착석에도 편안함을 제공합니다. 통기성이 우수한 메쉬 소재로 쾌적한 사용이 가능합니다.")
                                .font(.body)
                            
                            Text("- 인체공학적 설계\n- 고급 메쉬 소재 사용\n- 조절 가능한 팔걸이\n- 최대 하중: 120kg")
                                .font(.body)
                                .lineSpacing(5)
                        }
                    }
                    .padding()
                }
                .navigationTitle("제품 상세")
            }
        }
        .onAppear{
            print("onAppear")
            product = nil
            Task{
                do{
                    product = try await productViewModel.fetchDetail()
                }catch{
                    print("nil \(error)")
                }
            }
        }
    }
}

//#Preview {
//    DetailView(
////        product: Product(id: "1", name: "제품", price: 1234, imagePath: "https://zeushahn.github.io/Test/images/mov01.jpg", quantity: 1, category: "1")
//        productViewModel: ProductViewModel(),
//        navigationPath: .constant(NavigationPath())
//    )
//}
