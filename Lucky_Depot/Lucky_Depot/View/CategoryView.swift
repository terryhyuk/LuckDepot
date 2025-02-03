//
//  CategoryView.swift
//  final_project
//
//  Created by Eunji Kim on 1/15/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct CategoryView: View {
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State var selectedType: Int = 0
    
    @ObservedObject var categoryViewModel: CategoryViewModel = CategoryViewModel()
    @EnvironmentObject var productViewModel: ProductViewModel
    @State var productList: [Product] = []
    @State var categories : [Categories] = [
        Categories(name: "All", id: 0)
    ]
    
    var body: some View {
        
        ZStack {
            backgroundColor
              .ignoresSafeArea()
            VStack(alignment: .leading, content: {
                CategoryButton(selectedType: $selectedType, categories: $categories)
                    .padding(.vertical, 10)
               
                ScrollView (showsIndicators: false){
                            let filteredProducts = productList.filter { product in
                                       selectedType == 0 || selectedType == product.category_id
                                   }
                                   // 필터링된 제품이 없으면
                                   if filteredProducts.isEmpty {
                                    
                                       VStack {
                                           Image(systemName: "archivebox")
                                               .resizable()
                                               .frame(width: 50, height: 50)
                                               .padding(.bottom, 10)
                                           Text("Product is coming soon")
                                       }
                                       .foregroundColor(.gray)
                                       .frame(maxWidth:.infinity, alignment: .center)
                                       .font(.title2)
                                       .padding(.vertical, 200)
                                       
                                   } else {
                                       // 필터링된 제품들이 있으면 ProductView를 표시
                                       LazyVGrid(columns: columns, alignment: .center, spacing: 15, content: {
                                           ForEach(filteredProducts, id: \.id) { product in
                                               ProductView(product: product)
                                           }
                                       })
                                   }
                            
                        
                    }.padding(.horizontal)
                    
                    Spacer()
             
                
                
            })
            .onAppear(perform: {
                Task{
                    productList = try await productViewModel.fetchProduct()
                    categories.append(contentsOf: try await categoryViewModel.fetchCategories())
                }
                
            })
            .navigationTitle("Categories")
        }
        
    }
}

#Preview {
    CategoryView()
}

struct CategoryButton: View {
    @Binding var selectedType: Int
    @Binding var categories: [Categories]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing:10){
                ForEach(categories, id: \.name){ category in
                    Button(category.name, action: {
                        self.selectedType = category.id

                    })
                    .tint(selectedType == category.id ? .green : .white)
                    .tint(.white)
                    .foregroundStyle(.black)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    .controlSize(.large)
                    .overlay {
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(.gray, lineWidth: 1)
                    }
                    .padding(1)
                    
                }
            }
            
        }.padding(.horizontal, 10)
    }
}

struct ProductView: View {
    let product: Product // product를 저장할 변수

    var body: some View {
        VStack(alignment:.leading,content: {
            
            WebImage(url: URL(string: "http://192.168.50.38:8000/product/view/\(product.image)"))
                .resizable()
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
        
    }
}

