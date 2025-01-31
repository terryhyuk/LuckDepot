//
//  ProductViewModel.swift
//  Lucky_Depot
//
//  Created by 노민철 on 1/23/25.
//

import Foundation

class ProductViewModel: ObservableObject {
    let baseURL = "http://127.0.0.1:8000/"
    @Published var productId: Int = 0
    var jsonViewModel: JSONViewModel = JSONViewModel()
    
//    func fetchProduct() async throws -> [Product]{
//        do {
//            let result: JsonResult<[Product]> = try await jsonViewModel.fetchJSON(path: "/product")
//            let products = result.result
//            return products
//        } catch {
//            print("Error: \(error)")
//            throw error
//        }
//    }
//    
//    func fetchDetail() async throws -> Product{
//        let url = URL(string: baseURL+"/product?product_id=\(productId)")!
//        let (data, _) = try await URLSession.shared.data(from: url)
//        return try JSONDecoder().decode(Product.self, from: data)
//    }
    
    
    /// ✅ JWT 포함하여 제품 목록 가져오기
       func fetchProduct() async throws -> [Product] {
           do {
               let result: JsonResult<[Product]> = try await jsonViewModel.fetchJSONList(path: "/product")
               let products = result.result
               return products
           } catch {
               print("❌ API 요청 오류: \(error)")
               throw error
           }
       }
       
       /// ✅ JWT 포함하여 제품 상세 정보 가져오기
       func fetchDetail() async throws -> Product {
           let path = "/product?product_id=\(productId)"
           let result: JsonResult<Product> = try await jsonViewModel.fetchJSON(path: path)
           return result.result
       }
}
