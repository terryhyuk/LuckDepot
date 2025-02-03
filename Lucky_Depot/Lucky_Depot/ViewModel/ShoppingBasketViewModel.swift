//
//  ShoppingBasketViewModel.swift
//  PayView
//
//  Created by 노민철 on 1/21/25.
//

import Foundation
import RealmSwift

class ShoppingBasketViewModel: ObservableObject {
    private var realm: Realm
    @Published var products: Results<RealMProduct>
    @Published var productCounts: Int = 0
    
    init() {
        // Realm 인스턴스 초기화
        realm = try! Realm()
        products = realm.objects(RealMProduct.self)
        productCountsUpdate()
    }
    
    func fetchProduct() {
        products = realm.objects(RealMProduct.self)
        productCountsUpdate()
    }
    
    // 상품 추가 함수
//    func addProduct(product: Product) {
//        let newProduct = RealMProduct()
//        newProduct.id = product.id
//        newProduct.name = product.name
//        newProduct.price = product.price
//        newProduct.imagePath = product.imagePath
//        newProduct.quantity = product.quantity
//        newProduct.category = product.category
//        
//        try! realm.write {
//            realm.add(newProduct)
//        }
//    }
    
    // 상품 갯수 업데이트
    func updateProductQuantity(_ product: RealMProduct, quantity: Int) {
        try! realm.write {
            product.quantity += quantity
        }
        fetchProduct()
    }
    
    // 상품 삭제 함수
    func deleteProduct(_ product: RealMProduct) {
        try! realm.write {
            realm.delete(product)
        }
        fetchProduct()
    }
    
    // 상품 전체 삭제
    func deleteAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    // 상품 종류 수 업데이트
    func productCountsUpdate(){
        productCounts = products.count
    }
    
    // 전체 금액 계산
    func totalPrice() -> Double {
        return products.reduce(0) { result, product in
            result + Double(product.price) * Double(product.quantity)
        }
    }
}
