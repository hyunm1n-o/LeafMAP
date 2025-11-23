//
//  NetworkManager+Extension.swift
//  LeafMAP
//
//  Created by 오현민 on 11/22/25.
//

import Foundation
import Moya

extension NetworkManager {
    // ✅ 1. 일반 데이터 요청 (T, 필수값) - 공통 응답 래퍼 처리
    func request<T: Decodable>(
        target: Endpoint,
        decodingType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase

                    // 공통 응답 구조로 먼저 디코딩
                    let baseResponse = try decoder.decode(BaseResponse<T>.self, from: response.data)

                    // isSuccess 확인
                    guard baseResponse.isSuccess else {
                        completion(.failure(.serverError(statusCode: response.statusCode, message: baseResponse.message)))
                        return
                    }

                    // result 확인 및 반환
                    guard let result = baseResponse.result else {
                        completion(.failure(.decodingError))
                        return
                    }

                    completion(.success(result))
                } catch {
                    print("디코딩 에러: \(error)")
                    completion(.failure(.decodingError))
                }
            case .failure(let error):
                if let response = error.response {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
                        completion(.failure(.serverError(statusCode: response.statusCode, message: errorResponse.message)))
                    } catch {
                        completion(.failure(.serverError(statusCode: response.statusCode, message: "서버 오류가 발생했습니다.")))
                    }
                } else {
                    completion(.failure(.networkError(message: error.localizedDescription)))
                }
            }
        }
    }
    
    // ✅ 2. 일반 데이터 요청 (T?, 옵셔널) - 공통 응답 래퍼 처리
    func requestOptional<T: Decodable>(
        target: Endpoint,
        decodingType: T.Type,
        completion: @escaping (Result<T?, NetworkError>) -> Void
    ) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                // 빈 응답인 경우 nil 반환
                guard !response.data.isEmpty else {
                    completion(.success(nil))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase

                    // 공통 응답 구조로 먼저 디코딩
                    let baseResponse = try decoder.decode(BaseResponse<T>.self, from: response.data)

                    // isSuccess 확인
                    guard baseResponse.isSuccess else {
                        completion(.failure(.serverError(statusCode: response.statusCode, message: baseResponse.message)))
                        return
                    }

                    // result 반환 (옵셔널 함수이므로 nil 허용)
                    completion(.success(baseResponse.result))
                } catch {
                    print("디코딩 에러: \(error)")
                    completion(.failure(.decodingError))
                }
            case .failure(let error):
                if let response = error.response {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
                        completion(.failure(.serverError(statusCode: response.statusCode, message: errorResponse.message)))
                    } catch {
                        completion(.failure(.serverError(statusCode: response.statusCode, message: "서버 오류가 발생했습니다.")))
                    }
                } else {
                    completion(.failure(.networkError(message: error.localizedDescription)))
                }
            }
        }
    }
    
    // ✅ 3. 상태 코드만 확인
    func requestStatusCode(
        target: Endpoint,
        completion: @escaping (Result<Void, NetworkError>) -> Void
    ) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    completion(.success(()))
                } else {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
                        completion(.failure(.serverError(statusCode: response.statusCode, message: errorResponse.message)))
                    } catch {
                        completion(.failure(.serverError(statusCode: response.statusCode, message: "서버 오류가 발생했습니다.")))
                    }
                }
            case .failure(let error):
                if let response = error.response {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
                        completion(.failure(.serverError(statusCode: response.statusCode, message: errorResponse.message)))
                    } catch {
                        completion(.failure(.serverError(statusCode: response.statusCode, message: "서버 오류가 발생했습니다.")))
                    }
                } else {
                    completion(.failure(.networkError(message: error.localizedDescription)))
                }
            }
        }
    }
    
    // ✅ 캐시 유효 시간 포함 - 공통 응답 래퍼 처리
    func requestWithTime<T: Decodable>(
        target: Endpoint,
        decodingType: T.Type,
        completion: @escaping (Result<(T, TimeInterval?), NetworkError>) -> Void
    ) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase

                    // 공통 응답 구조로 먼저 디코딩
                    let baseResponse = try decoder.decode(BaseResponse<T>.self, from: response.data)

                    // isSuccess 확인
                    guard baseResponse.isSuccess else {
                        completion(.failure(.serverError(statusCode: response.statusCode, message: baseResponse.message)))
                        return
                    }

                    // result 확인
                    guard let result = baseResponse.result else {
                        completion(.failure(.decodingError))
                        return
                    }

                    // Cache-Control 헤더에서 max-age 추출
                    var cacheTime: TimeInterval? = nil
                    if let cacheControl = response.response?.allHeaderFields["Cache-Control"] as? String {
                        let components = cacheControl.components(separatedBy: ",")
                        for component in components {
                            let trimmed = component.trimmingCharacters(in: .whitespaces)
                            if trimmed.hasPrefix("max-age=") {
                                let maxAgeString = String(trimmed.dropFirst(8))
                                if let maxAge = TimeInterval(maxAgeString) {
                                    cacheTime = maxAge
                                }
                            }
                        }
                    }

                    // result와 cacheTime 반환
                    completion(.success((result, cacheTime)))
                } catch {
                    print("디코딩 에러: \(error)")
                    completion(.failure(.decodingError))
                }
            case .failure(let error):
                if let response = error.response {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
                        completion(.failure(.serverError(statusCode: response.statusCode, message: errorResponse.message)))
                    } catch {
                        completion(.failure(.serverError(statusCode: response.statusCode, message: "서버 오류가 발생했습니다.")))
                    }
                } else {
                    completion(.failure(.networkError(message: error.localizedDescription)))
                }
            }
        }
    }
}
