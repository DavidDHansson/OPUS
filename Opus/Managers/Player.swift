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
    
    var firstTime: Bool = true
    
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
        
        // Load saved opus
        loadSettings()
        
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
    
    func loadSettings() {
        let data: [OpusType] = UserDefaults.standard.structArrayData(OpusType.self, forKey: "settings")
        opus = data
        
        // First timers
        if opus.isEmpty {
            opus = standardOpus
            UserDefaults.standard.setStructArray(opus, forKey: "settings")
        }
        
        print("\n--opus, load in home--")
        for i in opus {
            print("\(i.title): \(i.enabled)")
        }
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
    
    // If the weight is 0.5, the element is added 5 times (0.5 * 10) to the array "options"
    // Depending on the weight the appropriate amount of elements are added
    // In the end a random element in the "options" array is picked out
    // Therefore higher weights gives more occurrences in the array, leading to a higher probability
    
    private func getWeightedDrop(from drops: [OpusType]) -> OpusType {
        
        var options = [OpusType]()
        let availableOpus = drops.filter({ $0.enabled == true })
        
        print("\n\n--Available in Getweighteddrop--")
        for i in availableOpus {
            print("\(i.title): \(i.enabled)")
        }
        print("----\n")
        
        for current in availableOpus {
            for _ in 0 ..< (Int(current.weight * 10.0)) {
                options.append(current)
            }
        }
        
        let index = Int.random(in: 0 ... options.count - 1)
        return options[index]
    }
    
    private func generateWeightReport(times: Int) {
        
        var items = [String]()
        
        for _ in 0 ..< times {
            items.append(getWeightedDrop(from: opus).title)
        }
        
        var counts: [String: Int] = [:]
        for item in items {
            counts[item] = (counts[item] ?? 0) + 1
        }
        
        print("\n\n-----Weight Report-----")
        for (key, value) in counts {
            print("\(key) occurs \(value) time(s)")
        }
        print("\n\n")
    }
    
    func generateQueue() {
        
        // For analyzing opus weights
//        generateWeightReport(times: 100)
        
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
        
        // Bug fix, can't set player.volume first time
        if firstTime {
            queueIndex = 0
            progress = 0.0
            firstTime = false
        } else {
            clear()
        }
        
        // Load saved settings
        loadSettings()
        
        // Local queue array
        var q = [Clip]()
        
        // Get the opus type
        let type = getWeightedDrop(from: opus)
        
        // Fill queue
        switch type.type {
        case .quickDrop:
            // -- Quick Drop --
            q.append(Clip(bit: .buildUpFull, stopAfter: Double.random(in: 15 ... 40)))
            q.append(Clip(bit: .drop, stopAfter: 60))
        case .slowPart:
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

        case .slowPartQuickDrop:
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
        case .normal:
            // -- Normal --
            q = addInitielBuildUp(withBambam: true)
            q.append(Clip(bit: .drop, stopAfter: 60))
        }

        print("\n\n----- Queue (type: \(type.title)) -----")
        for part in q {
            print("Part: \(part.bit.rawValue), stops after: \(part.stopAfter)")
        }
        
        queue = q
    }
    
}
