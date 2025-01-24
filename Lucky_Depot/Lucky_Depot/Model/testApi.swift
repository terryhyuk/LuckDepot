//
//  testApi.swift
//  Lucky_Depot
//
//  Created by Eunji Kim on 1/23/25.
//


import Foundation

class TestApi: ObservableObject {

    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String = "안돼"
    let baseURL = "http://192.168.50.38:8000"

        func fetchProducts() {

            guard let url = URL(string: baseURL+"/product") else {
                errorMessage = "Invalid URL"
                return
            }

            isLoading = true
            
           let task = URLSession.shared.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let error = error {
                        self.errorMessage = "Failed to load data: \(error.localizedDescription)"
                        return
                    }
                    if let response = response as? HTTPURLResponse {
                                print("HTTP Status Code: \(response.statusCode)")
                            }

                    if let jsonData = data {
                        if let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) {
//                            print(jsonObject)
                        }
                    }
                    guard let data = data else {
                        self.errorMessage = "No data received"
                        return
                        
                    }
                    

                    do {
                        let decoder = JSONDecoder()
                                            // "result" 키 안에 있는 데이터를 디코딩
                                            let decodedResponse = try decoder.decode([String: [Product]].self, from: data)
                                            if let products = decodedResponse["result"] {
                                                self.products = products
//                                                print(self.products)
                                            } else {
                                                self.errorMessage = "No products found in response"
                                            }
                    } catch {
                        self.errorMessage = "Failed to decode data: \(error.localizedDescription)"
                    }
                }
           }
        
        task.resume()
        }
}

