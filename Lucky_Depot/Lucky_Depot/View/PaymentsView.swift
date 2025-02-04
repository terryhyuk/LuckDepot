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
    @StateObject var userLoginViewModel: UserLoginViewModel = UserLoginViewModel()
    
    @StateObject var orderViewModel: OrderViewModel = OrderViewModel()
    
    @Binding var navigationPath: NavigationPath
    
    // 텍스트 필드
    @State private var deliveryAddress: String = ""
    
    // 배송 유형
    @State private var selectedValue: Int = 3
    // 옵션 리스트 (텍스트와 매칭되는 값)
    let options: [(label: String, value: Int)] = [
        ("Standard Class", 3),
        ("Second Class", 2),
        ("First Class", 1),
        ("Same Day", 0)
    ]

    
    // 에러 알람
    @State var errorAlert: Bool = false
    @State var errorMessage: String = ""
    
    // 결제화면 상태
    @State private var showPaymentView: Bool = false
    
    @State var orderId: String = ""
    @State var totalPrice: Double = 0
    
    
    var body: some View {
        VStack {
            Form {
                Section() {
                    HStack(content: {
                        Image(systemName: "shippingbox")
                        
                        Text("Products")
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
                        
                        Text("Address")
                    })
                    
                    TextField("ex) New York/Postal code", text: $deliveryAddress)

                    Picker("Select an option", selection: $selectedValue) {
                        ForEach(options, id: \.value) { option in
                            Text(option.label).tag(option.value)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                VStack(alignment: .leading) {
                    HStack(content: {
                        Image(systemName: "creditcard")
                            .frame(width: 20, height: 20)
                        
                        Text("Payments Info")
                            .bold()
                            .font(.system(size: 20))
                    })
                    .padding(.vertical)
                    
                    HStack {
                        Text("Product Price")
                        Spacer()
//                        Text("₩488,000")
                        Text("$"+String(format : "%.2f", totalPrice))
                    }
                    .padding(.vertical, 4)
                    
                    HStack {
                        // 어떻게 할지 물어보기
                        Text("shipping cost")
                        Spacer()
                        Text("Free")
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                    
                    Divider()
                    
                    HStack {
                        Text("Total Price")
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
                                errorMessage = "Insert to Address."
                                errorAlert = true
                            } else {
                                Task{
                                    await orderViewModel.insertOrder(user_id: userLoginViewModel.realMUser[0].id, order_id: orderId, payment_type: "card", price: totalPrice, address: deliveryAddress, delivery_type: selectedValue)

                                    await insertDetails()
                                }
                                showPaymentView = true
                            }
                        }, label: {
                            Text("Payments")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity) // 화면 너비에 맞게 확장
                                .padding() // 버튼 내부 여백
                                .background(Color.green)
                                .cornerRadius(10)
                        })
                        .alert("Error", isPresented: $errorAlert) {
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
            orderId = orderViewModel.createOrderNum(user_seq: userLoginViewModel.realMUser[0].id)
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
                user_id: userLoginViewModel.realMUser[0].id,
                order_id: orderId,
                product_id: shoppingBasketViewModel.products[i].id,
                price: shoppingBasketViewModel.products[i].price,
                quantity: shoppingBasketViewModel.products[i].quantity,
                name: shoppingBasketViewModel.products[i].name
            )
        }
    }
    
    func createPaymentInfo() -> DefaultPaymentInfo {
        let orderName = createOrderName()

        return DefaultPaymentInfo(
            amount: totalPrice,
            orderId: orderId,
            orderName: orderName,
            customerName: userLoginViewModel.realMUser[0].name // 유저 이름
        )
    }
}

//#Preview {
////    PaymentsView()
//}

//struct PaymentsView_Previews: PreviewProvider {
//    @State static var navigationPath = NavigationPath()
//    @StateObject static var shoppingBasketViewModel = ShoppingBasketViewModel()
//
//    static var previews: some View {
//        PaymentsView(
//            shoppingBasketViewModel: shoppingBasketViewModel,
//            navigationPath: $navigationPath
//        )
//    }
//}
