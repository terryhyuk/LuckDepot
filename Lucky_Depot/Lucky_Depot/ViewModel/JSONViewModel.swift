//
//  JSONViewModel.swift
//  Lucky_Depot
//
//  Created by 노민철 on 1/24/25.
//

import Foundation

struct JSONViewModel {
    // JsonResult를 data로 반환
    // 각각의 ViewModel에서 data를 Decode하면 됌.
    let baseURL = "http://192.168.50.38:8000"
    
    // path는 / 부터 시작
    // result : [] 일때
    // 예시
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
    func fetchJSONList<T: Decodable>(path: String) async throws -> JsonResult<[T]> {
        guard let url = URL(string: baseURL + path) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        return try JSONDecoder().decode(JsonResult<[T]>.self, from: data)
    }
    // result : {} 일때
    func fetchJSON<T: Decodable>(path: String) async throws -> JsonResult<T> {
        guard let url = URL(string: baseURL + path) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        return try JSONDecoder().decode(JsonResult<T>.self, from: data)
    }
}
