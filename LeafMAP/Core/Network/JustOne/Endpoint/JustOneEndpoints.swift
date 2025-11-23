//
//  JustOneEndpoints.swift
//  LeafMAP
//
//  Created by 오현민 on 11/23/25.
//

import Foundation
import Moya

enum JustOneEndpoints {
    // Post
    case postChat(data: JustOneChatRequestDTO)
    
    // Get
    case getQuestions
    
    // Post
    case submitAnswer(data: JustOneAptitudeRequestDTO)
    case postSignUp(data: JustOneSignupRequestDTO)
    case postLogin(data: JustOneLoginRequestDTO)
}

extension JustOneEndpoints: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.API.baseURL) else {
            fatalError("잘못된 URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .postChat:
            return "/chatbot"
        case .getQuestions, .submitAnswer:
            return "/aptitude-test"
        case .postSignUp:
            return "/signup"
        case .postLogin:
            return "/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postChat, .submitAnswer, .postLogin, .postSignUp:
            return .post
        case .getQuestions:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .postChat(let data):
            return .requestJSONEncodable(data)
        case .getQuestions:
            return .requestPlain
        case .submitAnswer(let data):
            return .requestJSONEncodable(data)
        case .postSignUp(let data):
            return .requestJSONEncodable(data)
        case .postLogin(let data):
            return .requestJSONEncodable(data)
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-type": "application/json",
            "accept": "*/*"
        ]
    }
}

