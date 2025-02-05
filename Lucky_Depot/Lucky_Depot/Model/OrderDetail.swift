//
//  OrderDetail.swift
//  Lucky_Depot
//
//  Created by 노민철 on 2/3/25.
//

import Foundation

// 개별 제품 정보 모델
struct OrderDetailProduct: Decodable {
    let product_name: String
    let image: String
    let quantity: Int
    let price : Double
    var imagePath: String{
        return "https://fastapi.fre.today/product/view/\(image)"
    }
}

// 주문 날짜 정보 모델
struct OrderDate: Decodable {
    let date: String
    let month: Int
    let year: Int
    let weekday: Int
}

// 전체 주문 정보 모델
struct OrderDetail: Decodable {
    let result: [OrderDetailProduct]
    let deliver_id: String
    let order_id: String
    let status: String
    let order_date: OrderDate
    let address: String
    let delivery_type: Int
}
