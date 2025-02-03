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
    @State var order_id = "2502031602274b22"
    
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
                                
                                Text(orderDetail!.status)
                                    .padding(10)
                                    .font(.system(size: 14))
                                    .foregroundStyle(.blue)
                                    .background(.blue.opacity(0.4))
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
                                                Text("$\(product.price)")
                                            })
                                            .bold()


                                        })
                                    })
                                }
                            })
                            
                            // http://192.168.50.38:8000/ml/duration/2502031602274b22
                            // 변경하기
                            VStack (alignment: .leading, spacing: 10, content: {
                                Text("Estimated Delivery Date")
                                Text("2025.2.1")
                                    .foregroundStyle(.blue)
                                    .bold()
                                    .font(.system(size:20))
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
            }
        })
        
    }
}


#Preview {
    OrderDetailsView()
}
