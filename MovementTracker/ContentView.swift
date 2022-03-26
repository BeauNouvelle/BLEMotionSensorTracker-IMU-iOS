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
            }
            .padding(.horizontal)

            if viewModel.isRecording {
                PopoverView(viewModel: viewModel)
            } else {
                HStack {
                    MeasurementView(data: viewModel.latestLeftReading)
                    MeasurementView(data: viewModel.latestRightReading)
                }
                .padding()
            }

            CaptureTypesView(title: "Punches", types: CaptureType.punches)
            CaptureTypesView(title: "Defense", types: CaptureType.defense)
//            CaptureTypesView(title: "Combos", types: CaptureType.combos)
        }
        .onAppear {
            viewModel.start()
        }
        .sheet(isPresented: $showOverlay) {

        } content: {
            FolderView()
        }

    }
}

