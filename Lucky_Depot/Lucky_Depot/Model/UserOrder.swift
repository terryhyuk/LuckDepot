//
//  Order.swift
//  final_project
//
//  Created by Eunji Kim on 1/21/25.
//

struct UserOrder: Decodable {
    var id: String
    var image: String
    var name: String
    var count: Int
    var quantity: Int
    var price: Double
    var date: String

    init(id: String, image: String, name: String, count: Int, quantity: Int, price: Double, date: String) {
        self.id = id
        self.image = image
        self.name = name
        self.count = count
        self.quantity = quantity
        self.price = price
        self.date = date
    }
}
