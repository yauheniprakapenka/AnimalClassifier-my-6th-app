
//
//  GlobalSetting.swift
//  AnimalClassifier
//
//  Created by yauheni prakapenka on 30.11.2019.
//  Copyright © 2019 yauheni prakapenka. All rights reserved.
//

import Foundation

struct GlobalSetting {
    
    // Debug
    static var debugMode = false // used in BoosterVC
    
    // Booster
    static var boosterIsActive = false
    static let boosterSetTime = 7
    static var boosterTimerLeft = boosterSetTime
    
    // Profile
    static var profileMoney = 0
    
    // BoosterVC
    static let gold = 10
    static let silver = 5
    
    // DotsVC
    static let needDotsScoreToWin = 24
    static let givePointsForWin = 20
}

