//
//  DetailView.swift
//  final_project
//
//  Created by Eunji Kim on 1/15/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailView: View {
    let product: Product
    @State private var quantity: Int = 1
//    var body: some View {
//        ScrollView(content: {
//            WebImage(url: URL(string: product.imagePath))
//                .resizable()
//                .scaledToFit()
//                .frame(width: .infinity, height: 400)
//                .cornerRadius(8)
//            
//            Text(product.name)
//                .font(.headline)
//                .padding()
//            
//            Text("\(product.price)원")
//                .font(.caption)
//                .padding()
//
//        })
//    }
    var body: some View {
            ScrollView {
                VStack(spacing: 20) {
                    // Product Image
                    WebImage(url: URL(string: product.imagePath))
                        .resizable()
                        .scaledToFit()
                        .frame(width: .infinity, height: 300)
                        .cornerRadius(8)

                    // Title and Price
                    VStack(alignment: .leading, spacing: 5) {
                        Text("프리미엄 메쉬 사무용 의자")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("289,000원")
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

#Preview {
    DetailView(
        product: Product(id: "1", name: "제품", price: 1234, imagePath: "https://zeushahn.github.io/Test/images/mov01.jpg", quantity: 1, category: "1")
    )
}
