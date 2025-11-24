//
//  JustOneResponse.swift
//  LeafMAP
//
//  Created by 오현민 on 11/23/25.
//

import Foundation

struct JustOneChatResponseDTO: Codable {
    private let _message: String?
    private let _posts: [JustOneChatPostPreviewDTO]?
    
    var message: String { _message ?? "" }
    var posts: [JustOneChatPostPreviewDTO] { _posts ?? [] }
    
    enum CodingKeys: String, CodingKey {
        case _message = "message"
        case _posts = "posts"
    }
}

struct JustOneChatPostPreviewDTO: Codable {
    private let _postId: Int?
    private let _boardType: String?
    private let _title: String?
    private let _contentPreview: String?
    private let _address: String?
    private let _imageUrl: String?
    private let _badge: Bool?
    private let _likeCount: Int?
    private let _createdAt: String?
    
    var postId: Int { _postId ?? 0 }
    var boardType: String { _boardType ?? "" }
    var title: String { _title ?? "" }
    var contentPreview: String { _contentPreview ?? "" }
    var address: String { _address ?? "" }
    var imageUrl: String { _imageUrl ?? "" }
    var badge: Bool { _badge ?? false }
    var likeCount: Int { _likeCount ?? 0 }
    var createdAt: String { _createdAt ?? "" }
    
    enum CodingKeys: String, CodingKey {
        case _postId = "postId"
        case _boardType = "boardType"
        case _title = "title"
        case _contentPreview = "contentPreview"
        case _address = "address"
        case _imageUrl = "imageUrl"
        case _badge = "badge"
        case _likeCount = "likeCount"
        case _createdAt = "createdAt"
    }
}

struct JustOneAptitudeQuestionsResponseDTO: Codable {
    let questions: [JustOneQuestionDTO]
}

struct JustOneQuestionDTO: Codable {
    let questionId: Int
    let content: String
}

struct JustOneAptitudeResponseDTO: Codable {
    let majorScores: [String: Double]
}

struct JustOneSignupResponse: Codable { }

struct JustOneLoginResponse: Codable {
    let memberId: Int
    let accessToken: String
}
