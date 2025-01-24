//
//  PaymentsView.swift
//  PayView
//
//  Created by 노민철 on 1/20/25.
//

import SwiftUI
import TossPayments

struct PaymentsView: View {
    static let clientKey: String = "test_ck_DpexMgkW367ekQZ9PG4BVGbR5ozO"

    @ObservedObject var shoppingBasketViewModel: ShoppingBasketViewModel
    @StateObject var orderViewModel: OrderViewModel = OrderViewModel()
    
    @Binding var navigationPath: NavigationPath
    
    // 텍스트 필드
    @State private var deliveryAddress: String = ""
    
    // 에러 알람
    @State var errorAlert: Bool = false
    @State var errorMessage: String = ""
    
    // 결제화면 상태
    @State private var showPaymentView: Bool = false
    
    @State var orderId: String = ""
    @State var totalPrice: Double = 0
    
    let directPurchaseProducts : Product? = nil
    @State var shoppingBasket: [RealMProduct] = []
    
    var body: some View {
        VStack {
            Form {
                Section() {
                    HStack(content: {
                        Image(systemName: "shippingbox")
                        
                        Text("주문 상품")
                    })
                    
                    ForEach(shoppingBasketViewModel.products, id: \.id) { product in
                        OrderProduct(product: product)
                    }
                }
                
                Section() {
                    HStack(content: {
                        Image("local_shipping")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 32)
                        
                        Text("배송지")
                    })
                    
                    TextField("주소를 입력하세요", text: $deliveryAddress)
                }
                
                VStack(alignment: .leading) {
                    HStack(content: {
                        Image(systemName: "creditcard")
                            .frame(width: 20, height: 20)
                        
                        Text("결제 정보")
                            .bold()
                            .font(.system(size: 20))
                    })
                    .padding(.vertical)
                    
                    HStack {
                        Text("상품 금액")
                        Spacer()
//                        Text("₩488,000")
                        Text("$"+String(format : "%.2f", totalPrice))
                    }
                    .padding(.vertical, 4)
                    
                    HStack {
                        // 어떻게 할지 물어보기
                        Text("배송비")
                        Spacer()
                        Text("무료")
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                    
                    Divider()
                    
                    HStack {
                        Text("총 결제금액")
                            .fontWeight(.bold)
                        Spacer()
//                        Text("₩488,000")
                        Text("$"+String(format : "%.2f", totalPrice))
                            .fontWeight(.bold)
                            .foregroundStyle(.blue)
                    }
                    .padding(.vertical, 12)
                    
                    VStack {
                        Button(action: {
                            if deliveryAddress.isEmpty {
                                errorMessage = "주소를 입력해주세요."
                                errorAlert = true
                            } else {
                                Task{
                                    await orderViewModel.insertOrder(user_id: "1", order_id: orderId, payment_type: "card", price: totalPrice, address: deliveryAddress)

                                    await insertDetails()
                                }
                                showPaymentView = true
                            }
                        }, label: {
                            Text("결제하기")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity) // 화면 너비에 맞게 확장
                                .padding() // 버튼 내부 여백
                                .background(Color.green)
                                .cornerRadius(10)
                        })
                        .alert("오류", isPresented: $errorAlert) {
                            Button("OK", role: .cancel) {}
                        } message: {
                            Text(errorMessage)
                        }
                        .popover(isPresented: $showPaymentView, content: {
                            TossPaymentsView(
                                clientKey: PaymentsView.clientKey,
                                paymentMethod: .CARD,
                                paymentInfo: createPaymentInfo(),
                                isPresented: $showPaymentView)
                            .onSuccess { key, id, amount in
                                //                                print(key,id,amount)
                                navigationPath.append("SuccessView")
                                
                                // 주문 정보 입력
                                                            }
                            .onFail({code, message, id in
                                //                                print(code, message, id)
                                errorMessage = message
                                errorAlert = true
                            })
                        })
                    }
                }
            }
        }
        .onAppear(perform: {
            totalPrice = shoppingBasketViewModel.totalPrice()
            orderId = orderViewModel.createOrderNum()
        })
    }
    
    func createOrderName() -> String {
        if shoppingBasketViewModel.productCounts == 1 {
            return shoppingBasketViewModel.products[0].name
        } else {
            return shoppingBasketViewModel.products[0].name + " and " + String(shoppingBasketViewModel.productCounts - 1) + " items"

        }
    }
    
    func insertDetails() async {
        for i in 0..<shoppingBasketViewModel.productCounts {
            await orderViewModel.insertOrderDetail(
                user_id: "1",
                order_id: orderId,
                product_id: shoppingBasketViewModel.products[i].id,
                price: shoppingBasketViewModel.products[i].price,
                quantity: shoppingBasketViewModel.products[i].quantity
            )
        }
    }
    
    func createPaymentInfo() -> DefaultPaymentInfo {
        let orderName = createOrderName()

        return DefaultPaymentInfo(
            amount: totalPrice,
            orderId: orderId,
            orderName: orderName,
            customerName: "박토스" // 유저 이름
        )
    }
}

//#Preview {
////    PaymentsView()
//}

struct PaymentsView_Previews: PreviewProvider {
    @State static var navigationPath = NavigationPath()
    @StateObject static var shoppingBasketViewModel = ShoppingBasketViewModel()

    static var previews: some View {
        PaymentsView(
            shoppingBasketViewModel: shoppingBasketViewModel,
            navigationPath: $navigationPath
        )
    }
}
