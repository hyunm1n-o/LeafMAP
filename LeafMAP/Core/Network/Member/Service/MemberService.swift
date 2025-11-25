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
}


