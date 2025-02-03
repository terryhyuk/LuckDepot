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
                    VStack(alignment: .leading, spacing:10, content: {
                        HStack(content: {
                            VStack (alignment: .leading, spacing: 5){
                                Text(order.date)
                                
                                HStack(content: {
                                    Text("Order No: ")
                                    Text(order.id)
                                })
                                .foregroundStyle(.gray)
                            }
                            
                            Spacer()
                            
                        })
                        
                        Divider()
                        HStack( spacing: 20,content: {
                            WebImage(url: URL(string: "http://192.168.50.38:8000/product/view/\(order.image)"))
                                .resizable()
                                .frame(width: 70, height: 70)
                                .clipShape(.rect(cornerRadius: 10))
                            VStack (alignment: .leading, content: {
                                Text(order.name)
                                Text("Quantity:"+" "+"\(order.quantity)")
                                    .foregroundStyle(.gray)
                                
                            })
                        })
                        Divider()
                        HStack {
                            Text("Total Price")
                            
                            Spacer()
                            Text("$\(String(format: "%.2f", order.price))")
                                .foregroundStyle(.price)
                                .bold()
                        }
                        .font(.system(size: 18))
                        .padding(.vertical, 5)
                        
                        VStack(alignment: .center, content: {
                            Button("View Order Details", action: {
                                navigationPath.append("OrderDetailsView")
                                
                            })
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .foregroundStyle(.button2)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.gray.opacity(0.4), lineWidth: 1)
                            }
                            
                        })
                    })
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white)
                    .clipShape(.rect(cornerRadius: 10))
                    .shadow(color: .black.opacity(0.08), radius: 5, x: 2, y: 2)
                    
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
