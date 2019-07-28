//
//  AudioPlayerTests.swift
//  Music2Tests
//
//  Created by Vladislav Librecht on 03.03.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import XCTest
@testable import Music2

class AudioPlayerTests: XCTestCase {
    func testPlayerBaseUseCase() {
        // Given
        let tracks = [
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
        let album = Album(
            id: 0,
            title: "",
            artist: Artist(id: 0, name: ""),
            coverImageURL: nil,
            tracks: tracks
        )
        let playlist = AudioPlayerPlaylist.album(album, startFrom: 0)
        
        // When in initial state:
        TestScript(AudioPlayer.initialState, reduce: AudioPlayer.reduce) { (s0, _) in
            XCTAssertTrue(s0.playlist.tracks.isEmpty, "empty playlist")
            XCTAssertEqual(s0.currentTrack, nil, "no current track")
            XCTAssertNotEqual(s0.playback, .playing, "not playing")
            XCTAssertEqual(s0.nextAction, nil, "not perform any actions")
        }
        .when(.setPlaylist(playlist)) { (s1, _) in
            XCTAssertEqual(s1.playlist, playlist, "it should set playlist")
            XCTAssertNotEqual(s1.playback, .playing, "not playing")
            XCTAssertEqual(s1.nextAction, nil, "not perform any actions")
        }
        // When play track #1:
        .when(.playTrackAtIndex(1)) { (s2, _) in
            XCTAssertEqual(s2.playlist, playlist, "playlist the same")
            XCTAssertEqual(s2.currentTrackIndex, 2, "current track should be the next track that can be played (i.e. has url)")
            XCTAssertEqual(s2.playback, .playing, "playback set to \"playing\"")
            let track = PlayableMusicTrack(
                originalTrack: playlist.tracks[2],
                audioURL: playlist.tracks[2].audioURL!
            )
            XCTAssertEqual(s2.nextAction, .some(.playNewItem(track)), "perform action to play new item")
        }
        .when(.currentItemIsSet(true), then: { (s31, s) in
            XCTAssertTrue(s31.currentItemIsSet, "current item is set")
            XCTAssertNil(s31.nextAction, "nextAction reset")
        })
        .when(.pause) { (s3, s) in
            XCTAssertEqual(s3.playlist, playlist, "playlist the same")
            XCTAssertEqual(s3.currentTrackIndex, s.last?.currentTrackIndex, "current track the same")
            XCTAssertEqual(s3.playback, .paused, "playback set to \"paused\"")
            XCTAssertEqual(s3.nextAction, .some(.pauseCurrentItem), "perfrom action to pause current item")
        }
        .when(.resume) { (s4, s) in
            XCTAssertEqual(s4.playlist, playlist, "playlist the same")
            XCTAssertEqual(s4.currentTrackIndex, s.last?.currentTrackIndex, "current track the same")
            XCTAssertEqual(s4.playback, .playing, "playback set to \"playing\"")
            XCTAssertEqual(s4.nextAction, .some(.playCurrentItem), "perfrom action to play current item")
        }
        // When currentItemFinished and next playable track exists:
        .when(.playingItemFinished) { (s5, s) in
            let i = 3
            XCTAssertEqual(s5.playlist, playlist, "playlist the same")
            XCTAssertEqual(s5.currentTrackIndex, i, "current track should be set to next playable track")
            XCTAssertEqual(s5.playback, s.last?.playback, "playback the same")
            let track = PlayableMusicTrack(
                originalTrack: playlist.tracks[i],
                audioURL: playlist.tracks[i].audioURL!
            )
            XCTAssertEqual(s5.nextAction, .playNewItem(track), "no next action")
        }
        // When currentItemFinished and next playable track doesn't exists:
        .when(.playingItemFinished) { (s6, _) in
            XCTAssertEqual(s6.playlist, playlist, "playlist the same")
            XCTAssertEqual(s6.currentTrackIndex, 3, "current track leaved the same")
            XCTAssertEqual(s6.playback, .stopped, "playback set to 'stoped'")
            XCTAssertEqual(s6.nextAction, nil, "no next action")
        }
    }
}
