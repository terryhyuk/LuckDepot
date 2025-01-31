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
    
    @Published var idToken: String?
    // State -> Published 수정
    @Published var userModel: UserViewModel = UserViewModel()
    
    
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
    
    // RealM 데이터와 FirebaseAuth 동기화되게 수정
    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
                self.user = user
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
                self.displayName = user?.email ?? ""
                
                if let firebaseUser = user {
                    print("✅ 로그인된 사용자: \(firebaseUser.email ?? "unknown")")
                    
                    let loginUser = LoginUser(email: firebaseUser.email ?? "", name: firebaseUser.displayName ?? "Unknown User")
                    
                    // ✅ 기존 Realm addUser() 메서드 활용
                    self.userRealM.addUser(user: loginUser)
                } else {
                    print("❌ 로그아웃됨 - Realm 데이터 정리")
                    
                    // ✅ 기존 Realm deleteAll() 메서드 활용
                    self.userRealM.deleteAll()
                }
            }
        }
    }
    
    // 동기화 로직 함수
    func checkAndSyncAuthState() {
        if let firebaseUser = Auth.auth().currentUser {
            let email = firebaseUser.email ?? ""
            let name = firebaseUser.displayName ?? "Unknown User"
            print("✅ Firebase 로그인 상태 확인됨: \(email)")
            let loginUser = LoginUser(email: email, name: name)
            self.userRealM.addUser(user: loginUser)
        } else {
            print("❌ Firebase에 로그인된 사용자가 없음 - Realm 데이터 정리")
            
            // ✅ 기존 Realm의 deleteAll() 활용
            self.userRealM.deleteAll()
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
            
            guard let googleIDToken = user.idToken else {
                throw AuthenticationError.tokenError(message: "ID token missing")
            }
            let accessToken = user.accessToken
            
            let credential = GoogleAuthProvider.credential(withIDToken: googleIDToken.tokenString,
                                                           accessToken: accessToken.tokenString)
            
            _ = try await Auth.auth().signIn(with: credential)
            
            guard let firebaseUser = Auth.auth().currentUser else {
                print("Firebase 로그인 실패")
                return false
            }
            
            // ✅ `getIDToken()`을 Firebase에서 가져와 FastAPI에 전송
            let idToken = try await firebaseUser.getIDToken(forcingRefresh: true)
            print("📡 FastAPI에 전송할 ID Token: \(idToken)")
            
            let jsonResponse = try await userModel.sendUserData(idToken: idToken, type: "google")
            print("📡 서버 응답: \(jsonResponse)")
            
            // ✅ 서버 응답에서 사용자 정보 추출
            if let userData = jsonResponse["user"] as? [String: Any],
               let email = userData["email"] as? String,
               let name = userData["name"] as? String {
                
                let loginUser = LoginUser(email: email, name: name)
                
                // ✅ Realm에 사용자 정보 저장
                userRealM.addUser(user: loginUser)
                print("✅ Realm에 사용자 저장: \(email)")
                
                // ✅ JWT 토큰을 UserDefaults에 저장 (API 요청 시 활용)
                UserDefaults.standard.set(idToken, forKey: "jwtToken")
                print("✅ JWT 토큰 저장 완료: \(idToken)")
            }
            
            print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
            return true
        }
        catch {
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
            return false
        }
    }
    
    
    func signInWithFacebook() async -> Bool {
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
