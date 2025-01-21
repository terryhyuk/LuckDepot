//
//  User.swift
//  final_project
//
//  Created by Eunji Kim on 1/16/25.
//


import Foundation
import SwiftUI

struct User {
    var id: String
    var name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

}

var userList: [User] = [
    User(id: "user@naver.com", name: "user")
]
