//
//  AVPlayer+Rx.swift
//  Music2
//
//  Created by Vladislav Librecht on 24.02.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import AVFoundation
import RxSwift

extension Reactive where Base: AVPlayer {
    var status: Observable<AVPlayer.Status> {
        return observe(AVPlayer.Status.self, #keyPath(AVPlayer.status))
            .map { $0 ?? .unknown }
    }
    
    var rate: Observable<Float> {
        return observe(Float.self, #keyPath(AVPlayer.rate))
            .map { $0 ?? 0.0 }
    }
    
    var isPlaying: Observable<Bool> {
        return rate.map { $0 != 0.0 }
    }
    
    func playbackTime(_ period: TimeInterval) -> Observable<TimeInterval> {
        return Observable.create { observer -> Disposable in
            let time = CMTime(seconds: period, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            let t = self.base.addPeriodicTimeObserver(forInterval: time, queue: .main, using: { time in
                observer.onNext(time.seconds)
            })
            return Disposables.create {
                self.base.removeTimeObserver(t)
            }
        }
    }
    
    var currentItem: Observable<AVPlayerItem?> {
        return observe(AVPlayerItem.self, #keyPath(AVPlayer.currentItem))
    }
}

extension AVPlayer.Status: CustomStringConvertible {
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