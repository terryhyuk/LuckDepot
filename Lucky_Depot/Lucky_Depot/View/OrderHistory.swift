//
//  OrderHistory.swift
//  final_project
//
//  Created by Eunji Kim on 1/21/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct OrderHistory: View {
    @Binding var navigationPath: NavigationPath
    @ObservedObject var userRealM: UserLoginViewModel
    @ObservedObject var orderViewModel: OrderViewModel
    @State var userOrder: [UserOrder] = []
    @Binding var order_id: String

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            ScrollView{
                VStack(alignment: .leading, content: {
                    
                    Text("Recent Orders")
                        .font(.system(size:20))
                        .padding(.vertical, 10)
                    
                    ForEach(userOrder, id: \.id){ order in
                        OrderHistoryItem(order: order, navigationPath: $navigationPath, order_id: $order_id)
                    }
                    
                    
                    Spacer()
                    
                })
                .padding()
                .navigationTitle("Order History")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear(perform: {
                    userRealM.fetchUser()
                    Task{
                        userOrder = try await orderViewModel.fetchUserDetailOrders(userSeq: userRealM.realMUser[0].id)
                    }
                    
                })
            }
        }
        
    }
}


//#Preview {
//    OrderHistory(navigationPath: <#Binding<NavigationPath>#>)
//}
