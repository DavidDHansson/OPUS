//
//  Player.swift
//  Opus
//
//  Created by David Hansson on 28/07/2020.
//  Copyright © 2020 David Hansson. All rights reserved.
//

import UIKit
import AVFoundation

public class Player: PlayerProtocol {
    
    var player: AVAudioPlayer = AVAudioPlayer()
    var state: PlayerState = .disabled
    
    var progress: Double = 0.0
    var queue = [Clip]()
    var queueIndex: Int = 0
    
    private func play(bit: Bit) {
        guard let url = Bundle.main.url(forResource: bit.rawValue, withExtension: "mp3") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            player.volume = 1
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func pause() {
        state = .paused
        player.pause()
    }
    
    func unPause() {
        state = .playing
        player.play()
    }
    
    func start() {
        play(bit: queue[queueIndex].bit)
    }
    
    func setup() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            DispatchQueue.main.async {
                Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.tick), userInfo: nil, repeats: true)
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func clear() {
        queue = [Clip]()
        queueIndex = 0
        progress = 0.0
        state = .disabled
        player.volume = 1
        player.stop()
    }
    
    @objc private func tick() {
        if state == .paused || state == .disabled { return }

        progress += 0.1

        let randomAddition = Double.random(in: 3 ... 10)
        if queue[queueIndex].stopAfter - progress <= randomAddition, queue[queueIndex].stopAfter >= randomAddition, queueIndex + 1 != queue.count {
            player.volume += 0.025
        }

        if progress >= queue[queueIndex].stopAfter {
            progress = 0
            queueIndex += 1

            if queueIndex == queue.count {
                NotificationCenter.default.post(name: NSNotification.Name("disablePlayButton"), object: nil)
                clear()
                return
            }

            play(bit: queue[queueIndex].bit)
        }
    }
    
    func generateQueue() {
        
        func addInitielBuildUp(withBambam: Bool) -> [Clip] {
            var q = [Clip]()
            q.append(Clip(bit: .buildUpFull, stopAfter: Double.random(in: 190 ... 224)))
            if withBambam { q.append(Clip(bit: .bambam, stopAfter: 0.4)) }
            return q
        }
        
        func addSlowPhase(_ queue: [Clip]) -> [Clip] {
            var q = [Clip]()
            q.append(Clip(bit: .slow, stopAfter: Double.random(in: 6 ... 54)))
            q.append(Clip(bit: .bambam, stopAfter: 0.4))
            q.append(Clip(bit: .build, stopAfter: Double.random(in: 0 ... 34)))
            return queue + q
        }
        
        /*
           Algorithm for making the queue
           Opus features:
            0. Quick drop, drop after 15 - 40 seconds
                BuildUpFull, bambam, drop
            1. Slow part
                2/3 BuildUpFull, bambam, slow, bambam, build, drop
                1/3 BuildUpFull, bambam, slow, bambam, build, bambam, slow, build, drop
            2. Slow part, quick drop
                2/3 BuildUpFull, bambam, slow, drop
                1/3 BuildUpFull, bambam, slow, bambam, build, bamabam, slow, drop
            4. Normal
                BuildUpFull, drop
        */
        
        clear()
        var q = [Clip]()
        
        switch Int.random(in: 0 ... 2) {
        case 0:
            // -- Quick Drop --
            q.append(Clip(bit: .buildUpFull, stopAfter: Double.random(in: 15 ... 40)))
            q.append(Clip(bit: .drop, stopAfter: 60))
        case 1:
            // -- Slow Part--
            q = addInitielBuildUp(withBambam: true)
            
            // Determining 1 or 2 slow parts
            if Int.random(in: 0 ... 3) == 2 {
                q = addSlowPhase(q)
                q.append(Clip(bit: .drop, stopAfter: 60))
            } else {
                q = addSlowPhase(q)
                q.append(Clip(bit: .bambam, stopAfter: 0.4))
                q.append(Clip(bit: .slow, stopAfter: Double.random(in: 6 ... 54)))
                q.append(Clip(bit: .bambam, stopAfter: 0.4))
                q.append(Clip(bit: .build, stopAfter: Double.random(in: 0 ... 34)))
                q.append(Clip(bit: .drop, stopAfter: 60))
            }

        case 2:
            // -- Slow part, Quick drop --
            q = addInitielBuildUp(withBambam: true)
            
            if Int.random(in: 0 ... 3) == 2 {
                q = addSlowPhase(q)
                q.append(Clip(bit: .bambam, stopAfter: 0.4))
                q.append(Clip(bit: .slow, stopAfter: Double.random(in: 6 ... 54)))
                q.append(Clip(bit: .drop, stopAfter: 60))
            } else {
                q.append(Clip(bit: .slow, stopAfter: Double.random(in: 6 ... 54)))
                q.append(Clip(bit: .drop, stopAfter: 60))
            }
            
        default:
            return
        }

        print("\n\n----- Queue -----")
        for part in q {
            print("Part: \(part.bit.rawValue), stops after: \(part.stopAfter)")
        }
        
        queue = q
    }
    
}
