//
//  JustOneResponse.swift
//  LeafMAP
//
//  Created by 오현민 on 11/23/25.
//

import Foundation

struct JustOneChatResponseDTO: Codable {
    let message: String
    let posts: [JustOneChatPostPreviewDTO]
}

struct JustOneChatPostPreviewDTO: Codable {
    let postId: Int
    let boardType: String
    let title: String
    let contentPreview: String
    let address: String
    let imageUrl: String
    let badge: Bool
    let likeCount: Int
    let createdAt: String
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
