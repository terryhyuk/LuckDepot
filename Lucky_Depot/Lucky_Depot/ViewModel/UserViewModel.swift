
//
//  UserViewModel.swift
//  Lucky_Depot
//
//  Created by Eunji Kim on 1/23/25.
//
import Foundation

class UserViewModel: ObservableObject {

    // 서버에 이메일, 이름 전송 후 JSON 응답
    func sendUserData(idToken: String?, type: String?) async throws -> [String: Any] {
        guard let url = URL(string: "http://127.0.0.1:8000/login/google") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let requestBody: [String: Any] = [
            "idToken": idToken ?? "",
            "login_type": type ?? ""
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])


        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                print("📡 Response Status Code: \(httpResponse.statusCode)")
            }

            guard let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                throw URLError(.cannotParseResponse)
            }

            return jsonResponse
        } catch {
            print("❌ Network Error: \(error.localizedDescription)")

            if let urlError = error as? URLError {
                print("🔍 URLError Code: \(urlError.code.rawValue)")
            }

            throw error
        }
    }



}
