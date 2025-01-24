//
//  ShippingStatusView.swift
//  Lucky_Depot
//
//  Created by Eunji Kim on 1/24/25.
//

import SwiftUI

struct ShippingStatusView: View {

    var body: some View {
            ZStack {
                backgroundColor
                  .ignoresSafeArea()
                VStack(alignment: .leading, content: {
                
//                 Text("ShppingStatus")
//                        .font(.system(size:20))
//                        .padding(.vertical, 10)
                    
                    VStack(alignment: .leading, spacing:10, content: {
                        HStack(content: {
                            VStack (alignment: .leading, spacing: 5){
                                
                                HStack(content: {
                                    Text("Order No: ")
                                    Text("123456")
                                })
                                HStack(content: {
                                    Text("Tracking No: ")
                                    Text("123456")
                                })
                                .foregroundStyle(.gray)

                            }
                           
                            Spacer()
                            
                            Text("Shipping")
                                .padding(10)
                                .font(.system(size: 14))
                                .foregroundStyle(.blue)
                                .background(.blue.opacity(0.4))
                                .clipShape(.rect(cornerRadius: 20))
                            

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
                            
                            })
                        })
                        
                        
                        Divider()
  
                        VStack (alignment: .leading, spacing: 10, content: {
                            Text("Estimated Delivery Date")
                            Text("2025.2.1")
                                .foregroundStyle(.blue)
                                .bold()
                                .font(.system(size:20))
                        
                        })


                        
                    })
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white)
                    .clipShape(.rect(cornerRadius: 10))
                    
       
                    Spacer()
                    
                })
                .padding()
                .navigationTitle("Shipping Status")
                
            }
            
      
      
      
        
        
    }
}


#Preview {
    ShippingStatusView()
}
