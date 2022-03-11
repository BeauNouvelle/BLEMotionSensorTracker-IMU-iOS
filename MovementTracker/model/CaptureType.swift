//
//  CaptureType.swift
//  MovementTracker
//
//  Created by Beau Nouvelle on 11/3/2022.
//

import Foundation

enum CaptureType: String, CaseIterable, Identifiable {
    case leadJab
    case rearJab
    case cross
    case leadUppercut
    case rearUppercut
    case leadHook
    case rearHook
    case clear

    var id: String {
        return self.rawValue
    }
}
