//
//  ContentView.swift
//  MovementTracker
//
//  Created by Beau Nouvelle on 7/3/2022.
//

import SwiftUI
import CoreBluetooth
import SwiftUICharts

struct ContentView: View {

    @StateObject private var viewModel = BluetoothManager.shared

    var body: some View {
        VStack {
            HStack {
                HandView(status: viewModel.leftConnected, name: "LEFT")
                HandView(status: viewModel.rightConnected, name: "RIGHT")
            }

            Text("LEFT ACCEL")
            MultiLineChart(chartData: MultiLineChartData(dataSets: MultiLineDataSet(dataSets: [
                .init(dataPoints: viewModel.lAccelX.map { .init(value: $0) }, style: .init(lineColour: ColourStyle.init(colour: .green))),
                .init(dataPoints: viewModel.lAccelY.map { .init(value: $0) }, style: .init(lineColour: ColourStyle.init(colour: .red))),
                .init(dataPoints: viewModel.lAccelZ.map { .init(value: $0) }, style: .init(lineColour: ColourStyle.init(colour: .teal)))
            ]), chartStyle: .init(globalAnimation: .linear(duration: 0))))

            Text("LEFT MAG")
            MultiLineChart(chartData: MultiLineChartData(dataSets: MultiLineDataSet(dataSets: [
                .init(dataPoints: viewModel.lMagX.map { .init(value: $0) }, style: .init(lineColour: ColourStyle.init(colour: .green))),
                .init(dataPoints: viewModel.lMagY.map { .init(value: $0) }, style: .init(lineColour: ColourStyle.init(colour: .red))),
                .init(dataPoints: viewModel.lMagZ.map { .init(value: $0) }, style: .init(lineColour: ColourStyle.init(colour: .teal))),
            ]), chartStyle: .init(globalAnimation: .linear(duration: 0))))

            Text("RIGHT ACCEL")
            MultiLineChart(chartData: MultiLineChartData(dataSets: MultiLineDataSet(dataSets: [
                .init(dataPoints: viewModel.rAccelX.map { .init(value: $0) }, style: .init(lineColour: ColourStyle.init(colour: .green))),
                .init(dataPoints: viewModel.rAccelY.map { .init(value: $0) }, style: .init(lineColour: ColourStyle.init(colour: .red))),
                .init(dataPoints: viewModel.rAccelZ.map { .init(value: $0) }, style: .init(lineColour: ColourStyle.init(colour: .teal)))
            ]), chartStyle: .init(globalAnimation: .linear(duration: 0))))

            Text("RIGHT MAG")
            MultiLineChart(chartData: MultiLineChartData(dataSets: MultiLineDataSet(dataSets: [
                .init(dataPoints: viewModel.rMagX.map { .init(value: $0) }, style: .init(lineColour: ColourStyle.init(colour: .green))),
                .init(dataPoints: viewModel.rMagY.map { .init(value: $0) }, style: .init(lineColour: ColourStyle.init(colour: .red))),
                .init(dataPoints: viewModel.rMagZ.map { .init(value: $0) }, style: .init(lineColour: ColourStyle.init(colour: .teal))),
            ]), chartStyle: .init(globalAnimation: .linear(duration: 0))))
        }
        .onAppear {
            viewModel.start()
        }
    }
}

struct HandView: View {

    var status: Status
    var name: String

    var body: some View {
        VStack {
            status.image
                .resizable()
                .scaledToFit()
                .scaleEffect(CGSize(width: name == "RIGHT" ? -1.0 : 1.0, height: 1.0))
                .foregroundColor(status.color)
                .padding(30)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
