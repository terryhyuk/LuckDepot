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
    let baseURL = "http://127.0.0.1:8000"
    
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
    
    
//    func fetchJSONList<T: Decodable>(path: String) async throws -> JsonResult<[T]> {
//        guard let url = URL(string: baseURL + path) else {
//            throw URLError(.badURL)
//        }
//        
//        let (data, _) = try await URLSession.shared.data(from: url)
//        
//        return try JSONDecoder().decode(JsonResult<[T]>.self, from: data)
//    }
//    // result : {} 일때
//    func fetchJSON<T: Decodable>(path: String) async throws -> JsonResult<T> {
//        guard let url = URL(string: baseURL + path) else {
//            throw URLError(.badURL)
//        }
//        
//        let (data, _) = try await URLSession.shared.data(from: url)
//        
//        return try JSONDecoder().decode(JsonResult<T>.self, from: data)
//    }
    
    // Write by LWY Firebase에서 JWT Token을 준다면? UserDefaults에 로그인할 떄 저장하고 담아서 보내기
    private func makeAuthorizedRequest(path: String) throws -> URLRequest {
           guard let url = URL(string: baseURL + path) else {
               throw URLError(.badURL)
           }
           
           var request = URLRequest(url: url)
           request.httpMethod = "GET"
           request.addValue("application/json", forHTTPHeaderField: "Accept")

           // ✅ UserDefaults에서 JWT 토큰 가져오기
           if let token = UserDefaults.standard.string(forKey: "jwtToken") {
               request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
               print("📡 JWT 토큰 포함 요청: \(token)")
           } else {
               print("⚠️ JWT 토큰 없음, 인증 없이 요청 진행")
           }
           
           return request
       }
    /// ✅ 리스트 응답이 필요한 API 요청 (ex: `[Product]`)
        func fetchJSONList<T: Decodable>(path: String) async throws -> JsonResult<[T]> {
            let request = try makeAuthorizedRequest(path: path)
            let (data, _) = try await URLSession.shared.data(for: request)
            return try JSONDecoder().decode(JsonResult<[T]>.self, from: data)
        }

        /// ✅ 단일 객체 응답이 필요한 API 요청 (ex: `Product`)
        func fetchJSON<T: Decodable>(path: String) async throws -> JsonResult<T> {
            let request = try makeAuthorizedRequest(path: path)
            let (data, _) = try await URLSession.shared.data(for: request)
            return try JSONDecoder().decode(JsonResult<T>.self, from: data)
        }
}
