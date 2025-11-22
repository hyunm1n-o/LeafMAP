//
//  BaseResponse.swift
//  LeafMAP
//
//  Created by 오현민 on 11/23/25.
//

import Foundation

// 공통 응답 구조
struct BaseResponse<T: Decodable>: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: T
}

