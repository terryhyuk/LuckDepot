//
//  ProductViewModel.swift
//  Lucky_Depot
//
//  Created by 노민철 on 1/23/25.
//

import Foundation

class ProductViewModel: ObservableObject {
    @Published var productId: Int = 1
    var jsonViewModel: JSONViewModel = JSONViewModel()
    
    init() {
//        print(productId)
    }
    
    func fetchProduct() async throws -> [Product]{
        do {
            let result: JsonResult<[Product]> = try await jsonViewModel.fetchJSONList(path: "/product")
            let products = result.result
            return products
        } catch {
            print("Error: \(error)")
            throw error
        }
    }
    
    func fetchDetail() async throws -> Product{
        do {
            let result: JsonResult<Product> = try await jsonViewModel.fetchJSON(path: "/product/\(productId)")
            let product = result.result
            return product
        } catch {
            print("Error: \(error)")
            throw error
        }
    }
}
