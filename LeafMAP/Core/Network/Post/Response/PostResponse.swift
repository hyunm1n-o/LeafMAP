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

// 백엔드 응답에 맞춘 PostPreviewDTO
struct PostPreviewDTO: Codable {
    let postId: Int
    private let _title: String?
    private let _contentPreview: String?
    private let _badge: Bool?
    let isPublic: Bool?
    private let _majorId: Int?
    private let _majorName: String?
    let boardType: String?
    private let _authorInfo: String?
    
    var title: String { _title ?? "" }
    var contentPreview: String { _contentPreview ?? "" }
    var badge: Bool { _badge ?? false } 
    var majorId: Int { _majorId ?? 0 }
    var majorName: String { _majorName ?? "" }
    var authorInfo: String { _authorInfo ?? "" }
    
    enum CodingKeys: String, CodingKey {
        case postId, isPublic, boardType
        case _title = "title"
        case _contentPreview = "contentPreview"
        case _badge = "badge"
        case _majorId = "majorId"
        case _majorName = "majorName"
        case _authorInfo = "authorInfo"
    }
}

struct PostListResponseDTO: Codable {
    let posts: [PostPreviewDTO]
    private let _nextCursor: Int?
    private let _hasNext: Bool?
    
    var nextCursor: Int { _nextCursor ?? 0 }
    var hasNext: Bool { _hasNext ?? false }
    
    enum CodingKeys: String, CodingKey {
        case posts
        case _nextCursor = "nextCursor"
        case _hasNext = "hasNext"
    }
}

struct PostDetailResponseDTO: Codable {
    let postId: Int
    let boardType: String?
    private let _title: String?
    private let _content: String?
    let address: String?
    let imageUrl: String?
    let isPublic: Bool?
    private let _likeCount: Int?
    private let _badge: Bool?
    private let _isWriter: Bool?
    private let _isLiked: Bool?
    private let _authorInfo: String?
    let member: PostMemberDTO?
    let major: PostMajorDTO?
    let comments: [PostCommentDTO]
    
    var title: String { _title ?? "" }
    var content: String { _content ?? "" }
    var likeCount: Int { _likeCount ?? 0 }
    var badge: Bool { _badge ?? false }
    var isWriter: Bool { _isWriter ?? false }
    var isLiked: Bool { _isLiked ?? false }
    var authorInfo: String { _authorInfo ?? "" }
    
    enum CodingKeys: String, CodingKey {
        case postId, boardType, address, imageUrl, isPublic, member, major, comments
        case _title = "title"
        case _content = "content"
        case _likeCount = "likeCount"
        case _badge = "badge"
        case _isWriter = "isWriter"
        case _isLiked = "isLiked"
        case _authorInfo = "authorInfo"
    }
}

struct PostMemberDTO: Codable {
    let memberId: Int?
    private let _nickname: String?
    let profileImageUrl: String?
    
    var nickname: String { _nickname ?? "" }
    
    enum CodingKeys: String, CodingKey {
        case memberId, profileImageUrl
        case _nickname = "nickname"
    }
}

struct PostMajorDTO: Codable {
    let majorId: Int?
    private let _majorName: String?
    
    var majorName: String { _majorName ?? "" }
    
    enum CodingKeys: String, CodingKey {
        case majorId
        case _majorName = "majorName"
    }
}

struct PostCommentDTO: Codable {
    private let _commentId: Int?
    private let _content: String?
    private let _authorInfo: String?
    private let _isWriter: Bool?
    let createdAt: String?
    
    var commentId: Int { _commentId ?? 0 }
    var content: String { _content ?? "" }
    var authorInfo: String { _authorInfo ?? "" }
    var isWriter: Bool { _isWriter ?? false }
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case _commentId = "commentId"
        case _content = "content"
        case _authorInfo = "authorInfo"
        case _isWriter = "isWriter"
    }
}

// 맛집 게시판 홈 화면 조회
struct RestaurantPostListResponseDTO: Codable {
    let posts: [RestaurantPostPreviewDTO]
}

struct RestaurantPostPreviewDTO: Codable {
    let postId: Int
    let imageUrl: String?
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
