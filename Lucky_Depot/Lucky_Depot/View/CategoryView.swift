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
    @State var selectedType: Categoriess? = Categoriess.allCases.first
    @ObservedObject var categoryViewModel: CategoryViewModel = CategoryViewModel()
    @ObservedObject var productViewModel: ProductViewModel = ProductViewModel()
    @State var productList: [Product] = []
    
    var body: some View {
        
        ZStack {
            backgroundColor
              .ignoresSafeArea()
            VStack(alignment: .leading, content: {
                
                VStack(content: {
                    
                    Category(selectedType: $selectedType)
                        .padding(.vertical, 10)
                    
                    ScrollView (showsIndicators: false){
                        LazyVGrid(columns: columns, alignment: .center, spacing: 15, content: {
                            ForEach(productList, id: \.id, content: {
                                product in
                                
                                if selectedType?.rawValue == product.category_id {
                                    
                                    ProductView(product:product)
                                    
                                } else if selectedType?.rawValue == 0 {
                                    
                                    ProductView(product:product)
                                }
                                //ProductView(product:product)

                            })
                        })
                    }.padding(.horizontal)
                    Spacer()
                })
                
                
            })
            .onAppear(perform: {
                Task{
                    productList = try await productViewModel.fetchProduct()
                }
                
            })
            .onChange(of: selectedType?.rawValue, {
                Task{
                    if selectedType?.rawValue == 0 {
                        productList = try await productViewModel.fetchProduct()
                    } else{
                        productList = try await categoryViewModel.fetchCategoryProduct(category_id:  selectedType!.rawValue)
                    }
                }
            })
            .navigationTitle("Categories")
        }
        
    }
}

#Preview {
    CategoryView()
}

struct Category: View {
    @Binding var selectedType: Categoriess?
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing:10){
                ForEach(Categoriess.allCases, id: \.self){ category in
                    Button(category.name, action: {
                        self.selectedType = category

                    })
                    .tint(selectedType == category ? .green : .white)
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


enum Categoriess: Int, CaseIterable {
    case category0 = 0
    case category1 = 1
    case category2 = 2
    case category3 = 3
    case category4 = 4
    case category5 = 5
    case category6 = 6
    case category7 = 7
    case category8 = 8
    case category9 = 9
    
    var name: String {
        switch self {
        case .category0: return "All"
        case .category1: return "Tables"
        case .category2: return "Chairs"
        case .category3: return "Bookcases"
        case .category4: return "storage"
        case .category5: return "Paper"
        case .category6: return "Binders"
        case .category7: return "Copiers"
        case .category8: return "Envelopes"
        case .category9: return "Fasterners"
        }
    }
}
