//
//  Order.swift
//  final_project
//
//  Created by Eunji Kim on 1/21/25.
//

struct Order: Decodable {
    var id: String
    var user_seq: Int
    var payment_type: String
    var price: Double
    var address: String
    var order_date: String
    var status: String
    
    init(id: String, user_seq: Int, payment_type: String, price: Double, address: String, order_date: String, status: String) {
        self.id = id
        self.user_seq = user_seq
        self.payment_type = payment_type
        self.price = price
        self.address = address
        self.order_date = order_date
        self.status = status
    }
}
