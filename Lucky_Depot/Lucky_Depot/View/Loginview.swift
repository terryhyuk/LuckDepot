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
    @State var manager = LoginManager()

    var body: some View {
        NavigationStack {
            
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme:  .light, style: .wide, state: .normal), action: {})
            
            Button(action:{
                signInWithGoogle()
            }){
                Text("Sign in with Google")
                    .frame(maxWidth: .infinity)
                    .background(alignment: .leading){
                        //Image("Google")
                    }
            }
            Button(action:{
                viewModel.signInWithFacebook()
            }){
                Text("Sign in with Facebook")
                    .frame(maxWidth: .infinity)
                    .background(alignment: .leading){
                    }
            }
        }
    }
    
   
    
    private func signInWithGoogle() {
        Task {
          if await viewModel.signInWithGoogle() == true {
            dismiss()
          }
        }
      }
    
   
}

#Preview {
    Loginview()
}
