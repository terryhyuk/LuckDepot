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
import Security

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
    @Published var islogging: Bool = false
    
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
                    Task{
                        let seq = try await self.userModel.getUserSeq(email: firebaseUser.email ?? "")
                        print(seq.result)
                        // ✅ 기존 Realm addUser() 메서드 활용
                        self.userRealM.addUser(user: loginUser, seq: seq.result)
                    }
                    self.userRealM.fetchUser()
                    //                    print(self.userRealM.realMUser.count)
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
            //            self.userRealM.addUser(user: loginUser, seq: <#T##Int#>)
            Task{
                let seq = try await self.userModel.getUserSeq(email: firebaseUser.email ?? "")
                print(seq.result)
                // ✅ 기존 Realm addUser() 메서드 활용
                self.userRealM.addUser(user: loginUser, seq: seq.result)
            }
            
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
        islogging = true
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
               let email = userData["id"] as? String,
               let name = userData["name"] as? String {
                
                let loginUser = LoginUser(email: email, name: name)
                
                // ✅ Realm에 사용자 정보 저장
                // userRealM.addUser(user: loginUser)
                Task{
                    let seq = try await self.userModel.getUserSeq(email: firebaseUser.email ?? "")
                    print(seq.result)
                    // ✅ 기존 Realm addUser() 메서드 활용
                    self.userRealM.addUser(user: loginUser, seq: seq.result)
                }
                
                print("✅ Realm에 사용자 저장: \(email)")
                
                // ✅ JWT 토큰을 UserDefaults에 저장 (API 요청 시 활용)
                UserDefaults.standard.set(idToken, forKey: "jwtToken")
                UserDefaults.standard.synchronize() // ⚠️ 동기화 시도 (디버깅 목적)
                print("✅ JWT 토큰 저장 완료: \(idToken)")
                
                // ✅ 저장된 토큰이 정상적으로 저장되었는지 즉시 확인
                if let savedToken = UserDefaults.standard.string(forKey: "jwtToken") {
                    print("🔍 저장된 JWT 토큰 확인: \(savedToken)")
                } else {
                    print("❌ JWT 토큰 저장 실패")
                }
                
                print("✅ JWT 토큰 저장 완료: \(idToken)")
            }
            
            print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
            islogging = false
            return true
        }
        catch {
            self.islogging = false
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
            return false
        }
    }
    
    

    func signInWithFacebook() async -> Bool {
        islogging = true

        return await withCheckedContinuation { continuation in
            manager.logIn(permissions: ["public_profile", "email"], from: getRootViewController()) { result, error in
                if let error = error {
                    print("❌ Facebook Login Error: \(error.localizedDescription)")
                    self.islogging = false
                    continuation.resume(returning: false)
                    return
                }
                guard let result = result, !result.isCancelled else {
                    print("❌ Facebook login cancelled.")
                    self.islogging = false
                    continuation.resume(returning: false)
                    return
                }

                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)

                Task {
                    do {
                        let authResult = try await Auth.auth().signIn(with: credential)
                        let firebaseUser = authResult.user  // ✅ `guard let` 제거 (필수 아님)

                        // ✅ Firebase에서 최신 ID Token 가져오기
                        let idToken = try await firebaseUser.getIDToken(forcingRefresh: true)
                        print("📡 FastAPI에 전송할 ID Token: \(idToken)")

                        // ✅ FastAPI 서버에 사용자 데이터 전송
                        let jsonResponse = try await self.userModel.sendUserData(idToken: idToken, type: "facebook")
                        print("📡 서버 응답: \(jsonResponse)")

                        // ✅ JWT 토큰을 UserDefaults에 저장
                        UserDefaults.standard.set(idToken, forKey: "jwtToken")
                        UserDefaults.standard.synchronize() // ⚠️ 디버깅용 동기화 (실제 앱에서는 불필요)
                        print("✅ JWT 토큰 저장 완료: \(idToken)")

                        // ✅ 저장된 토큰이 정상적으로 저장되었는지 즉시 확인
                        if let savedToken = UserDefaults.standard.string(forKey: "jwtToken") {
                            print("🔍 저장된 JWT 토큰 확인: \(savedToken)")
                        } else {
                            print("❌ JWT 토큰 저장 실패")
                        }

                        // ✅ 서버 응답에서 사용자 정보 추출 및 Realm 저장
                        if let userData = jsonResponse["user"] as? [String: Any],
                           let email = userData["id"] as? String,
                           let name = userData["name"] as? String {
                            
                            let loginUser = LoginUser(email: email, name: name)

                            // ✅ Realm에 사용자 정보 저장
                            Task {
                                let seq = try await self.userModel.getUserSeq(email: firebaseUser.email ?? "")
                                print(seq.result)
                                self.userRealM.addUser(user: loginUser, seq: seq.result)
                            }

                            print("✅ Realm에 사용자 저장: \(email)")
                        }

                        print("✅ Facebook 로그인 완료: \(firebaseUser.uid)")
                        self.islogging = false
                        continuation.resume(returning: true)
                    } catch {
                        print("❌ Firebase Auth Error: \(error.localizedDescription)")
                        self.islogging = false
                        continuation.resume(returning: false)
                    }
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
