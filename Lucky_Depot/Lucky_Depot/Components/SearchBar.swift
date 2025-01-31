//
//  SearchBar.swift
//  final_project
//
//  Created by Eunji Kim on 1/15/25.
//

import SwiftUI

struct SearchBar: View {
    @State var search: String = ""
    var body: some View {
        VStack(content: {
            HStack {
                Image(systemName: "magnifyingglass")
                    .padding(.leading)
                TextField("Search", text: $search)
                    .padding()
            }
            .background(.white)
            .clipShape(.rect(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray, lineWidth: 1)
            }
        })
        .padding(.horizontal)
    }
}

#Preview {
    SearchBar()
}
