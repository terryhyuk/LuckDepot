//
//  SearchBar.swift
//  final_project
//
//  Created by Eunji Kim on 1/15/25.
//

import SwiftUI

struct SearchBar: View {
    @State var search: String = ""
    @Binding var productList: [Product]
    @EnvironmentObject var productViewModel: ProductViewModel
    
    var body: some View {
        VStack(content: {
            HStack {
                Image(systemName: "magnifyingglass")
                    .padding(.leading)
                TextField("Search", text: $search)
                    .padding()
                    .onChange(of: search, {
                        Task{
                            productList = try await productViewModel.fetchProduct(search: search)
                        }
                    })
            }
            .background(.white)
            .clipShape(.rect(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray, lineWidth: 1)
            }
        })
        .padding(.horizontal)
        .onAppear(perform: {
            search = ""
        })
    }
}

//#Preview {
//    SearchBar()
//}
