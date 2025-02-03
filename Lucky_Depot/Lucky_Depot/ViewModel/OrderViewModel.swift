//
//  OrderViewModel.swift
//  PayView
//
//  Created by 노민철 on 1/21/25.
//

import Foundation
import CryptoKit

class OrderViewModel: ObservableObject {
    let baseURL = "http://192.168.50.38:8000/"
    
    func createOrderNum(user_seq: Int) -> String{
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyMMddHHmmss" // 원하는 형식 설정
        let formattedDate = formatter.string(from: currentDate)
        
        // SHA-256 해싱
        let hashedData = SHA256.hash(data: Data(String(user_seq).utf8))

        // 16진수 문자열로 변환
        let hexString = hashedData.compactMap { String(format: "%02x", $0) }.joined()

        // 12자리로 자르기
        let result = String(hexString.prefix(4))
        
        let orderNum = formattedDate + result // 1 은 유저 시퀀스
        
        return orderNum
    }
//    func orderDetailFlatten(productList: [Product]) -> String{
//        // 아래와 같이 문자열로 리턴
//        // 제품아이디/갯수/총가격,제품아이디/갯수/총가격,제품아이디/갯수/총가격,제품아이디/갯수/총가격
//        
//        let orderInfoStr = ""
//        return orderInfoStr
//    }
    
    func insertOrder(user_id:Int, order_id:String, payment_type:String, price:Double, address:String, delivery_type: Int) async{
        // 데이터 전달 값 URL 설정
        var urlPath = baseURL + "order?user_seq=\(user_id)&id=\(order_id)&payment_type=\(payment_type)&price=\(price)&address=\(address)&delivery_type=\(delivery_type)"
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: urlPath)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // 값 전달
        do{
            let (_,_) = try await URLSession.shared.data(for: request)
            print("Success to insert")
        }catch{
            print("Failed to insert")
        }
    }
    
    func insertOrderDetail(user_id:Int, order_id:String, product_id:Int, price:Double, quantity:Int, name:String) async{
        // 데이터 전달 값 URL 설정
        var urlPath = baseURL + "detail?user_seq=\(user_id)&id=\(order_id)&product_id=\(product_id)&price=\(price)&quantity=\(quantity)&name=\(name)"
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: urlPath)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // 값 전달
        do{
            let (_,_) = try await URLSession.shared.data(for: request)
            print("Success to insert")
        }catch{
            print("Failed to insert")
        }
    }
    
    func fetch(){
        // 주문목록
    }
    
    func orderDetailInfo(order_id: String) async throws -> OrderDetail{
        guard let url = URL(string: baseURL + "deliver/" + order_id) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        
        return try JSONDecoder().decode(OrderDetail.self, from: data)
    }
}
