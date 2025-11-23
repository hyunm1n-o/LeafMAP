//
//  PostRequest.swift
//  LeafMAP
//
//  Created by 오현민 on 11/23/25.
//

import Foundation

struct PostCreateRequestDTO: Codable {
    let title: String
    let content: String
    let address: String
}

struct PostUpdateRequestDTO: Codable {
    let title: String
    let content: String
    let address: String
}

struct PostCommentRequestDTO: Codable {
    let content: String
    let parentId: Int
}
