//
//  HomeView.swift
//  final_project
//
//  Created by Eunji Kim on 1/15/25.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]

        NavigationStack {
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
                    ScrollView {
                        LazyVGrid(columns: columns, alignment: .center, spacing: 15, content: {
                            ForEach(productList, id: \.code, content: {
                                product in
                                NavigationLink(destination: DetailView(), label: {
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
                            })
                        })
                    }.padding(.horizontal)
                    .navigationTitle("Lucky Depot")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
