//
//  CategoryViewModel.swift
//  Lucky_Depot
//
//  Created by Eunji Kim on 1/24/25.
//

import Foundation

class CategoryViewModel: ObservableObject {
    let baseURL = "https://fastapi.fre.today/"
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
    
    func fetchCategories() async throws -> [Categories]{
        do {

            let result: JsonResult<[Categories]> = try await jsonViewModel.fetchJSON(path: "/category/")
            let cateogoies = result.result
            return cateogoies
        } catch {
            print("Error: \(error)")
            throw error
        }
    }
}
