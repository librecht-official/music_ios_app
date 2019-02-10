//
//  Logger.swift
//  Music2
//
//  Created by Vladislav Librecht on 09.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import Moya
import Result

struct Logger: PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        guard let method = request.request?.httpMethod,
            let url = request.request?.url?.absoluteString else {
                print("🌐--> \(String(describing: request.request))")
                return
        }
        print("🌐 <-- \(method) \(url)\n\(request.request?.httpBody.flatMap(String.init) ?? "")")
    }
    
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        print("🌐 --> \(result) (\(target.method) \(target.path))")
        if case Result<Moya.Response, MoyaError>.failure(let error) = result {
            print(error)
        }
    }
}
