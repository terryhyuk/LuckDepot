//
//  OrderDetailsView.swift
//  Lucky_Depot
//
//  Created by Eunji Kim on 1/24/25.
//

import SwiftUI

struct OrderDetailsView: View {

    var body: some View {
            ZStack {
                backgroundColor
                  .ignoresSafeArea()
                VStack(alignment: .leading, content: {
                
//                 Text("Recent Orders")
//                        .font(.system(size:20))
//                        .padding(.vertical, 10)
                    
                    VStack(alignment: .leading, spacing:10, content: {
                        HStack(content: {
                            VStack (alignment: .leading, spacing: 5){
                                Text("2025-1-20")
                                
                                HStack(content: {
                                    Text("Order No: ")
                                    Text("123456")
                                })
                                .foregroundStyle(.gray)
                            }
                           
                            Spacer()

                        })
                        
                        Divider()
                        HStack( spacing: 20,content: {
                            Image("pen")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .clipShape(.rect(cornerRadius: 10))
                            VStack (alignment: .leading, content: {
                                Text("Ballpoint Pen")
                                Text("Quantity:"+" "+"1")
                                    .foregroundStyle(.gray)
                                HStack(content: {
                                    Text("Price: ")
                                    Spacer()
                                    Text("$15")
                                })
                                .bold()

                            
                            })
                        })
                        
                        
                        Divider()
                        HStack( spacing: 20,content: {
                            Image("pen2")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .clipShape(.rect(cornerRadius: 10))
                            VStack (alignment: .leading, content: {
                                Text("Ballpoint Pen")
                                Text("Quantity:"+" "+"1")
                                    .foregroundStyle(.gray)
                                HStack(content: {
                                    Text("Price: ")
                                    Spacer()
                                    Text("$12.5")
                                })
                                .bold()
                            })
                        })
                        
                        
                        Divider()
                        HStack {
                            Text("Total Price")

                            Spacer()
                            Text("$27.5")
                                .bold()
                        }
                        .font(.system(size: 18))
                        .padding(.vertical, 5)
                        .bold()
                        .foregroundStyle(.blue)

                        

                        
                    })
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white)
                    .clipShape(.rect(cornerRadius: 10))
      
                    
                    Spacer()
                    
                })
                .padding()
                .navigationTitle("Order Details")
                
            }
            
      
      
      
        
        
    }
}


#Preview {
    OrderDetailsView()
}
