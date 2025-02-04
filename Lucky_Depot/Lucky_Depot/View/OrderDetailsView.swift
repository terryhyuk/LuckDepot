//
//  OrderDetailsView.swift
//  Lucky_Depot
//
//  Created by Eunji Kim on 1/24/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct OrderDetailsView: View {
    @StateObject var orderViewModel: OrderViewModel = OrderViewModel()
    
    @State var orderDetail: OrderDetail?
    @State var estimatedDeliveryDate: String?
    @Binding var order_id: String// = "2502031602274b22"
    
    var body: some View {
        VStack(content: {
            if orderDetail == nil{
                ProgressView("loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(height: 200)
                    .padding()

            } else {
                VStack(content: {
                    Form(content: {
                        Section(content: {
                            HStack(content: {
                                VStack(alignment: .leading, content: {
                                    Text("Order No: \(orderDetail!.order_id)")
                                        
                                    Text("Tracking No: \(orderDetail!.deliver_id)")
                                        .foregroundStyle(.gray)
                                })
                                
                                Spacer()
                                
                                Text(statusText(for: orderDetail!.status))
                                    .padding(10)
                                    .font(.system(size: 14))
                                    .foregroundStyle(.blue)
                                    .background(statusColor(for: orderDetail!.status))
                                    .clipShape(.rect(cornerRadius: 20))
                            })
                            // 물건 종류수 만큼 반복
                            VStack(content: {
                                ForEach(orderDetail!.result, id: \.product_name) { product in
                                    HStack(spacing: 20,content: {
                                        WebImage(url:URL(string: product.imagePath))
                                            .resizable()
                                            .frame(width: 70, height: 70)
                                            .clipShape(.rect(cornerRadius: 10))
                                        VStack (alignment: .leading, content: {
                                            Text(product.product_name)
                                            Text("Quantity: " + "\(product.quantity)")
                                                .foregroundStyle(.gray)
                                            HStack(content: {
                                                Text("Price: ")
                                                Spacer()
                                                Text("$\(String(format: "%.2f", product.price))")
                                            })
                                            .bold()


                                        })
                                    })
                                }
                            })
                            
                            VStack (alignment: .leading, spacing: 10, content: {
                                Text("Estimated Delivery Date")
                                if estimatedDeliveryDate == nil {
                                    ProgressView("loading...")
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .frame(height: 200)
                                        .padding()

                                } else {
                                    Text(estimatedDeliveryDate!)
                                        .foregroundStyle(.blue)
                                        .bold()
                                        .font(.system(size:20))
                                }
                                
                            })
                        })
                    })
                })
            }
        })
        .onAppear(perform: {
            orderDetail = nil
            Task{
                try await orderDetail = orderViewModel.orderDetailInfo(order_id: order_id)
                print(orderDetail!.result[0].product_name)
                try await estimatedDeliveryDate = orderViewModel.predictDeliverDurationCalc(order_id: order_id, order_date: orderDetail!.order_date.date)
                print(estimatedDeliveryDate!)
            }
        })
        
    }
    
    func statusColor(for status: String) -> Color {
        switch status {
        case "배송전":
            return Color.gray.opacity(0.4) // 배송전 (회색)
        case "배송중":
            return Color.blue.opacity(0.4) // 배송중 (파란색)
        case "배송완료":
            return Color.green.opacity(0.4) // 배송완료 (녹색)
        default:
            return Color.black.opacity(0.4) // 기본값 (검정색)
        }
    }
    
    func statusText(for status: String) -> String {
        switch status {
        case "배송전":
            return "Pending"  // 배송전 → Pending
        case "배송중":
            return "In Transit"  // 배송중 → In Transit
        case "배송완료":
            return "Delivered"  // 배송완료 → Delivered
        default:
            return "Unknown"  // 기본값
        }
    }
}


//#Preview {
//    OrderDetailsView()
//}
