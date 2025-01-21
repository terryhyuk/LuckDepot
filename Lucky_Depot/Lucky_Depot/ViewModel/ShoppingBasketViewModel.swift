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
    
    init() {
        // Realm 인스턴스 초기화
        realm = try! Realm()
        products = realm.objects(RealMProduct.self)
    }
    
    func fetchProduct() {
        products = realm.objects(RealMProduct.self)
    }
    
    // 상품 추가 함수
    func addProduct(product: Product) {
        let newProduct = RealMProduct()
        newProduct.id = product.code
        newProduct.name = product.name
        newProduct.price = product.price
        newProduct.imagePath = product.imagePath
        newProduct.quantity = product.quantity
        
        try! realm.write {
            realm.add(newProduct)
        }
    }
    
    // 상품 삭제 함수
    func deleteProduct(at offsets: IndexSet) {
        offsets.forEach { index in
            let productDelete = products[index]
            try! realm.write {
                realm.delete(productDelete)
            }
        }
    }
    
    // 상품 전체 삭제
    func deleteAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }
}
