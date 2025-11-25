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

struct MemberGetMyPostsDTO: Codable {
    private let _posts: [MemberPostDTO]?
    private let _nextCursor: Int?
    private let _hasNext: Bool?
    
    var posts: [MemberPostDTO] { _posts ?? [] }
    var nextCursor: Int { _nextCursor ?? 0 }
    var hasNext: Bool { _hasNext ?? false }
    
    enum CodingKeys: String, CodingKey {
        case _posts = "posts"
        case _nextCursor = "nextCursor"
        case _hasNext = "hasNext"
    }
}

struct MemberPostDTO: Codable {
    private let _postId: Int?
    private let _boardType: String?
    private let _title: String?
    private let _contentPreview: String?
    private let _badge: Bool?
    private let _isPublic: Bool?
    private let _majorId: Int?
    private let _majorName: String?
    private let _authorInfo: String?
    private let _createdAt: String?
    
    var postId: Int { _postId ?? 0 }
    var boardType: String { _boardType ?? "" }
    var title: String { _title ?? "" }
    var contentPreview: String { _contentPreview ?? "" }
    var badge: Bool { _badge ?? false }
    var isPublic: Bool { _isPublic ?? false }
    var majorId: Int? { _majorId }
    var majorName: String { _majorName ?? "" }
    var authorInfo: String { _authorInfo ?? "" }
    var createdAt: String { _createdAt ?? "" }
    
    enum CodingKeys: String, CodingKey {
        case _postId = "postId"
        case _boardType = "boardType"
        case _title = "title"
        case _contentPreview = "contentPreview"
        case _badge = "badge"
        case _isPublic = "isPublic"
        case _majorId = "majorId"
        case _majorName = "majorName"
        case _authorInfo = "authorInfo"
        case _createdAt = "createdAt" 
    }
}
