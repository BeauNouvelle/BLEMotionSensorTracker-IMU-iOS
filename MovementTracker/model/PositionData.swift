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

        enum CodingKeys: CodingKey {
            case x, y, z
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            x = try container.decode(Double.self, forKey: .x) / 100
            y = try container.decode(Double.self, forKey: .y) / 100
            z = try container.decode(Double.self, forKey: .z) / 100
        }

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
