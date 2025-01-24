//
//  CategoryViewModel.swift
//  Lucky_Depot
//
//  Created by Eunji Kim on 1/24/25.
//

import Foundation

class CategoryViewModel: ObservableObject {
    let baseURL = "http://192.168.50.38:8000/"
    var jsonViewModel: JSONViewModel = JSONViewModel()
    
    func fetchCategoryProduct(category_id: Int) async throws -> [Product]{
        do {

            let result: JsonResult<[Product]> = try await jsonViewModel.fetchJSON(path: "/product/category/\(category_id)")
            let products = result.result
            return products
        } catch {
            print("Error: \(error)")
            throw error
        }
    }
    
    func fetchCategory() async throws -> [Categories]{
        do {

            let result: JsonResult<[Categories]> = try await jsonViewModel.fetchJSON(path: "/product/category")
            let cateogoies = result.result
            return cateogoies
        } catch {
            print("Error: \(error)")
            throw error
        }
    }
    
//    func fetchDetail() async throws -> Product{
//        let url = URL(string: baseURL+"/product?product_id=\(productId)")!
//        let (data, _) = try await URLSession.shared.data(from: url)
//        return try JSONDecoder().decode(Product.self, from: data)
//    }
}
