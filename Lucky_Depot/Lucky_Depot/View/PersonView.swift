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
    
    @State var userName: String = ""
    @State var userEmail: String = ""

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
                           
                       })
                       .padding(30)
                       .padding(.leading, 30)
                       .frame(maxWidth: .infinity, alignment: .leading)
                       .background(.white)
                       .clipShape(.rect(cornerRadius: 10))
                       
                       // 주문 배송 현황
                       VStack(spacing: 20, content: {
                       
                           Text("Order/Delivery Status")
                               .frame(maxWidth: .infinity, alignment: .leading)

                           HStack(content:{
                               VStack(spacing:5, content:{
                                   Text("5")
                                       .foregroundStyle(.price)
                                       .bold()
                                       .font(.title2)
                                   Text("Ordered")
                               })
                               
                               Divider()
                                   .frame(height: 60)
                                   .padding(.horizontal, 30)
                               
                               VStack(spacing:5, content:{
                                   Text("1")
                                       .foregroundStyle(.price)
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
                       
                       VStack(spacing:10,content: {
                       
                       })
                       
                       
                       
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
//                               userRealM.deleteAll()
                               navigationPathInit()
                               
                           }) {
                                   Label("Logout", systemImage: "arrow.right.circle")
                               }
                           .tint(.red)
                       
                       }).padding()
                           .frame(maxWidth:.infinity)
                           .background(.white)
                           .clipShape(.rect(cornerRadius: 10))

               
                       
                       
                       
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
                   userName = userRealM.realMUser[0].name
                   userEmail = userRealM.realMUser[0].email
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
