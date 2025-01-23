//
//  RealMUser.swift
//  Lucky_Depot
//
//  Created by Eunji Kim on 1/23/25.
//

import Foundation
import RealmSwift

class RealMUser: Object , Identifiable{
    @Persisted(primaryKey: true) var email: String
    @Persisted var name: String
}
