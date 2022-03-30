//
//  CaptureTypesView.swift
//  MovementTracker
//
//  Created by Beau Nouvelle on 23/3/2022.
//

import Foundation
import SwiftUI

struct CaptureTypesView: View {

    @StateObject private var viewModel = BluetoothManager.shared

    let title: String
    let types: [CaptureType]
    let gridItem = GridItem(.flexible(minimum: 50, maximum: 200), spacing: 8)

    @State var running: Bool = false

    var body: some View {
        VStack {
            Text(title)
            LazyVGrid(columns: [gridItem, gridItem]) {
                ForEach(types) { cap in
                    Button(cap.rawValue) {
                        viewModel.captureType = cap
                        viewModel.trackingData.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(viewModel.trackingData && viewModel.captureType == cap ? .red : .blue)
                }
            }
            .padding(.horizontal)
        }
    }

}

import SwiftUICharts

struct PopoverView: View {

    @StateObject var viewModel: BluetoothManager

    var body: some View {
        HStack {
            MultiLineChart(chartData: viewModel.leftChartData.chartData())
            MultiLineChart(chartData: viewModel.rightChartData.chartData())
        }
    }
}

extension Array where Element == (ax: LineChartDataPoint, ay: LineChartDataPoint, az: LineChartDataPoint, gx: LineChartDataPoint, gy: LineChartDataPoint, gz: LineChartDataPoint) {

    func chartData() -> MultiLineChartData {
        let lAXDataPoints = self.map { $0.ax }
        let lAXSet = LineDataSet(dataPoints: lAXDataPoints, style: style(color: .red))

        let lAYDataPoints = self.map { $0.ay }
        let lAYSet = LineDataSet(dataPoints: lAYDataPoints, style: style(color: .blue))

        let lAZDataPoints = self.map { $0.az }
        let lAZSet = LineDataSet(dataPoints: lAZDataPoints, style: style(color: .green))

        let lGXDataPoints = self.map { $0.gx }
        let lGXSet = LineDataSet(dataPoints: lGXDataPoints, style: style(color: .yellow))

        let lGYDataPoints = self.map { $0.gy }
        let lGYSet = LineDataSet(dataPoints: lGYDataPoints, style: style(color: .purple))

        let lGZDataPoints = self.map { $0.gz }
        let lGZSet = LineDataSet(dataPoints: lGZDataPoints, style: style(color: .teal))

        let dataSet = MultiLineDataSet(dataSets: [lAXSet, lAYSet, lAZSet, lGXSet, lGYSet, lGZSet])
        let chartData = MultiLineChartData(dataSets: dataSet, chartStyle: .init(globalAnimation: .linear(duration: 0)))
        return chartData
    }

    func style(color: Color) -> LineStyle {
        return .init(lineColour: .init(colour: color), lineType: .line, strokeStyle: .init(lineWidth: 0.5), ignoreZero: true)
    }

}

extension MotionData {

    func chartData() -> (ax: LineChartDataPoint, ay: LineChartDataPoint, az: LineChartDataPoint, gx: LineChartDataPoint, gy: LineChartDataPoint, gz: LineChartDataPoint) {
        return (ax: LineChartDataPoint(value: a.x),
                ay: LineChartDataPoint(value: a.y),
                az: LineChartDataPoint(value: a.z),
                gx: LineChartDataPoint(value: g.x),
                gy: LineChartDataPoint(value: g.y),
                gz: LineChartDataPoint(value: g.z))
    }

}
