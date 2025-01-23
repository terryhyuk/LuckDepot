
//
//  UserViewModel.swift
//  Lucky_Depot
//
//  Created by Eunji Kim on 1/23/25.
//
import Foundation

class UserViewModel: ObservableObject {
    let baseURL = "http://192.168.50.38:8000/"
    
    func insertUser(sns_type : String) async throws -> [LoginUser]{
        let url = URL(string: baseURL+"/auth/register?sns_type\(sns_type)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([LoginUser].self, from: data)
    }
    
    // 서버에 이메일, 이름 전송 후 JSON 응답
      func sendUserData(email: String, name: String, userIdentifier: String, loginType: String) async throws -> [String: Any]{
          // FastApi 주소 설정
          guard let url = URL(string: "https://fastapi.fre.today/login") else {
              throw URLError(.badURL)
          }
          
          // URLRequest 생성
          var request = URLRequest(url: url)
          request.httpMethod = "POST"
          request.addValue("application/json", forHTTPHeaderField: "Content-Type")
          
          
          // JSON 바디 구성
          let requestBody: [String: Any] = [
              "email": email,
              "name": name,
              "user_identifier": userIdentifier,
              "login_type": loginType
          ]
          request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
          
          // 비동기 네트워크 통신
          let (data, response) = try await URLSession.shared.data(for: request)
          
          // 응답 상태 확인
          guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
              throw URLError(.badServerResponse)
          }
          
          // JSON 파싱
          guard let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
              throw URLError(.cannotParseResponse)
          }
          
          return jsonResponse
      }
}
