//
//  HomeView.swift
//  final_project
//
//  Created by Eunji Kim on 1/15/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {
    @ObservedObject var productViewModel: ProductViewModel = ProductViewModel()
    
    @State var productList: [Product] = []
    @Binding var navigationPath: NavigationPath
    
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
                if productList.isEmpty {
                    ProgressView("상품 리스트 로딩 중...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(height: 200)
                        .padding()

                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, alignment: .center, spacing: 15, content: {
                            ForEach(productList, id: \.id, content: {
                                product in
                                ProductHomeItem(product: product)
                                    .onTapGesture(perform: {
                                        productViewModel.productId = product.id
                                        navigationPath.append("DetailView")
                                        print("Detail")
                                    })
                            })
                        })
                    }
                    .padding(.horizontal)
                    .navigationTitle("Lucky Depot")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationDestination(for: String.self) {
                        destination in
                        
                    }
                }
                
            }
            .onAppear(perform: {
//                testApi.fetchProducts()
//                print(testApi.errorMessage)
                Task{
                    productList = try await productViewModel.fetchProduct()
                }
                
            })
        }
        
    }
}

//#Preview {
//    HomeView()
//}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(
            navigationPath: .constant(NavigationPath())
        )
    }
}
