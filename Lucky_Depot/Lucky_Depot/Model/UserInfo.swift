//
//  User.swift
//  Lucky_Depot
//
//  Created by 노민철 on 2/3/25.
//

import Foundation

struct UserInfo: Decodable {
    var id: String
    var seq: Int
    var name: String
    
    init(id: String, seq: Int, name: String) {
        self.id = id
        self.seq = seq
        self.name = name
    }
}

extension UserInfo: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
