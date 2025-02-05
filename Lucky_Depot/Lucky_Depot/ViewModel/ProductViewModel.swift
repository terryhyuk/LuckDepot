//
//  ProductViewModel.swift
//  Lucky_Depot
//
//  Created by 노민철 on 1/23/25.
//

import Foundation

class ProductViewModel: ObservableObject {
    let baseURL = "https://fastapi.fre.today/"
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
    func fetchProduct(search: String? = nil) async throws -> [Product] {
        if let jwtToken = UserDefaults.standard.string(forKey: "jwtToken") {
        } else {
            print("⚠️ API 요청 시 JWT 없음")
        }
        let keyword: String = search ?? ""
        
        do {
            let result: JsonResult<[Product]> = try await jsonViewModel.fetchJSONList(path: "/product/?keyword=\(keyword)")
            let products = result.result
            return products
        } catch {
            print("❌ API 요청 오류: \(error)")
            throw error
        }
    }
    
    
    /// ✅ JWT 포함하여 제품 상세 정보 가져오기
    func fetchDetail() async throws -> Product {
        let path = "/product/\(productId)/"
        let result: JsonResult<Product> = try await jsonViewModel.fetchJSON(path: path)
        return result.result
    }
}
