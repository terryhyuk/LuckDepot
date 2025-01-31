//
//  RealMProduct.swift
//  PayView
//
//  Created by 노민철 on 1/21/25.
//

import Foundation
import RealmSwift

class RealMProduct: Object {
    @Persisted var id: String
    @Persisted var name: String
    @Persisted var price: Double
    @Persisted var imagePath: String
    @Persisted var quantity: Int
    @Persisted var category: String
}
