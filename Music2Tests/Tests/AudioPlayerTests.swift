//
//  AudioPlayerTests.swift
//  Music2Tests
//
//  Created by Vladislav Librecht on 03.03.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import XCTest
@testable import Music2

//class AudioPlayerTests: XCTestCase {
//    typealias AudioPlayer = Functional.AudioPlayer
//
//    func testPlayerBaseUseCase() {
//        let playlist = [
//            MusicTrack(
//                id: 1,
//                title: "1",
//                durationSec: 123,
//                albumsIds: [1],
//                audioURL: URL(string: "file://test_1.mp3")
//            ),
//            MusicTrack(
//                id: 2,
//                title: "2",
//                durationSec: 123,
//                albumsIds: [1],
//                audioURL: nil // Not playable
//            ),
//            MusicTrack(
//                id: 3,
//                title: "3",
//                durationSec: 123,
//                albumsIds: [1],
//                audioURL: URL(string: "file://test_3.mp3")
//            ),
//            MusicTrack(
//                id: 4,
//                title: "4",
//                durationSec: 123,
//                albumsIds: [1],
//                audioURL: URL(string: "file://test_4.mp3")
//            ),
//        ]
//        // When in initial state: empty playlist, not playing, not any actions
//        let s0 = AudioPlayer.initialState
//        XCTAssert(s0.playlist.isEmpty)
//        XCTAssert(s0.currentTrack == nil)
//        XCTAssert(s0.playback != .playing)
//        XCTAssert(s0.nextAction == nil)
//
//        // When setting playlist: it should set playlist, and not perform any actions
//        let s1 = AudioPlayer.reduce(state: s0, command: .setPlaylist(playlist))
//        XCTAssert(s1.playlist == playlist)
//        XCTAssert(s1.playback != .playing)
//        XCTAssert(s1.nextAction == nil)
//
//        // When play track #1:
//        //  - playlist the same,
//        //  - current track should be the next track that can be played (i.e. has url)
//        //  - playback set to "playing"
//        //  - perform action to play new item
//        let s2 = AudioPlayer.reduce(state: s1, command: .playTrackAtIndex(1))
//        XCTAssert(s2.playlist == playlist)
//        XCTAssert(s2.currentTrackIndex == 2)
//        XCTAssert(s2.playback == .playing)
//        XCTAssert(s2.nextAction == .some(.playNewItem(playlist[2])))
//
//        // When pause:
//        //  - playlist the same
//        //  - current track the same
//        //  - playback set to "paused"
//        //  - perfrom action to pause current item
//        let s3 = AudioPlayer.reduce(state: s2, command: .pause)
//        XCTAssert(s3.playlist == playlist)
//        XCTAssert(s3.currentTrackIndex == s2.currentTrackIndex)
//        XCTAssert(s3.playback == .paused)
//        XCTAssert(s3.nextAction == .some(.pauseCurrentItem))
//
//        // When resume:
//        //  - playlist the same
//        //  - current track the same
//        //  - playback set to "playing"
//        //  - perfrom action to play current item
//        let s4 = AudioPlayer.reduce(state: s3, command: .resume)
//        XCTAssert(s4.playlist == playlist)
//        XCTAssert(s4.currentTrackIndex == s3.currentTrackIndex)
//        XCTAssert(s4.playback == .playing)
//        XCTAssert(s4.nextAction == .some(.playCurrentItem))
//
//        // When currentItemFinished and next playable track exists:
//        let s5 = AudioPlayer.reduce(state: s4, command: .playingItemFinished)
//        XCTAssert(s5.playlist == playlist, "playlist the same")
//        XCTAssert(s5.currentTrackIndex == 3, "current track should be set to next playable track")
//        XCTAssert(s5.playback == s4.playback, "playback the same")
//        XCTAssert(s5.nextAction == nil, "no next action")
//
//        // When currentItemFinished and next playable track doesn't exists:
//        let s6 = AudioPlayer.reduce(state: s5, command: .playingItemFinished)
//        XCTAssert(s6.playlist == playlist, "playlist the same")
//        XCTAssert(s6.currentTrackIndex == 3, "current track leaved the same")
//        XCTAssert(s6.playback == .stopped, "playback set to 'stoped'")
//        XCTAssert(s6.nextAction == nil, "no next action")
//    }
//}

class AudioPlayerTests2: XCTestCase {
    typealias AudioPlayer = Functional.AudioPlayer
    
    func testPlayerBaseUseCase() {
        let playlist = [
            MusicTrack(
                id: 1,
                title: "1",
                durationSec: 123,
                albumsIds: [1],
                audioURL: URL(string: "file://test_1.mp3")
            ),
            MusicTrack(
                id: 2,
                title: "2",
                durationSec: 123,
                albumsIds: [1],
                audioURL: nil // Not playable
            ),
            MusicTrack(
                id: 3,
                title: "3",
                durationSec: 123,
                albumsIds: [1],
                audioURL: URL(string: "file://test_3.mp3")
            ),
            MusicTrack(
                id: 4,
                title: "4",
                durationSec: 123,
                albumsIds: [1],
                audioURL: URL(string: "file://test_4.mp3")
            ),
        ]
        // When in initial state: empty playlist, not playing, not any actions
        TestScript(AudioPlayer.initialState, reduce: AudioPlayer.reduce) { (s0, _) in
            XCTAssert(s0.playlist.isEmpty)
            XCTAssert(s0.currentTrack == nil)
            XCTAssert(s0.playback != .playing)
            XCTAssert(s0.nextAction == nil)
        }
        // When setting playlist: it should set playlist, and not perform any actions
        .when(.setPlaylist(playlist)) { (s1, _) in
            XCTAssert(s1.playlist == playlist)
            XCTAssert(s1.playback != .playing)
            XCTAssert(s1.nextAction == nil)
        }
        // When play track #1:
        //  - playlist the same,
        //  - current track should be the next track that can be played (i.e. has url)
        //  - playback set to "playing"
        //  - perform action to play new item
        .when(.playTrackAtIndex(1)) { (s2, _) in
            XCTAssert(s2.playlist == playlist)
            XCTAssert(s2.currentTrackIndex == 2)
            XCTAssert(s2.playback == .playing)
            XCTAssert(s2.nextAction == .some(.playNewItem(playlist[2])))
        }
        // When pause:
        //  - playlist the same
        //  - current track the same
        //  - playback set to "paused"
        //  - perfrom action to pause current item
        .when(.pause) { (s3, s) in
            XCTAssert(s3.playlist == playlist)
            XCTAssert(s3.currentTrackIndex == s[2].currentTrackIndex)
            XCTAssert(s3.playback == .paused)
            XCTAssert(s3.nextAction == .some(.pauseCurrentItem))
        }
        // When resume:
        //  - playlist the same
        //  - current track the same
        //  - playback set to "playing"
        //  - perfrom action to play current item
        .when(.resume) { (s4, s) in
            XCTAssert(s4.playlist == playlist)
            XCTAssert(s4.currentTrackIndex == s[3].currentTrackIndex)
            XCTAssert(s4.playback == .playing)
            XCTAssert(s4.nextAction == .some(.playCurrentItem))
        }
        // When currentItemFinished and next playable track exists:
        .when(.playingItemFinished) { (s5, s) in
            XCTAssert(s5.playlist == playlist, "playlist the same")
            XCTAssert(s5.currentTrackIndex == 3, "current track should be set to next playable track")
            XCTAssert(s5.playback == s[4].playback, "playback the same")
            XCTAssert(s5.nextAction == nil, "no next action")
        }
        // When currentItemFinished and next playable track doesn't exists:
        .when(.playingItemFinished) { (s6, _) in
            XCTAssert(s6.playlist == playlist, "playlist the same")
            XCTAssert(s6.currentTrackIndex == 3, "current track leaved the same")
            XCTAssert(s6.playback == .stopped, "playback set to 'stoped'")
            XCTAssert(s6.nextAction == nil, "no next action")
        }
    }
}
