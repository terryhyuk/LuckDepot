//
//  tabView.swift
//  final_project
//
//  Created by Eunji Kim on 1/15/25.
//

import SwiftUI

struct TabBarView: View {
    @Binding var selectedTab: Tab // TabView와 연결된 selectedTab
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.white)
                .shadow(color: .gray.opacity(0.4), radius: 20, x: 0, y: 20)
            
            TabsLayoutView(selectedTab: $selectedTab, navigationPath: $navigationPath)
        }
        .frame(height: 70, alignment: .center)
    }
}


private struct TabsLayoutView: View {
    @Binding var selectedTab: Tab // TabView와 연결된 selectedTab
    @Namespace var namespace
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        HStack {
            Spacer(minLength: 0)
            
            ForEach(Tab.allCases) { tab in
                TabButton(tab: tab, selectedTab: $selectedTab, namespace: namespace, navigationPath: $navigationPath)
                    .frame(width: 65, height: 65, alignment: .center)
                
                Spacer(minLength: 0)
            }
        }
    }
    
    
    
    private struct TabButton: View {
        let tab: Tab
        @Binding var selectedTab: Tab
        var namespace: Namespace.ID
        @Binding var navigationPath: NavigationPath
        
        var body: some View {
            Button {
                print(tab)
                withAnimation {
//                    selectedTab = tab
                    if tab != .cart { // cart가 아닐 때만 selectedTab을 업데이트
                        selectedTab = tab
                    } else {
                        navigationPath.append("CartView")
                    }
                }
            } label: {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(.button2)
                            .shadow(radius: 10)
                            .background {
                                Circle()
                                    .stroke(lineWidth: 15)
                                    .foregroundColor(.white)
                            }
                            .offset(y: -10)
                            .matchedGeometryEffect(id: "Selected Tab", in: namespace)
                            .animation(.spring(), value: selectedTab)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: 23, weight: .semibold, design: .rounded))
                        .foregroundColor(isSelected ? .init(white: 0.9) : .gray)
                        .scaleEffect(isSelected ? 1 : 0.8)
                        .offset(y: isSelected ? -10 : 0)
                        .animation(isSelected ? .spring(response: 0.5, dampingFraction: 0.3, blendDuration: 1) : .spring(), value: selectedTab)
                }
            }
            .buttonStyle(.plain)
        }
        
        private var isSelected: Bool {
            selectedTab == tab
        }
    }
}


//struct TabBarView1_Previews: PreviewProvider {
//    @State static var selectedTab: Tab = .home
//    static var previews: some View {
//        TabBarView(selectedTab: $selectedTab)
//            .padding(.horizontal)
//    }
//}
