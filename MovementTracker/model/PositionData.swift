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

        init() {
            x = 0
            y = 0
            z = 0
        }
    }
}

extension ClosedRange {
    func clamp(_ value : Bound) -> Bound {
        return self.lowerBound > value ? self.lowerBound
            : self.upperBound < value ? self.upperBound
            : value
    }
}
