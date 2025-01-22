//
//  CategoryView.swift
//  final_project
//
//  Created by Eunji Kim on 1/15/25.
//

import SwiftUI


struct CategoryView: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State var selectedType: String = "All"

    var body: some View {
        
        ZStack {
            backgroundColor
              .ignoresSafeArea()
            VStack(alignment: .leading, content: {
                
                VStack(content: {
                    
                    Category(selectedType: $selectedType)
                        .padding(.vertical, 10)
                    
                    ScrollView {
                        LazyVGrid(columns: columns, alignment: .center, spacing: 15, content: {
                            ForEach(productList, id: \.id, content: {
                                product in
                                
                                if selectedType == product.category {
                                    
                                    ProductView(product:product)
                                    
                                } else if selectedType == "All" {
                                    
                                    ProductView(product:product)
                                }
                               
                            })
                        })
                    }.padding(.horizontal)
                    Spacer()
                })
                
                
            })
            .navigationTitle("Categories")
        }
            
        
      
      
        
        
    }
}

#Preview {
    CategoryView()
}

struct Category: View {
    let categories: [String] = ["All", "Music", "Sports", "Food", "Travel"]
    @Binding var selectedType: String
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing:15){
                ForEach(categories, id: \.self){ title in
                    Button(title, action: {
                        self.selectedType = title
//                        switch title {
//                                case "Art": type = "76"
//                                case "Cultural": type = "78"
//                                case "Shopping": type = "79"
//                                case "perfomance": type = "85"
//                                case "Accommodation": type = "80"
//                                default:
//                                    type = "76"
//                                                                }
                    })
                    .tint(selectedType == title ? .green : .white)
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
        NavigationLink(destination: DetailView(product: product), label: {
            VStack(alignment:.leading,content: {
                
                Image(product.imagePath)
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
    }
}
