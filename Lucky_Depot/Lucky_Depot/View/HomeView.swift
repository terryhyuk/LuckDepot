//
//  HomeView.swift
//  final_project
//
//  Created by Eunji Kim on 1/15/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {
    @StateObject private var testApi = TestApi()

    var body: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]

        ZStack {
            backgroundColor
              .ignoresSafeArea()
            
            VStack(alignment:.leading){
                SearchBar()
                Text("Recommended Items")
                    .alignmentGuide(.bottom) { $0[VerticalAlignment.bottom] }
                    .font(.system(size: 24, design: .rounded))
                    .bold()
                    .padding(.top, 15)
                    .padding(.leading)
                if testApi.products.isEmpty {
                    Text("empty")
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, alignment: .center, spacing: 15, content: {
                            ForEach(testApi.products, id: \.id, content: {
                                product in
                                
                                VStack(alignment:.leading,content: {
                                    
                                    WebImage(url: URL(string: "http://192.168.50.38:8000/product/view/\(product.image)"))
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width:170, height: 150)
                                    
                                    VStack(alignment: .leading){
                                        Text(product.name)
                                            .foregroundStyle(.black)
                                        Spacer()
                                        Text("$"+String(format : "%.2f", product.price))
                                            .foregroundStyle(.black.opacity(0.7))
                                    }
                                    .padding(12)
                                })
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(color: .black.opacity(0.08), radius: 5, x: 2, y: 2)
                                
                            })
                        })
                    }
                    .padding(.horizontal)
                    .navigationTitle("Lucky Depot")
                    .navigationBarTitleDisplayMode(.inline)
                }
                
            }
            .onAppear(perform: {
                testApi.fetchProducts()
                print(testApi.errorMessage)

            })
        }
        
    }
}

#Preview {
    HomeView()
}
