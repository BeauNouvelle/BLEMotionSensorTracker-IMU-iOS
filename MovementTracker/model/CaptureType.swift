//
//  CaptureType.swift
//  MovementTracker
//
//  Created by Beau Nouvelle on 11/3/2022.
//

import Foundation

enum CaptureType: String, Identifiable {
    case jab
    case cross
    case leadUppercut
    case rearUppercut
    case leadHook
    case rearHook
    case clear

    case roll
    case slip

    case oneTwo // jab cross
    case oneOneTwo // jab jab cross
    case oneTwoThree // jab cross front-hook
    case oneTwoThreeTwo // jab cross front-hook cross
    case oneTwoFiveTwo // jab cross front-uppercut cross
    case oneSixThreeTwo // jab rear-uppercut front-hook cross
    case twoThreeTwo // cross front-hook cross

    var id: String {
        return self.rawValue
    }

    static var punches: [CaptureType] {
        return [.jab, .cross, .leadUppercut, .rearUppercut, .leadHook, .rearHook]
    }

    static var defense: [CaptureType] {
        return [.roll, .slip]
    }

    static var combos: [CaptureType] {
        return [.oneTwo, .oneOneTwo, .oneTwoThree, .oneTwoThreeTwo, .oneTwoFiveTwo, .oneSixThreeTwo, .twoThreeTwo]
    }
}
