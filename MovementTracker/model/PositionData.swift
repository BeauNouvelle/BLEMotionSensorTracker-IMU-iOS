//
//  PositionData.swift
//  MovementTracker
//
//  Created by Beau Nouvelle on 11/3/2022.
//

import Foundation

struct MotionData: Codable {
    let a: PositionData
    let g: PositionData

    struct PositionData: Codable {
        let x: Double
        let y: Double
        let z: Double
    }
}
