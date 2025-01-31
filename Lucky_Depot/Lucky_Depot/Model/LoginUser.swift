//
//  LoginUser.swift
//  Lucky_Depot
//
//  Created by Eunji Kim on 1/23/25.
//

import Foundation
import SwiftUI

struct LoginUser :Decodable{
    var email: String
    var name: String
    var type: String?


    
    init(email: String, name: String) {
        self.email = email
        self.name = name
    }
}
