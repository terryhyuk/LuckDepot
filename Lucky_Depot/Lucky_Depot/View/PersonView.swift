//
//  PersonView.swift
//  final_project
//
//  Created by Eunji Kim on 1/15/25.
//

import SwiftUI

struct PersonView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Binding var selectedTab: Tab
    @Binding var navigationPath: NavigationPath
    @ObservedObject var userRealM: UserLoginViewModel
    @ObservedObject var orderViewModel: OrderViewModel
    
    @State var userOrder: [Order] = []
    @State var userName: String = ""
    @State var userEmail: String = ""
    
    @State var shipping : Int = 0
    
    var body: some View {
               ZStack {
                   backgroundColor
                     .ignoresSafeArea()
                   VStack(spacing:20, content:{
                       // 유저 정보
                       VStack(alignment: .leading, spacing: 5, content: {
                           Text(userName)
                               .bold()
                               .font(.title2)
                           Text(userEmail)
                           //Text(String(userRealM.realMUser[0].id))
                           
                       })
                       .padding(30)
                       .padding(.leading, 30)
                       .frame(maxWidth: .infinity, alignment: .leading)
                       .background(.white)
                       .clipShape(.rect(cornerRadius: 10))
                       .shadow(color: .black.opacity(0.08), radius: 5, x: 2, y: 2)

                       
                       // 주문 배송 현황
                       VStack(spacing: 20, content: {
                       
                           Text("Order/Delivery Status")
                               .frame(maxWidth: .infinity, alignment: .leading)

                           HStack(content:{
                               VStack(spacing:5, content:{
                                   Text(String(userOrder.count))
                                       .foregroundStyle(.blue)
                                       .bold()
                                       .font(.title2)
                                   Text("Ordered")
                               })
                               
                               Divider()
                                   .frame(height: 60)
                                   .padding(.horizontal, 30)
                               
                               VStack(spacing:5, content:{
                                   Text(String(shipping))
                                       .foregroundStyle(.blue)
                                       .bold()
                                       .font(.title2)

                                   Text("Shipping")
                               })
                           })
                           
                       })
                       .padding()
                       .frame(maxWidth:.infinity)
                       .background(.white)
                       .clipShape(.rect(cornerRadius: 10))
                       .shadow(color: .black.opacity(0.08), radius: 5, x: 2, y: 2)

                       
                       VStack(spacing:10,content: {
                       
                       })
                       
                       
                       // 주문내역 및 로그아웃
                       VStack(alignment: .leading, spacing: 15, content: {
                           
                           Button(action:{
                               navigationPath.append("OrderHistoryView")
                               
                           }) {
                               Label("Order History", systemImage: "list.bullet")
                               }
                         
                           Divider()
                           
                           Button(action:{
                               viewModel.signOut()
                               userRealM.deleteUser(user: userRealM.realMUser[0])
                               navigationPathInit()
                                                            
                           }) {
                                   Label("Logout", systemImage: "arrow.right.circle")
                               }
                           .tint(.red)
                       
                       }).padding()
                           .frame(maxWidth:.infinity)
                           .background(.white)
                           .clipShape(.rect(cornerRadius: 10))
                           .shadow(color: .black.opacity(0.08), radius: 5, x: 2, y: 2)

                       
                       
                       Spacer()

                       
                   })
                   .padding(20)
                   .navigationTitle("My")
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
                   
               }.onAppear(perform: {
                   userRealM.fetchUser()
//                   if !userRealM.realMUser.isEmpty {
//                       userName = userRealM.realMUser[0].name
//                       userEmail = userRealM.realMUser[0].email
//                   }
                   userName = userRealM.realMUser[0].name
                   userEmail = userRealM.realMUser[0].email
                   Task{
                       userOrder = try await orderViewModel.fetchUserOrders(userSeq: userRealM.realMUser[0].id)
                       for i in 0..<userOrder.count{
                           if  userOrder[i].status == "배송중" {
                               shipping += 1
                           }
                           
                       }
                   }
                   
               })
               
        }
    func navigationPathInit(){
        navigationPath = NavigationPath()
    }
}
//
//#Preview {
//    PersonView()
//}
