//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import Moya

struct Logger: PluginType {
    let log: APIClientConfiguration.Logging?
    
    func willSend(_ request: RequestType, target: TargetType) {
        guard let method = request.request?.httpMethod,
            let url = request.request?.url?.absoluteString else {
                log?("🌐--> \(String(describing: request.request))")
                return
        }
        log?("🌐 <-- \(method) \(url)\n\(request.request?.httpBody.flatMap(String.init) ?? "")")
    }
    
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        log?("🌐 --> \(result) (\(target.method.rawValue) \(target.path))")
        if case Result<Moya.Response, MoyaError>.failure(let error) = result {
            log?(error)
        }
    }
}
