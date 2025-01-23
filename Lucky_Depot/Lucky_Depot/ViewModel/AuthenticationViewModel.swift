//
//  AuthenticationViewModel.swift
//  Lucky_Depot
//
//  Created by Eunji Kim on 1/22/25.
//
import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import FBSDKLoginKit
import SwiftUI

enum AuthenticationState {
  case unauthenticated
  case authenticating
  case authenticated
}

enum AuthenticationFlow {
  case login
  case signUp
}

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    @Published var flow: AuthenticationFlow = .login
  
    @Published var isValid: Bool  = false
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var errorMessage: String = ""
    @Published var user: User?
    @Published var displayName: String = ""
    @State var manager = LoginManager()
    @State var userRealM : UserLoginViewModel = UserLoginViewModel()

    init() {
    registerAuthStateHandler()

    $flow
      .combineLatest($email, $password, $confirmPassword)
      .map { flow, email, password, confirmPassword in
        flow == .login
        ? !(email.isEmpty || password.isEmpty)
        : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
      }
      .assign(to: &$isValid)
  }

  private var authStateHandler: AuthStateDidChangeListenerHandle?

  func registerAuthStateHandler() {
    if authStateHandler == nil {
      authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
        self.user = user
        self.authenticationState = user == nil ? .unauthenticated : .authenticated
        self.displayName = user?.email ?? ""
      }
    }
  }

  func switchFlow() {
    flow = flow == .login ? .signUp : .login
    errorMessage = ""
  }

  private func wait() async {
    do {
      print("Wait")
      try await Task.sleep(nanoseconds: 1_000_000_000)
      print("Done")
    }
    catch { }
  }

  func reset() {
    flow = .login
    email = ""
    password = ""
    confirmPassword = ""
  }
}

extension AuthenticationViewModel {
    

  func signOut() {
    do {
      try Auth.auth().signOut()
    }
    catch {
      print(error)
      errorMessage = error.localizedDescription
    }
  }
}

enum AuthenticationError: Error {
  case tokenError(message: String)
}

extension AuthenticationViewModel {
  func signInWithGoogle() async -> Bool {
    guard let clientID = FirebaseApp.app()?.options.clientID else {
      fatalError("No client ID found in Firebase configuration")
    }
    let config = GIDConfiguration(clientID: clientID)
    GIDSignIn.sharedInstance.configuration = config

    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = windowScene.windows.first,
          let rootViewController = window.rootViewController else {
      print("There is no root view controller!")
      return false
    }

      do {
        let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)

        let user = userAuthentication.user
        guard let idToken = user.idToken else { throw AuthenticationError.tokenError(message: "ID token missing") }
        let accessToken = user.accessToken

        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                       accessToken: accessToken.tokenString)

        let result = try await Auth.auth().signIn(with: credential)
          
        let firebaseUser = result.user
//          print(firebaseUser.email)
//          print(firebaseUser.uid)
//          print(firebaseUser.displayName)
//          print(firebaseUser.isAnonymous)
//          print(firebaseUser.providerData)
//          print(firebaseUser.photoURL)
//          print(firebaseUser.metadata)
//          print(firebaseUser.providerID)
//          print(firebaseUser.tenantID)
//          print(firebaseUser.isEmailVerified)
//          print(firebaseUser.refreshToken)
//          print(firebaseUser.multiFactor)
//          print(firebaseUser.phoneNumber)
        print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
        userRealM.addUser(user: LoginUser(email: firebaseUser.email!, name: firebaseUser.displayName!))
        
        return true
      }
      catch {
        print(error.localizedDescription)
        self.errorMessage = error.localizedDescription
        return false
      }
  }


    
    func signInWithFacebook3() async -> Bool {
        //withCheckedContinuation 비동기 클로저를 동기식으로 기다릴 수 있게 해주는 Swift의 비동기 API
        // 클로저는 비동기 작업을 마친 후 continuation.resume(returning:)으로 결과를 반환
        return await withCheckedContinuation { continuation in
            manager.logIn(permissions: ["public_profile", "email"], from: getRootViewController()) { result, error in
                if let error = error {
                    print("Facebook Login Error: \(error.localizedDescription)")
                    continuation.resume(returning: false)
                    return
                }
                guard let result = result, !result.isCancelled else {
                    print("Facebook login cancelled.")
                    continuation.resume(returning: false)
                    return
                }
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                Auth.auth().signIn(with: credential) { [self] result, error in
                    if let error = error {
                        print("Firebase Auth Error: \(error.localizedDescription)")
                        continuation.resume(returning: false)
                        return
                    }
                    
                    userRealM.addUser(user: LoginUser(email: (result?.user.email)!, name: (result?.user.displayName)!))
                    print("User signed in with Facebook: \(result?.user.uid ?? "")")
                    print("User signed in with Facebook: \(result?.user.email ?? "")")
                    print("User signed in with Facebook: \(result?.user.displayName ?? "")")
                    continuation.resume(returning: true)
                }
            }
        }
    }

        
    func getRootViewController() -> UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene ,
                let rootViewController = scene.windows.first?.rootViewController else {
            return nil
        }
        return getVisibleViewController (from: rootViewController)
    }

    private func getVisibleViewController (from vc: UIViewController) ->
            UIViewController? {
        if let nav = vc as? UINavigationController {
            return getVisibleViewController(from: nav.visibleViewController!)
        }
        if let tab = vc as? UITabBarController {
            return getVisibleViewController(from: tab.selectedViewController!)
        }
        if let presented = vc.presentedViewController {
            return getVisibleViewController(from: presented)
        }
        return vc
    }
}
