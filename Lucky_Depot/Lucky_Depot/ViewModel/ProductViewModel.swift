//
//  ProductViewModel.swift
//  Lucky_Depot
//
//  Created by 노민철 on 1/23/25.
//

import Foundation

class ProductViewModel: ObservableObject {
    let baseURL = "http://192.168.50.38:8000/"
    @Published var productId: String = ""
    
    func fetchProduct() async throws -> [Product]{
        let url = URL(string: baseURL+"/productList")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Product].self, from: data)
    }
    
    func fetchDetail() async throws -> Product{
        let url = URL(string: baseURL+"/product?product_id=\(productId)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Product.self, from: data)
    }
}
