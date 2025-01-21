//
//  OrderViewModel.swift
//  PayView
//
//  Created by 노민철 on 1/21/25.
//

import Foundation

class OrderViewModel: ObservableObject {
    let baseURL = "http://127.0.0.1:8000/"
    
    func createOrderNum() -> String{
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyMMddHHmmss" // 원하는 형식 설정
        let formattedDate = formatter.string(from: currentDate)
        
        let orderNum:String = formattedDate+"1"
        
        return orderNum
    }
    
    func orderDetailFlatten(productList: [Product]) -> String{
        // 아래와 같이 문자열로 리턴
        // 제품아이디/갯수/총가격,제품아이디/갯수/총가격,제품아이디/갯수/총가격,제품아이디/갯수/총가격
        
        let orderInfoStr = ""
        return orderInfoStr
    }
    
    func insertOrder(user_id:String, payment_type:String, price:Int, address:String) async{
        // 데이터 전달 값 URL 설정
        var urlPath = baseURL + "insertOrder?user_id=\(user_id)&payment_type=\(payment_type)&price=\(price)&address=\(address)"
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
    
    func insertOrderDetail(user_id:String, order_id:String, orderInfo:String) async{
        // 데이터 전달 값 URL 설정
        var urlPath = baseURL + "insertOrderDetail?user_id=\(user_id)&order_id=\(order_id)&orderInfo=\(orderInfo)"
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
