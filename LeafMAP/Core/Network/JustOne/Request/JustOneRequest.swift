//
//  JustOneRequest.swift
//  LeafMAP
//
//  Created by 오현민 on 11/23/25.
//

import Foundation

struct JustOneChatRequestDTO: Codable {
    let message: String
}

struct JustOneAptitudeRequestDTO: Codable {
    let answers: [JustOneAnswerDTO]
}

struct JustOneAnswerDTO: Codable {
    let questionId: Int
    let score: Int
}

struct JustOneSignupRequestDTO: Codable {
    let loginId: String
    let password: String
    let nickname: String
    let studentId: String
    let major: String
    let desiredMajor: String
}

struct JustOneLoginRequestDTO: Codable {
    let loginId: String
    let password: String
}
