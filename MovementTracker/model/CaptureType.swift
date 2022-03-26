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
    case lowJabCross
    case lowLeftRight

    case lowJab
    case lowCross

    case lowLeft
    case lowRight

    case roll
    case slip
    case stance

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
        return [.jab, .cross, .leadUppercut, .rearUppercut, .leadHook, .rearHook, .lowJab, .lowCross, .lowLeft, .lowRight, .lowJabCross, .lowLeftRight]
    }

    static var defense: [CaptureType] {
        return [.roll, .slip, .stance]
    }

    static var combos: [CaptureType] {
        return [.oneTwo, .oneOneTwo, .oneTwoThree, .oneTwoThreeTwo, .oneTwoFiveTwo, .oneSixThreeTwo, .twoThreeTwo]
    }
}
