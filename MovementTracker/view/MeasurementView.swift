//
//  MeasurementView.swift
//  MovementTracker
//
//  Created by Beau Nouvelle on 23/3/2022.
//

import Foundation
import SwiftUI

struct MeasurementView: View {
    let data: MotionData

    var body: some View {
        VStack {
            MeasurementRow(title: "aX", data: data.a.x)
            MeasurementRow(title: "aY", data: data.a.y)
            MeasurementRow(title: "aZ", data: data.a.z)

            MeasurementRow(title: "gX", data: data.g.x)
            MeasurementRow(title: "gY", data: data.g.y)
            MeasurementRow(title: "gZ", data: data.g.z)
        }
    }

    struct MeasurementRow: View {
        let title: String
        let data: Double

        var body: some View {
            HStack {
                Text(title)
                Spacer()
                Text("\(data)")
            }
        }
    }
}
