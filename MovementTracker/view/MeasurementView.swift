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
            MeasurementRow(title: "aX", data: data.ax)
            MeasurementRow(title: "aY", data: data.ay)
            MeasurementRow(title: "aZ", data: data.az)
            
            MeasurementRow(title: "gX", data: data.gx)
            MeasurementRow(title: "gY", data: data.gy)
            MeasurementRow(title: "gZ", data: data.gz)
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
