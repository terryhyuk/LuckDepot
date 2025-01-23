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
    var body: some View {
        ZStack{
           backgroundColor
             .ignoresSafeArea()
            VStack(content: {
                TabView(selection: $selectedTab, content: {
                    CategoryView()
                        .tag(Tab.category)
                    
                    HomeView()
                        .tag(Tab.home)
                    
              
                    PersonView()
                            .tag(Tab.person)
                         
                    
                    CartView(selectedTab: $selectedTab)
                        .tag(Tab.cart)

                }).sheet(isPresented: $showLoginView) {
                    Loginview()
                }
            })
           
            VStack{
                Spacer()
                TabBarView(selectedTab: $selectedTab)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
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
    
    case category, home, person, cart
    
    internal var id: Int { rawValue }
    
    var icon: String {
        switch self {
        case .category:
            return "text.page.badge.magnifyingglass"
        case .home:
            return "house.fill"
        case .person:
            return "person.fill"
        case .cart:
            return "cart.fill"

        }
    }
    
    var title: String {
        switch self {
        case .category:
            return "Category"
        case .home:
            return "Home"
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
