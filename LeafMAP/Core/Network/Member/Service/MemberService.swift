//
//  MemberService.swift
//  LeafMAP
//
//  Created by 오현민 on 11/22/25.
//

import Foundation
import Moya

final class MemberService: NetworkManager {
    
    let provider: MoyaProvider<MemberEndpoints>
    
    init(provider: MoyaProvider<MemberEndpoints>? = nil) {
        let plugins: [PluginType] = [
            // NetworkLoggerPlugin(configuration: .init(logOptions: [.requestHeaders, .verbose]))
            AuthPlugin.shared
        ]
        
        self.provider = provider ?? MoyaProvider<MemberEndpoints>(plugins: plugins)
    }
    
    // 회원정보 조회 API
    func getMember(completion: @escaping(Result<MemberGetResponseDTO, NetworkError>) -> Void) {
        request(
            target: .getMember,
            decodingType: MemberGetResponseDTO.self,
            completion: completion
        )
    }
    
    // 회원정보 수정 API
    func patchMember(data: MemberPatchRequestDTO, completion: @escaping(Result<MemberPatchResponseDTO, NetworkError>) -> Void) {
        request(
            target: .patchMember(data: data),
            decodingType: MemberPatchResponseDTO.self,
            completion: completion
        )
    }
    
    // 내가 작성한 게시글 조회
    func getMyPosts(cursor: Int, limit: Int, completion: @escaping(Result<MemberGetMyPostsDTO, NetworkError>) -> Void) {
        request(
            target: .getMyPosts(cursor: cursor, limit: limit),
            decodingType: MemberGetMyPostsDTO.self,
            completion: completion
        )
    }
    
    // 내가 댓글 단 게시글 조회
    func getMyComments(cursor: Int, limit: Int, completion: @escaping(Result<MemberGetMyPostsDTO, NetworkError>) -> Void) {
        request(
            target: .getMyComments(cursor: cursor, limit: limit),
            decodingType: MemberGetMyPostsDTO.self,
            completion: completion
        )
    }
    
    // 내가 추천한 게시글 조회
    func getLikedPosts(cursor: Int, limit: Int, completion: @escaping(Result<MemberGetMyPostsDTO, NetworkError>) -> Void) {
        request(
            target: .getLikedPosts(cursor: cursor, limit: limit),
            decodingType: MemberGetMyPostsDTO.self,
            completion: completion
        )
    }
}
