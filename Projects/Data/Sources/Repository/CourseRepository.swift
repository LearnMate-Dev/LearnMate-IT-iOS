//
//  CourseRepository.swift
//  Data
//
//  Created by 박지윤 on 7/8/25.
//

import Domain
import RxSwift
import Alamofire

public class DefaultCourseRepository: CourseRepository {
    public init() {}

    public func getCourses() -> Single<CourseVO> {
        return request(
            endpoint: NetworkConfiguration.baseUrl,
            id: 4,
            responseType: CourseDTO.self
        )
        .map { dto in
            return CourseVO(
                courseLv: 1,
                courseDescription: "courseDescription",
                stepLv: 1,
                stepTitle: "stepTitle",
                stepDescription: "stepDescription",
                stepStatus: "SOLVED"
            )
        }
    }

    private func request<T: Decodable>(endpoint: String, id: Int, responseType: T.Type) -> Single<T> {
            return Single.create { single in
                let url = "\(NetworkConfiguration.baseUrl)\(endpoint)"
                let parameters: Parameters = [
                    "id": id
                ]

                let request = AF.request(url,
                                         method: .get,
                                         parameters: parameters,
                                         encoding: URLEncoding.queryString)
                    .validate()
                    .responseDecodable(of: responseType) { response in
                        switch response.result {
                        case .success(let value):
                            single(.success(value))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    }

                return Disposables.create { request.cancel() }
            }
        }
    }
