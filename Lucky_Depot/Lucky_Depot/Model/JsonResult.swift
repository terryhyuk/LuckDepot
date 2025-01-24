//
//  JsonResult.swift
//  Lucky_Depot
//
//  Created by 노민철 on 1/24/25.
//

import Foundation

struct JsonResult<T:Decodable>: Decodable{
    let result: T
}
