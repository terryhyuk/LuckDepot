//
//  OrderHistoryItem.swift
//  Lucky_Depot
//
//  Created by 노민철 on 2/4/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct OrderHistoryItem: View {
    let order: UserOrder
    @Binding var navigationPath: NavigationPath
    @Binding var order_id: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(order.date)
                    
                    HStack {
                        Text("Order No: ")
                        Text(order.id)
                    }
                    .foregroundStyle(.gray)
                }
                
                Spacer()
            }
            
            Divider()
            HStack(spacing: 20) {
                WebImage(url: URL(string: "https://fastapi.fre.today/product/view/\(order.image)"))
                    .resizable()
                    .frame(width: 70, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack(alignment: .leading) {
                    Text(order.name + (order.count > 0 ? " and \(order.count) items" : ""))
                    Text("Quantity: \(order.quantity)")
                        .foregroundStyle(.gray)
                }
            }
            Divider()
            HStack {
                Text("Total Price")
                
                Spacer()
                Text("$\(String(format: "%.2f", order.price))")
                    .foregroundStyle(.price)
                    .bold()
            }
            .font(.system(size: 18))
            .padding(.vertical, 5)
            
            VStack {
                Button("View Order Details") {
                    order_id = order.id
                    navigationPath.append("OrderDetailsView")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundStyle(.button2)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray.opacity(0.4), lineWidth: 1)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.08), radius: 5, x: 2, y: 2)
    }
}
