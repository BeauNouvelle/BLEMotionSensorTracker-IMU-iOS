//
//  Snapshot.swift
//  MovementTracker
//
//  Created by Beau Nouvelle on 11/3/2022.
//

import Foundation

struct SnapshotRow: Codable {
    let leftAccX: Double?
    let leftAccY: Double?
    let leftAccZ: Double?
    let leftGyroX: Double?
    let leftGyroY: Double?
    let leftGyroZ: Double?

    let rightAccX: Double?
    let rightAccY: Double?
    let rightAccZ: Double?
    let rightGyroX: Double?
    let rightGyroY: Double?
    let rightGyroZ: Double?

    let type: String

    enum CodingsKeys: String, CodingKey, CaseIterable {
        case leftAccX
        case leftAccY
        case leftAccZ
        case leftGyroX
        case leftGyroY
        case leftGyroZ

        case rightAccX
        case rightAccY
        case rightAccZ
        case rightGyroX
        case rightGyroY
        case rightGyroZ

        case type
    }

    init(left: MotionData, right: MotionData, type: String) {
        self.leftAccX = left.a.x
        self.leftAccY = left.a.y
        self.leftAccZ = left.a.z

        self.leftGyroX = left.g.x
        self.leftGyroY = left.g.y
        self.leftGyroZ = left.g.z

        self.rightAccX = right.a.x
        self.rightAccY = right.a.y
        self.rightAccZ = right.a.z

        self.rightGyroX = right.g.x
        self.rightGyroY = right.g.y
        self.rightGyroZ = right.g.z

        self.type = type
    }

}

struct Snapshot: Codable {

    let rows: [SnapshotRow]

    init(leftMotionData: [MotionData], rightMotionData: [MotionData], type: CaptureType) {
        let minCount = min(leftMotionData.count, rightMotionData.count)
        var rows = [SnapshotRow]()

        for index in 0..<minCount {
            let left = leftMotionData[index]
            let right = rightMotionData[index]
            let row = SnapshotRow(left: left, right: right, type: type.rawValue)
            rows.append(row)
        }
        self.rows = rows
    }
}
