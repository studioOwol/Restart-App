//
//  AudioPlayer.swift
//  Restart
//
//  Created by Nahyun on 2023/04/17.
//

import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String){ // 첫번째 파라미터: 이름, 두번째 파라미터: 확장자
    if let path = Bundle.main.path(forResource: sound, ofType: type){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("Could not play the sound file.")
        }
    }
}
