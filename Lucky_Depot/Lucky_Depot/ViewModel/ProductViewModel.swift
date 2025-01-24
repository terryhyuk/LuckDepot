//
//  ProductViewModel.swift
//  Lucky_Depot
//
//  Created by 노민철 on 1/23/25.
//

import Foundation

class ProductViewModel: ObservableObject {
    let baseURL = "http://192.168.50.38:8000/"
    @Published var productId: Int = 0
    var jsonViewModel: JSONViewModel = JSONViewModel()
    
    func fetchProduct() async throws -> [Product]{
        do {
            let result: JsonResult<[Product]> = try await jsonViewModel.fetchJSON(path: "/product")
            let products = result.result
            return products
        } catch {
            print("Error: \(error)")
            throw error
        }
    }
    
    func fetchDetail() async throws -> Product{
        let url = URL(string: baseURL+"/product?product_id=\(productId)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Product.self, from: data)
    }
}
