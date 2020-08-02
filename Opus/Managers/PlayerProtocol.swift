//
//  PlayerProtocol.swift
//  Opus
//
//  Created by David Hansson on 28/07/2020.
//  Copyright © 2020 David Hansson. All rights reserved.
//

import UIKit

protocol PlayerProtocol {
    func generateQueue()
    func pause()
    func unPause()
    func setup()
    func start()
    func loadSettings()
}
