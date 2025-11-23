//
//  JustOneService.swift
//  LeafMAP
//
//  Created by 오현민 on 11/23/25.
//

import Foundation
import Moya

final class JustOneService: NetworkManager {
    
    let provider: MoyaProvider<JustOneEndpoints>
    
    init(provider: MoyaProvider<JustOneEndpoints>? = nil) {
        let plugins: [PluginType] = [
            // NetworkLoggerPlugin(configuration: .init(logOptions: [.requestHeaders, .verbose]))
            AuthPlugin.shared
        ]
        
        self.provider = provider ?? MoyaProvider<JustOneEndpoints>(plugins: plugins)
    }
    
    // 챗봇 게시글 검색
    func chat(data: JustOneChatRequestDTO, completion: @escaping (Result<JustOneChatResponseDTO, NetworkError>) -> Void) {
        request(
            target: .postChat(data: data),
            decodingType: JustOneChatResponseDTO.self,
            completion: completion
        )
    }
    
    // 전공 적성 검사 문항 조회
    func getQuestions(completion: @escaping (Result<JustOneAptitudeQuestionsResponseDTO, NetworkError>) -> Void) {
        request(
            target: .getQuestions,
            decodingType: JustOneAptitudeQuestionsResponseDTO.self,
            completion: completion
        )
    }
    
    // 전공 적성 검사 결과 전송
    func submitAnswer(data: JustOneAptitudeRequestDTO, completion: @escaping (Result<JustOneAptitudeResponseDTO, NetworkError>) -> Void) {
        request(
            target: .submitAnswer(data: data),
            decodingType: JustOneAptitudeResponseDTO.self,
            completion: completion
        )
    }
    
    // 회원가입
    func postSignup(data: JustOneSignupRequestDTO, completion: @escaping (Result<JustOneSignupResponse, NetworkError>) -> Void) {
        request(
            target: .postSignUp(data: data),
            decodingType: JustOneSignupResponse.self,
            completion: completion
        )
    }
    
    // 로그인
    func postLogin(
        data: JustOneLoginRequestDTO,
        completion: @escaping (Result<JustOneLoginResponse, NetworkError>) -> Void
    ) {
        provider.request(.postLogin(data: data)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    // ⭐ BaseResponse 안 씀
                    let loginResponse = try decoder.decode(JustOneLoginResponse.self, from: response.data)
                    completion(.success(loginResponse))
                    
                } catch {
                    print("Login 디코딩 에러: \(error)")
                    completion(.failure(.decodingError))
                }
                
            case .failure(let error):
                completion(.failure(.networkError(message: error.localizedDescription)))
            }
        }
    }

}

