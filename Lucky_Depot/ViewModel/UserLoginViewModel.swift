//
//  UserLoginViewModel.swift
//  Lucky_Depot
//
//  Created by Eunji Kim on 1/23/25.
//


import Foundation
import RealmSwift

class UserLoginViewModel: ObservableObject {
    private var realm: Realm
    @Published var realMUser: Results<RealMUser>
    
    init() {
        // Realm 인스턴스 초기화
        realm = try! Realm()
        realMUser = realm.objects(RealMUser.self)
    }
    
    func fetchUser() {
        realMUser = realm.objects(RealMUser.self)
    }
    
    // 유저 추가 함수
    func addUser(user: LoginUser) {
        let realm = try! Realm()

        try! realm.write {
            if let existingUser = realm.objects(RealMUser.self).filter("email == %@", user.email).first {
                // ✅ 이미 존재하는 경우 업데이트 처리
                existingUser.name = user.name
                print("⚠️ Realm 사용자 업데이트됨: \(user.email)")
            } else {
                // ✅ 존재하지 않는 경우에만 새로 추가
                let loginUser = RealMUser()
                loginUser.email = user.email
                loginUser.name = user.name
                realm.add(loginUser)
                print("✅ Realm에 사용자 추가됨: \(user.email)")
            }
        }
    }
    
//    func addUser(user: LoginUser) {
//        let loginUser = RealMUser()
//        loginUser.email = user.email
//        loginUser.name = user.name
//        
//        try! realm.write {
//            realm.add(loginUser)
//        }
//    }
    
    // 유저 삭제 함수
    func deleteUser(user: RealMUser) {
        try! realm.write {
            realm.delete(user)
        }
        fetchUser()
    }
    
    // 상품 전체 삭제
    func deleteAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }
}
