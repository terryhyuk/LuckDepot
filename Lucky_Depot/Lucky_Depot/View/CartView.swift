//
//  CartView.swift
//  final_project
//
//  Created by Eunji Kim on 1/15/25.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel

    @State var cartList: [Product] = [
        Product(code: "1", name: "copper", price: 12.5, imagePath: "namsan", quantity: 1,category: "Art"),
        Product(code: "2", name: "aluminium", price: 130.3, imagePath: "hyeondai", quantity:1, category: "Art"),
        Product(code: "3", name: "lithium", price: 15.4, imagePath: "lithium", quantity:1, category: "Music"),
        Product(code: "4", name: "nickel", price: 14.5, imagePath: "nickel",  quantity:1, category: "Sports")
    ]

    @Binding var selectedTab: Tab
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor
                  .ignoresSafeArea()
                VStack(content: {
                    HStack(content: {
                        Image(systemName: "cart.fill")
                        Text("n items")
                        Spacer()
                    })
                    .padding(.horizontal)
                    
                    if productList.isEmpty {
                        VStack{
                            Spacer()
                           
                            Button("empty" ,systemImage: "cart", action: {
                                selectedTab = .home
                            })
                            .labelStyle(.iconOnly)
                            .font(.system(size:60))
                            .padding()
    
                            
                            
                            Text("Your cart is empty.")
                                .font(.title2)
                            Spacer()
                        }
                    } else {
                        ScrollView {
                            VStack(content: {
                                ForEach($cartList, id: \.code){ $product in
                                    
                                    HStack(content: {
                                        // 제품 사진 및 네비게이션
                                        NavigationLink(destination: DetailView()) {
                                            Image(product.imagePath)
                                                .resizable()
                                                .frame(width: 100, height: 100)
                                                .scaledToFit()
                                                .cornerRadius(8)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 10, content: {
                                            // 제품 명 및 삭제 버튼
                                            HStack(content: {
                                                Text(product.name)
                                                    .foregroundStyle(.black)
                                                Spacer()
                                                
                                                Button("", systemImage: "trash", action: {
                                                    
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
                                                        product.quantity -= 1
                                                        
                                                    }
                                                }).labelStyle(.iconOnly)
                                                
                                                Text("\(product.quantity)")
                                                Button("", systemImage: "plus", action: {
                                                    product.quantity += 1
                                                    
                                                    
                                                }).labelStyle(.iconOnly)
                                                Spacer()
                                                Text("$"+String(format : "%.2f", product.totalPrice))
                                                    .foregroundStyle(.price)
                                                    .font(.system(size:20, weight: .bold))
                                          }
                                            .foregroundStyle(.black.opacity(0.9))
                                            .padding(.top,10)
                                            
                                            
                                            
                                            
                                        })
                                        .padding(.horizontal)
                                    })
                                    .padding()
                                    .frame(minWidth: 0, maxWidth: .infinity,alignment:.leading )
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .shadow(color: .black.opacity(0.08), radius: 5, x: 2, y: 2)
                                    
                                    
                                }
                            })
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                    }
                    
                    
                    
                    
                })
                .navigationTitle("Cart")
            }
            
        }
    }
}

#Preview {
    CartView(selectedTab: .constant(.home))
}
