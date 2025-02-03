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
    
    func createOrderNum() -> String{
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyMMddHHmmss" // 원하는 형식 설정
        let formattedDate = formatter.string(from: currentDate)
        
        var user_seq = "1" // 유저 시퀀스
        
        // SHA-256 해싱
        let hashedData = SHA256.hash(data: Data(user_seq.utf8))

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
    
    func insertOrder(user_id:String, order_id:String, payment_type:String, price:Double, address:String) async{
        // 데이터 전달 값 URL 설정
        var urlPath = baseURL + "insertOrder?user_id=\(user_id)&order_id=\(order_id)&payment_type=\(payment_type)&price=\(price)&address=\(address)"
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: urlPath)!
        
        // 값 전달
        do{
            let (_,_) = try await URLSession.shared.data(from: url)
            print("Success to insert")
        }catch{
            print("Failed to insert")
        }
    }
    
    func insertOrderDetail(user_id:String, order_id:String, product_id:Int, price:Double, quantity:Int) async{
        // 데이터 전달 값 URL 설정
        var urlPath = baseURL + "insertOrderDetail?user_id=\(user_id)&order_id=\(order_id)&product_id=\(product_id)&price=\(price)&quantity=\(quantity)"
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: urlPath)!
        
        // 값 전달
        do{
            let (_,_) = try await URLSession.shared.data(from: url)
            print("Success to insert")
        }catch{
            print("Failed to insert")
        }
    }
    
    func fetch(){
        // 주문목록
    }
}
