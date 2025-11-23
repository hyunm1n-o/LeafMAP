//
//  MemberResponse.swift
//  LeafMAP
//
//  Created by 오현민 on 11/22/25.
//

import Foundation

struct MemberPatchResponseDTO: Codable {
    let memberId: Int
    let nickname, major, desiredMajor: String
}

struct MemberGetResponseDTO: Codable {
    let memberId: Int
    let nickname, major, desiredMajor: String
}

struct MemberGetMyPostsDto: Codable {
    let posts: [Post]
    let nextCursor: Int
    let hasNext: Bool
}

struct Post: Codable {
    let postID: Int
    let boardType, title, contentPreview, address: String
    let imageURL: String
    let badge: Bool
    let likeCount: Int
    let createdAt: String
}
