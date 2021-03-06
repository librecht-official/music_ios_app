//
//  AVPlayerItem+Rx.swift
//  Music2
//
//  Created by Vladislav Librecht on 24.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import AVFoundation
import RxSwift
import RxCocoa

extension Reactive where Base: AVPlayerItem {
    var status: Driver<AVPlayerItem.Status> {
        return observe(AVPlayerItem.Status.self, #keyPath(AVPlayerItem.status))
            .map { $0 ?? .unknown }
            .asDriver(onErrorDriveWith: .never())
    }
    
    var duration: Driver<TimeInterval> {
        return observe(CMTime.self, #keyPath(AVPlayerItem.duration))
            .map { time in
                time?.seconds ?? 0.0
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    var didPlayToEnd: Signal<Notification> {
        return NotificationCenter.default.rx
            .notification(.AVPlayerItemDidPlayToEndTime, object: base)
            .asSignal(onErrorSignalWith: .never())
    }
}

extension AVPlayerItem.Status: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unknown:
            return "unknown"
        case .readyToPlay:
            return "readyToPlay"
        case .failed:
            return "failed"
        }
    }
}
