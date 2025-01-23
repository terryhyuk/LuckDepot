//
//  Lucky_DepotApp.swift
//  Lucky_Depot
//
//  Created by 노민철 on 1/21/25.
//

import SwiftUI
import Firebase
import GoogleSignIn
import FBSDKCoreKit

@main
struct Lucky_DepotApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authenticationViewModel = AuthenticationViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authenticationViewModel)
           
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      
    // Facebook SDK 초기화
    ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
      
      // Google 로그인 초기화
    GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                  // 이전 로그인 상태 복원 (옵션)
              }
    return true
  }
    // Facebook 로그인 처리
        func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
            // Facebook SDK의 open URL 처리
            let handled = ApplicationDelegate.shared.application(
                app,
                open: url,
                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            )
            return  handled
           
        }
    
}

