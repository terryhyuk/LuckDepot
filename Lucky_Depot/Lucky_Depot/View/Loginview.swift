//
//  Loginview.swift
//  Lucky_Depot
//
//  Created by Eunji Kim on 1/22/25.
//

import SwiftUI
import Firebase
import GoogleSignInSwift
import FBSDKLoginKit

struct Loginview: View {

    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    @Binding var navigationPath: NavigationPath
    @ObservedObject var userRealM: UserLoginViewModel

    var body: some View {
        if viewModel.islogging == true {
            VStack{
                Image(systemName: "progress.indicator")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .symbolEffect(.variableColor.iterative.hideInactiveLayers.nonReversing, options: .repeat(.continuous))
                    .foregroundStyle(.button2)
            }
        } else {
            VStack(content:{
                
                Image("luckydepot")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .foregroundStyle(.blue, .green)
                
                Text("Lucky Depot")
                    .font(.title)
                    .fontWeight(.heavy)
                
                Text("Please login to continue shopping")
                    .padding(.bottom, 30)
                
                Button(action:{
                    signInWithGoogle()
                }){
                    Text("Continue with Google")
                        .foregroundStyle(.black.opacity(0.7))
                        .bold()
                        .frame(maxWidth: .infinity)
                        .background(alignment: .leading){
                            Image("google")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                }
                .padding()
                    .background(Color.white)
                    .cornerRadius(8.0)
                    .shadow(radius: 4.0)
                
                
                Button(action:{
                    signInWithFacebook()
                }){
                    Text("Continue with Facebook")
                        .foregroundStyle(.white)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .background(alignment: .leading){
                            Image("facebook")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                }.padding()
                    .background(Color.blue)
                    .cornerRadius(8.0)
                    .shadow(radius: 4.0)
            })
            .padding()
            .navigationTitle("Login")
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
           
        
    }
    
    func navigationPathInit(){
        navigationPath = NavigationPath()
    }
   
    
    private func signInWithGoogle() {
        Task {
          if await viewModel.signInWithGoogle() == true {
              navigationPath.append("PersonView")
          }
        }
      }
    
    private func signInWithFacebook() {
        Task {
          if await viewModel.signInWithFacebook() == true {
              navigationPath.append("PersonView")
          }
        }
      }
   
}



struct LoginView_Previews: PreviewProvider {
    @State static var navigationPath = NavigationPath()
    @StateObject static var shoppingBasketViewModel = ShoppingBasketViewModel()

    static var previews: some View {
        Loginview(
            navigationPath: $navigationPath, userRealM: UserLoginViewModel()
        )
    }
}
