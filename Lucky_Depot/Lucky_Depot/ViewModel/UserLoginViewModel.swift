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
        let loginUser = RealMUser()
        loginUser.email = user.email
        loginUser.name = user.name
        
        try! realm.write {
            realm.add(loginUser)
        }
    }
    
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
