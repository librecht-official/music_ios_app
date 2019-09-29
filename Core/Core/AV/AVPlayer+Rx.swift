//
//  Music
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import AVFoundation
import RxSwift
import RxCocoa


public enum PlayingFinishResult {
    case nextItemAvaliable
    case stop
}

public extension Reactive where Base: AVPlayer {
    var status: Driver<AVPlayer.Status> {
        return observe(AVPlayer.Status.self, #keyPath(AVPlayer.status))
            .map { $0 ?? .unknown }
            .asDriver(onErrorDriveWith: .never())
    }
    
    var rate: Driver<Float> {
        return observe(Float.self, #keyPath(AVPlayer.rate))
            .map { $0 ?? 0.0 }
            .asDriver(onErrorDriveWith: .never())
    }
    
    var isPlaying: Driver<Bool> {
        return rate.map { $0 != 0.0 }
    }
    
    func playbackTime(_ period: TimeInterval) -> Driver<TimeInterval> {
        let observale = Observable<TimeInterval>.create { observer -> Disposable in
            let time = CMTime(seconds: period, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            let t = self.base.addPeriodicTimeObserver(forInterval: time, queue: .main, using: { time in
                observer.onNext(time.seconds)
            })
            return Disposables.create {
                self.base.removeTimeObserver(t)
            }
        }
        return observale.asDriver(onErrorDriveWith: .never())
    }
    
    var currentItem: Driver<AVPlayerItem?> {
        return observe(AVPlayerItem.self, #keyPath(AVPlayer.currentItem))
            .asDriver(onErrorDriveWith: .never())
    }
    
    var currentItemDidPlayToEnd: Signal<PlayingFinishResult> {
        return currentItem.flatMap { item -> Signal<PlayingFinishResult> in
            if let item = item {
                return item.rx.didPlayToEnd.map { _ in .nextItemAvaliable }
            }
            else {
                return .just(.stop)
            }
        }
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
        @unknown default:
            return "@unknown default"
        }
    }
}
