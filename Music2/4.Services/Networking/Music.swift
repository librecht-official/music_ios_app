//
//  Music.swift
//  Music2
//
//  Created by Vladislav Librecht on 09.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import Moya
import RxSwift

// MARK: - Music API

typealias MusicAPIResponse = [Album]

public enum MusicAPIRoute {
    case explore
}

struct MusicAPITarget: TargetType {    
    let config: APIConfiguration
    let route: MusicAPIRoute
    
    var baseURL: URL {
        return config.baseURL
    }
    
    var path: String {
        switch self.route {
        case .explore:
            return "/explore"
        }
    }
    
    var method: Moya.Method {
        switch self.route {
        case .explore:
            return .get
        }
    }
    
    var task: Task {
        switch self.route {
        case .explore:
            return Task.requestPlain
        }
    }
    
    var headers: [String : String]? {
        return config.headers
    }
    
    var sampleData: Data {
        return Data()
    }
}

// MARK: - Services

public protocol MusicAPI {
    func explore() -> Single<ExploreResponse>
//    func request<Response: Decodable>(_ route: MusicAPIRoute) -> Single<Response>
}

public struct MusicAPINetworkingClient: MusicAPI {
    private let config: APIConfiguration
    private let parser: Parser
    private let provider: MoyaProvider<MusicAPITarget>
    
    public init(config: APIConfiguration) {
        self.config = config
        self.parser = Parser(decoder: config.decoder)
        self.provider = MoyaProvider<MusicAPITarget>(
            plugins: [
                Logger(log: config.logger)
            ]
        )
    }
    
    public func explore() -> Single<ExploreResponse> {
        return request(.explore)
    }
    
    func request<Response: Decodable>(_ route: MusicAPIRoute) -> Single<Response> {
        let target = MusicAPITarget(config: config, route: route)
        let parser = self.parser
        return provider.rx.request(target)
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .filterSuccessfulStatusCodes()
            .map { try parser.parse(moyaResponse: $0) }
    }
}
