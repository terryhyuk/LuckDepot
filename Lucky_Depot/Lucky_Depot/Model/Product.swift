//
//  Product.swift
//  final_project
//
//  Created by Eunji Kim on 1/15/25.
//

import Foundation
import SwiftUI

struct Product {
    var id: String
    var name: String
    var price: Double
    var imagePath: String
    var category:String
    var quantity: Int
    var totalPrice: Double {  // 전체 금액 (단가 * 수량)
           return price * Double(quantity)
       }

    
    init(id: String, name: String, price: Double, imagePath: String, quantity:Int, category: String) {
        self.id = id
        self.name = name
        self.price = price
        self.imagePath = imagePath
        self.quantity = quantity
        self.category = category
    }
    
}

// 테스트 용
var productList: [Product] = [
    Product(id: "1", name: "copper", price: 12.5, imagePath: "namsan", quantity: 1,category: "Food"),
    Product(id: "2", name: "aluminium", price: 130.3, imagePath: "hyeondai", quantity:2, category: "Food"),
    Product(id: "3", name: "lithium", price: 15.4, imagePath: "lithium", quantity:13, category: "Music"),
    Product(id: "4", name: "nickel", price: 14.5, imagePath: "nickel",  quantity:1, category: "Sports")
]
