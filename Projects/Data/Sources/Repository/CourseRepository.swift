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

    public func getCourses() -> Single<CourseAPI> {
        return Single.create { single in
            let parameters: Parameters = [
                "lat": NetworkConfiguration.defaultLat,
                "lon": NetworkConfiguration.defaultLng,
                "appid": NetworkConfiguration.appID
            ]
            
            let request = AF.request(
                "\(NetworkConfiguration.baseUrl)/courses",
                method: .get,
                parameters: parameters
            )
            .validate()
            .responseDecodable(of: CourseDTO.self) { response in
                switch response.result {
                case .success(let dto):
                    single(.success(dto))
                case .failure(let error):
                    single(.failure(error))
                }
            }

            return Disposables.create { request.cancel() }
        }
    }
}
