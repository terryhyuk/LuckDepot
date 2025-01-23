//
//  User.swift
//  final_project
//
//  Created by Eunji Kim on 1/16/25.
//


import Foundation
import SwiftUI

struct UserProfile{
    var id: String
    var name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

}

var userList: [UserProfile] = [
    UserProfile(id: "user@naver.com", name: "user")
]
