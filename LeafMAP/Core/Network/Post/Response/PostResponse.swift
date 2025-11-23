//
//  PostResponse.swift
//  LeafMAP
//
//  Created by 오현민 on 11/23/25.
//

import Foundation

struct PostCreateResponseDTO: Codable {
    let postId: Int
}

struct PostPreviewDTO: Codable {
    let postId: Int
    let title: String
    let contentPreview: String
    let isPublic: Bool
    let majorId: Int
    let majorName: String
    let boardType: String
    let authorInfo: String
}

struct PostListResponseDTO: Codable {
    let posts: [PostPreviewDTO]
    let nextCursor: Int
    let hasNext: Bool
}

struct PostDetailResponseDTO: Codable {
    let postId: Int
    let boardType: String
    let title: String
    let content: String
    let address: String
    let imageUrl: String
    let isPublic: Bool
    let likeCount: Int
    let badge: Bool
    let isWriter: Bool
    let isLiked: Bool
    let authorInfo: String
    let member: PostMemberDTO?
    let major: PostMajorDTO?
    let comments: [PostCommentDTO]
}

struct PostMemberDTO: Codable {
    let memberId: Int
    let nickname: String
    let profileImageUrl: String
}

struct PostMajorDTO: Codable {
    let majorId: Int
    let majorName: String
}

struct PostCommentDTO: Codable {
    let commentId: Int
    let content: String
    let authorInfo: String
    let isWriter: Bool
    let createdAt: String
}

struct RestaurantPostPreviewDTO: Codable {
    let postId: Int
    let imageUrl: String
}

struct RestaurantPostListResponseDTO: Codable {
    let posts: [RestaurantPostPreviewDTO]
}

struct PostLikeResponseDTO: Codable {
    let postId: Int
    let likeCount: Int
    let isLiked: Bool
}

struct PostCommentResponseDTO: Codable {
    let commentId: Int
    let content: String
    let authorInfo: String
    let isWriter: Bool
    let createdAt: String
}
