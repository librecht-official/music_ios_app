//
//  Albums.swift
//  Music2
//
//  Created by Vladislav Librecht on 09.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import Moya
import RxSwift

// MARK: - Albums API

struct AlbumsAPIRequest: URLParametersConvertible {
    let offset: Int
}

typealias AlbumsAPIResponse = [Album]

enum AlbumsAPITarget {
    case getAlbums(AlbumsAPIRequest)
}

extension AlbumsAPITarget: TargetType {
    var baseURL: URL {
        return Configuration.default.baseURL
    }
    
    var path: String {
        switch self {
        case .getAlbums:
            return "/music_albums/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAlbums:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .getAlbums(request):
            return Task.requestParameters(parameters: request.parameters, encoding: URLEncoding())
        }
    }
    
    var headers: [String : String]? {
        return Configuration.default.headers
    }
    
    var sampleData: Data {
        return Data()
    }
}

// MARK: - Services
 
private let albumsAPIProvider = MoyaProvider<AlbumsAPITarget>(plugins: [Logger()])

enum AlbumsNetworking {
    static func getAlbums(_ request: AlbumsAPIRequest) -> Single<AlbumsAPIResponse> {
        return self.request(.getAlbums(request))
    }
    
    static func request<Response: Decodable>(_ target: AlbumsAPITarget) -> Single<Response> {
        return albumsAPIProvider.rx.request(target)
            .delay(1, scheduler: MainScheduler.instance)
            .filterSuccessfulStatusCodes()
            .map { try parse(moyaResponse: $0) }
    }
}
