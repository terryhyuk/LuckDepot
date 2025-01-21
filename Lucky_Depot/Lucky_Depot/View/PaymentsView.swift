//
//  PaymentsView.swift
//  PayView
//
//  Created by 노민철 on 1/20/25.
//

import SwiftUI
import TossPayments

private enum Constants {
    static let clientKey: String = "test_ck_DpexMgkW367ekQZ9PG4BVGbR5ozO"
}


struct PaymentsView: View {
//    @State var productList: [Product] = [
//        Product(id: "1", name: "제품", price: 1234, imagePath: "https://zeushahn.github.io/Test/images/mov01.jpg", quantity: 1, category: "1"),
//        Product(id: "2", name: "제품2", price: 2334, imagePath: "https://zeushahn.github.io/Test/images/mov01.jpg", quantity: 1, category: "1"),
//    ]
    
    @StateObject private var shoppingBasketViewModel = ShoppingBasketViewModel()
    
    @Binding var navigationPath: NavigationPath
    
    // 텍스트 필드
    @State private var deliveryAddress: String = ""
    @State private var contactNumber: String = ""
    
    // 에러 알람
    @State var errorAlert: Bool = false
    @State var errorMessage: String = ""
    
    // 결제화면 상태
    @State private var showPaymentView: Bool = false
    
    @State var paymentInfo: PaymentInfo = DefaultPaymentInfo(
        amount: 1000,
        orderId: "9lD0azJWxjBY0KOIumGzH",
        orderName: "토스 티셔츠 외 2건",
        customerName: "박토스"
    )

    
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
                        
                        Text("주문 상품")
                    })
                    
                    TextField("주소를 입력하세요", text: $deliveryAddress)
                    TextField("전화번호를 입력하세요", text: $contactNumber)
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
                        Text("₩488,000")
                    }
                    .padding(.vertical, 4)
                    
                    HStack {
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
                        Text("₩488,000")
                            .fontWeight(.bold)
                            .foregroundStyle(.blue)
                    }
                    .padding(.vertical, 12)
                    
                    VStack {
                        Button(action: {
                            if deliveryAddress.isEmpty || contactNumber.isEmpty {
                                errorMessage = "주소나 연락처를 입력해주세요."
                                errorAlert = true
                            } else {
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
                                clientKey: Constants.clientKey,
                                paymentMethod: .CARD,
                                paymentInfo: paymentInfo,
                                isPresented: $showPaymentView)
                            .onSuccess { key, id, amount in
//                                print(key,id,amount)
                                navigationPath.append("SuccessView")
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
    }
}

#Preview {
//    PaymentsView()
}
