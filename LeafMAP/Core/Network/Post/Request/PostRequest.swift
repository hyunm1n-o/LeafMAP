//
//  PostRequest.swift
//  LeafMAP
//
//  Created by 오현민 on 11/23/25.
//

import Foundation

struct PostCreateRequestDTO: Encodable {
    let title: String
    let content: String
    let address: String?
}

struct PostUpdateRequestDTO: Encodable {
    let title: String
    let content: String
    let address: String?
}

struct PostCommentRequestDTO: Encodable {
    let content: String
    let parentId: Int?  
}
