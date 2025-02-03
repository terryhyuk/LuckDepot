//
//  Product.swift
//  final_project
//
//  Created by Eunji Kim on 1/15/25.
//

import Foundation
import SwiftUI

struct Product: Identifiable, Decodable {
    var id: Int
    var image: String
    var category_id: Int
    var name: String
    var price: Double
    var quantity: Int
    var totalPrice: Double{  // 전체 금액 (단가 * 수량)
           return price * Double(quantity)
       }
    var imagePath: String{
        return "http://192.168.50.38:8000/product/view/\(image)"
    }

    init(id: Int, image: String, category_id: Int, name: String, price: Double, quantity: Int) {
        self.id = id
        self.image = image
        self.category_id = category_id
        self.name = name
        self.price = price
        self.quantity = quantity
    }
}

extension Product: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

 //테스트 용
var productList: [Product] = [
   // Product(id: 1, name: "copper", price: 12.5, image: "namsan", quantity: 1,category_id: "Food"),
 //   Product(id: 2, name: "aluminium", price: 130.3, image: "hyeondai", quantity:2, category_id: "Food"),
  //  Product(id: 3, name: "lithium", price: 15.4, imag: "lithium", quantity:13, category_id: "Music"),
    Product(id: 1, image: "nickel", category_id: 1, name: "mdm", price: 12, quantity: 1)
]
