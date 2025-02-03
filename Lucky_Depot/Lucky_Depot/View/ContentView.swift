//
//  ContentView.swift
//  final_project
//
//  Created by Eunji Kim on 1/15/25.
//

import SwiftUI

let backgroundColor = Color.background

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State private var showAlert = false // Alert을 표시할지 여부
    @State private var showLoginView = false

    @State var selectedTab: Tab = .home
    
    @State var navigationPath: NavigationPath = NavigationPath()
    
    @StateObject private var shoppingBasketViewModel = ShoppingBasketViewModel()
    @State var userRealM : UserLoginViewModel = UserLoginViewModel()
    
    @StateObject private var productViewModel = ProductViewModel()
    var body: some View {
        NavigationStack(path: $navigationPath){
            ZStack{
                backgroundColor
                    .ignoresSafeArea()
                VStack(content: {
                    TabView(selection: $selectedTab, content: {
                        HomeView(navigationPath: $navigationPath)
                            .tag(Tab.home)
                        
                        CategoryView()
                            .tag(Tab.category)
                        
                        
//                        PersonView()
//                            .tag(Tab.person)
                        
                    })
                })

                VStack{
                    Spacer()
                    TabBarView(selectedTab: $selectedTab, navigationPath: $navigationPath)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                }
            }
            .onAppear(perform: {
                print(viewModel.authenticationState)
            })
            .navigationTitle("Lucky Depot")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: String.self) { destination in
                if destination == "CartView" {
                    CartView(selectedTab: $selectedTab, navigationPath: $navigationPath, shoppingBasketViewModel: shoppingBasketViewModel) // 이동할 CartView
                } else if destination == "PaymentsView" {
                    PaymentsView(shoppingBasketViewModel: shoppingBasketViewModel, navigationPath: $navigationPath)
                } else if destination == "SuccessView" {
                    SuccessView(shoppingBasketViewModel: shoppingBasketViewModel, navigationPath: $navigationPath)
                } else if destination == "LoginView" {
                    Loginview(navigationPath: $navigationPath, userRealM: userRealM)
                } else if destination == "PersonView" {
                    PersonView(selectedTab: $selectedTab, navigationPath: $navigationPath, userRealM: userRealM)
                } else if destination == "OrderHistoryView" {
                    OrderHistory(navigationPath: $navigationPath)
                } else if destination == "DetailView" {
                    DetailView(productViewModel: productViewModel, shoppingBasketViewModel: shoppingBasketViewModel, navigationPath: $navigationPath)
                }else if destination == "ShippingStatusView"{
                    ShippingStatusView()
                } else if destination == "OrderDetailsView" {
                    OrderDetailsView()
                }
            }
            
        }
        
    }
}

#Preview {
    ContentView()
}
enum Tab: Int, Identifiable, CaseIterable, Comparable {
    static func < (lhs: Tab, rhs: Tab) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    case  home, category, person, cart
    
    internal var id: Int { rawValue }
    
    var icon: String {
        switch self {
        case .home:
            return "house.fill"
        case .category:
            return "text.page.badge.magnifyingglass"
        case .person:
            return "person.fill"
        case .cart:
            return "cart.fill"

        }
    }
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .category:
            return "Category"
        case .person:
            return "Person"
        case .cart:
            return "Cart"

        }
    }
    
//    var color: Color {
//        switch self {
//        case .home:
//            return .indigo
//        case .game:
//            return .pink
//        case .apps:
//            return .orange
//        case .movie:
//            return .teal
//        }
//    }
}
