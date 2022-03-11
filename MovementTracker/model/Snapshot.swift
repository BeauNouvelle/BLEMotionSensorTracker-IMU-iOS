//
//  Snapshot.swift
//  MovementTracker
//
//  Created by Beau Nouvelle on 11/3/2022.
//

import Foundation

struct SnapshotRow: Codable {
    let leftAccX: Int16?
    let leftAccY: Int16?
    let leftAccZ: Int16?
    let leftGyroX: Int16?
    let leftGyroY: Int16?
    let leftGyroZ: Int16?
    let leftMagX: Int16?
    let leftMagY: Int16?
    let leftMagZ: Int16?

    let rightAccX: Int16?
    let rightAccY: Int16?
    let rightAccZ: Int16?
    let rightGyroX: Int16?
    let rightGyroY: Int16?
    let rightGyroZ: Int16?
    let rightMagX: Int16?
    let rightMagY: Int16?
    let rightMagZ: Int16?

    let type: String
    let date: String

    enum CodingsKeys: String, CodingKey, CaseIterable {
        case leftAccX
        case leftAccY
        case leftAccZ
        case leftGyroX
        case leftGyroY
        case leftGyroZ
        case leftMagX
        case leftMagY
        case leftMagZ

        case rightAccX
        case rightAccY
        case rightAccZ
        case rightGyroX
        case rightGyroY
        case rightGyroZ
        case rightMagX
        case rightMagY
        case rightMagZ

        case type, date
    }
}

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct Snapshot: Codable {

    let rows: [SnapshotRow]

    init(leftAccData: [PositionData], leftMagData: [PositionData], leftGyroData: [PositionData],
         rightAccData: [PositionData], rightMagData: [PositionData], rightGyroData: [PositionData], type: CaptureType) {

        let maxCount = max(leftAccData.count, leftMagData.count, leftGyroData.count, rightAccData.count, rightMagData.count, rightGyroData.count)
        let date = Date.now.description

        var rows = [SnapshotRow]()

        for index in 0..<maxCount {
            rows.append(
                SnapshotRow(leftAccX: leftAccData[safe: index]?.x,
                            leftAccY: leftAccData[safe: index]?.y,
                            leftAccZ: leftAccData[safe: index]?.z,
                            leftGyroX: leftGyroData[safe: index]?.x,
                            leftGyroY: leftGyroData[safe: index]?.y,
                            leftGyroZ: leftGyroData[safe: index]?.z,
                            leftMagX: leftMagData[safe: index]?.x,
                            leftMagY: leftMagData[safe: index]?.y,
                            leftMagZ: leftMagData[safe: index]?.z,
                            rightAccX: rightAccData[safe: index]?.x,
                            rightAccY: rightAccData[safe: index]?.y,
                            rightAccZ: rightAccData[safe: index]?.z,
                            rightGyroX: rightGyroData[safe: index]?.x,
                            rightGyroY: rightGyroData[safe: index]?.y,
                            rightGyroZ: rightGyroData[safe: index]?.z,
                            rightMagX: rightMagData[safe: index]?.x,
                            rightMagY: rightMagData[safe: index]?.y,
                            rightMagZ: rightMagData[safe: index]?.z,
                            type: type.rawValue,
                            date: date)
            )
        }
        self.rows = rows
    }
}
