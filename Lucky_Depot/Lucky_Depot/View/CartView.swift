//
//  CartView.swift
//  final_project
//
//  Created by Eunji Kim on 1/15/25.
//

import SwiftUI

struct CartView: View {
    @Binding var selectedTab: Tab
    @Binding var navigationPath: NavigationPath
    @StateObject var realMUser: UserLoginViewModel = UserLoginViewModel()
    @ObservedObject var shoppingBasketViewModel: ShoppingBasketViewModel
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            VStack(content: {
                HStack(content: {
                    Image(systemName: "cart.fill")
                    Text("\(shoppingBasketViewModel.productCounts) items")
                    Spacer()
                })
                .padding(.horizontal)
                
                // 상품이 비었을때
                if shoppingBasketViewModel.products.isEmpty{
                    VStack{
                        Spacer()
                        
                        Button("empty" ,systemImage: "cart", action: {
                            selectedTab = .home
                            navigationPathInit()
                        })
                        .labelStyle(.iconOnly)
                        .font(.system(size:60))
                        .padding()
                        
                        Text("Your cart is empty.")
                            .font(.title2)
                        Spacer()
                    }
                }
                // 상품이 있을떄
                else {
                    VStack(content: {
                        CartProductCell(shoppingBasketViewModel: shoppingBasketViewModel)
                        
                        Button("Payments"){
                            if realMUser.realMUser.isEmpty{
                                navigationPath.append("LoginView")
                            } else {
                                navigationPath.append("PaymentsView")
                            }
                             // 페이지2로 이동
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity) // 화면 너비에 맞게 확장
                        .padding() // 버튼 내부 여백
                        .background(Color.green)
                        .cornerRadius(10)
                        .padding()
                        
                    })
                    
                    Spacer()
                }
            })
            .navigationTitle("Cart")
            .navigationBarBackButtonHidden(true)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading, content: {
                    Button(action: {
                        navigationPathInit()
                    }, label: {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    })
                })
            })
        }
        .onAppear(perform: {
            shoppingBasketViewModel.productCountsUpdate()
//            shoppingBasketViewModel.addProduct(product: Product(id: "1", name: "제품1", price: 3000, imagePath: "https://zeushahn.github.io/Test/images/mov01.jpg", quantity: 1, category: "1"))
//            shoppingBasketViewModel.addProduct(product: Product(id: "3", name: "제품3", price: 2000, imagePath: "https://zeushahn.github.io/Test/images/mov03.jpg", quantity: 2, category: "1"))
//            shoppingBasketViewModel.fetchProduct()
//            shoppingBasketViewModel.deleteAll()
        })
    }
    
    func navigationPathInit(){
        navigationPath = NavigationPath()
    }
}

//#Preview {
////    CartView(selectedTab: .constant(.home), navigationPath: <#Binding<NavigationPath>#>)
//}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartViewWrapper()
    }
}

struct CartViewWrapper: View {
    @State private var selectedTab: Tab = .home
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            CartView(selectedTab: $selectedTab, navigationPath: $navigationPath, shoppingBasketViewModel: ShoppingBasketViewModel())
        }
    }
}

