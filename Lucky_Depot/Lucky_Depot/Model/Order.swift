//
//  Order.swift
//  final_project
//
//  Created by Eunji Kim on 1/21/25.
//

struct Order {
    var id: Int
    var userId: Int
    var productId: Int
    var productName: String
    var quantity: Int
    var price: Double
    var payment: String
    var address: String
    var orderDate: String
    var status: String?

    init(id: Int, userId: Int, productId: Int, productName: String, quantity: Int, price: Double, payment: String, address: String, orderDate: String, status: String? = nil) {
        self.id = id
        self.userId = userId
        self.productId = productId
        self.productName = productName
        self.quantity = quantity
        self.price = price
        self.payment = payment
        self.address = address
        self.orderDate = orderDate
        self.status = status
    }
}

var orderList: [Order] = [
    
    Order(id: 1, userId: 1, productId: 1, productName: "Ballpoint Pen", quantity: 2, price: 7.5, payment: "toss", address: "gangnam, Seoul", orderDate: "2024-1-15", status: "배송완료"),
    Order(id: 2, userId: 1, productId: 2, productName: "Notebook", quantity: 2, price: 15, payment: "toss", address: "gangnam, Seoul", orderDate: "2024-1-21", status: "배송중")
]
