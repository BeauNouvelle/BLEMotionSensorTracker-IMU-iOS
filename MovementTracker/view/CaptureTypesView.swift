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
