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
    @State var showOverlay: Bool = false
    @State var showVisuals: Bool = false
    @State var seconds: Int = 0
    @State var number: Int = 0

    var body: some View {
        VStack {
            HStack {
                Button {
                    showOverlay.toggle()
                } label: {
                    Text("Saves")
                }
                .buttonStyle(.bordered)
                Spacer()
                HandView(status: viewModel.leftConnected, name: "LEFT")
                HandView(status: viewModel.rightConnected, name: "RIGHT")
                Button(showVisuals ? "Hide V" : "Show V") {
                    showVisuals.toggle()
                }
            }
            .padding(.horizontal)

            if showVisuals {
                HStack {
                    MeasurementView(data: viewModel.latestLeftReading)
                    MeasurementView(data: viewModel.latestRightReading)
                }
                .padding()
            }

            HStack {
                Text("\(seconds)")
                Text("COUNT: \(number)")
            }

            ScrollView {
                CaptureTypesView(title: "Punches", types: CaptureType.punches)
                CaptureTypesView(title: "Defense", types: CaptureType.defense)
                CaptureTypesView(title: "Combos", types: CaptureType.combos)
            }

        }
        .onAppear {
            viewModel.start()
        }
        .sheet(isPresented: $showOverlay) {

        } content: {
            FolderView()
        }
        .onReceive(viewModel.timer) { _ in
            if viewModel.trackingData {
                viewModel.saveRecording()
                viewModel.startRecording()
                number += 1
            } else {
                number = 0
            }
        }
        .onReceive(viewModel.countdown) { date in
            if seconds == 4 {
                seconds = 0
            }
            seconds += 1
        }
    }
}

