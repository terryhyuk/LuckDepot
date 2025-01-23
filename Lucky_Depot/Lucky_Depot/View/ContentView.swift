//
//  ContentView.swift
//  final_project
//
//  Created by Eunji Kim on 1/15/25.
//

import SwiftUI

let backgroundColor = Color.init(white: 0.95)

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State private var showAlert = false // Alert을 표시할지 여부
    @State private var showLoginView = false

    @State var selectedTab: Tab = .home
    
    @State var navigationPath: NavigationPath = NavigationPath()
    @StateObject private var shoppingBasketViewModel = ShoppingBasketViewModel()
    
    var body: some View {
        NavigationStack(path: $navigationPath){
            ZStack{
                backgroundColor
                    .ignoresSafeArea()
                VStack(content: {
                    TabView(selection: $selectedTab, content: {
                        HomeView()
                            .tag(Tab.home)
                        
                        CategoryView()
                            .tag(Tab.category)
                        
                        
                        PersonView()
                            .tag(Tab.person)
                        
//                        CartView(selectedTab: $selectedTab, navigationPath: $navigationPath, shoppingBasketViewModel: shoppingBasketViewModel)
//                            .tag(Tab.cart)
                        
                    })
                })
                
                VStack{
                    Spacer()
                    TabBarView(selectedTab: $selectedTab, navigationPath: $navigationPath)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                }
            }
            .navigationTitle("Lucky Depot")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: String.self) { destination in
                if destination == "CartView" {
                    CartView(selectedTab: $selectedTab, navigationPath: $navigationPath, shoppingBasketViewModel: shoppingBasketViewModel) // 이동할 CartView
                } else if destination == "PaymentsView" {
                    PaymentsView(shoppingBasketViewModel: shoppingBasketViewModel, navigationPath: $navigationPath)
                } else if destination == "SuccessView" {
                    SuccessView(shoppingBasketViewModel: shoppingBasketViewModel, navigationPath: $navigationPath)
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
