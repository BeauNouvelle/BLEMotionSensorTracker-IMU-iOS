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

    let gridItem = GridItem(.flexible(minimum: 50, maximum: 200), spacing: 8)
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

            HStack {
                MultiLineChart(chartData: MultiLineChartData(dataSets: MultiLineDataSet(dataSets: [
                    .init(dataPoints: viewModel.lAccelX.map { .init(value: $0) }, style: .init(lineColour: ColourStyle.init(colour: .green))),
                    .init(dataPoints: viewModel.lAccelY.map { .init(value: $0) }, style: .init(lineColour: ColourStyle.init(colour: .red))),
                    .init(dataPoints: viewModel.lAccelZ.map { .init(value: $0) }, style: .init(lineColour: ColourStyle.init(colour: .teal)))
                ]), chartStyle: .init(globalAnimation: .linear(duration: 0))))

                MultiLineChart(chartData: MultiLineChartData(dataSets: MultiLineDataSet(dataSets: [
                    .init(dataPoints: viewModel.rAccelX.map { .init(value: $0) }, style: .init(lineColour: ColourStyle.init(colour: .green))),
                    .init(dataPoints: viewModel.rAccelY.map { .init(value: $0) }, style: .init(lineColour: ColourStyle.init(colour: .red))),
                    .init(dataPoints: viewModel.rAccelZ.map { .init(value: $0) }, style: .init(lineColour: ColourStyle.init(colour: .teal)))
                ]), chartStyle: .init(globalAnimation: .linear(duration: 0))))
            }
            .opacity(showOverlay ? 0 : 1)

            HStack {
                MultiLineChart(chartData: MultiLineChartData(dataSets: MultiLineDataSet(dataSets: [
                    .init(dataPoints: viewModel.lMagX.map { .init(value: $0) }, style: .init(lineColour: ColourStyle.init(colour: .green))),
                    .init(dataPoints: viewModel.lMagY.map { .init(value: $0) }, style: .init(lineColour: ColourStyle.init(colour: .red))),
                    .init(dataPoints: viewModel.lMagZ.map { .init(value: $0) }, style: .init(lineColour: ColourStyle.init(colour: .teal))),
                ]), chartStyle: .init(globalAnimation: .linear(duration: 0))))

                MultiLineChart(chartData: MultiLineChartData(dataSets: MultiLineDataSet(dataSets: [
                    .init(dataPoints: viewModel.rMagX.map { .init(value: $0) }, style: .init(lineColour: ColourStyle.init(colour: .green))),
                    .init(dataPoints: viewModel.rMagY.map { .init(value: $0) }, style: .init(lineColour: ColourStyle.init(colour: .red))),
                    .init(dataPoints: viewModel.rMagZ.map { .init(value: $0) }, style: .init(lineColour: ColourStyle.init(colour: .teal))),
                ]), chartStyle: .init(globalAnimation: .linear(duration: 0))))
            }
            .opacity(showOverlay ? 0 : 1)

            Text("Punches")
            LazyVGrid(columns: [gridItem, gridItem]) {
                ForEach(CaptureType.punches) { cap in
                    Button {
                        viewModel.capture(cap)
                    } label: {
                        HStack {
                            Spacer()
                            Text(cap.rawValue)
                            Spacer()
                        }
                        .foregroundColor(cap == .clear ? .red : .primary)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding(.horizontal)

            Text("Defense")
            LazyVGrid(columns: [gridItem, gridItem]) {
                ForEach(CaptureType.defense) { cap in
                    Button {
                        viewModel.capture(cap)
                    } label: {
                        HStack {
                            Spacer()
                            Text(cap.rawValue)
                            Spacer()
                        }
                        .foregroundColor(cap == .clear ? .red : .primary)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding(.horizontal)

            Text("Combos")
            LazyVGrid(columns: [gridItem, gridItem]) {
                ForEach(CaptureType.combos) { cap in
                    Button {
                        viewModel.capture(cap)
                    } label: {
                        HStack {
                            Spacer()
                            Text(cap.rawValue)
                            Spacer()
                        }
                        .foregroundColor(cap == .clear ? .red : .primary)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding(.horizontal)

            Button {
                viewModel.capture(.clear)
            } label: {
                Spacer()
                Text("Clear")
                Spacer()
            }
            .buttonStyle(.bordered)
            .padding(.horizontal)

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

struct FolderView: View {
    var body: some View {
        NavigationView {
            List(SaveManager.folders(), id: \.absoluteString) { url in
                NavigationLink {
                    FilesView(files: SaveManager.files(in: url), url: url, title: url.lastPathComponent)
                } label: {
                    Text(url.lastPathComponent)
                }
            }
            .navigationTitle(Text("Folders"))
        }
    }
}

struct FilesView: View {

    @State var showShareSheet: Bool = false
    @State var files: [URL]
    let url: URL
    let title: String

    var body: some View {
        Button {
            showShareSheet.toggle()
        } label: {
            Text("SHARE ALL")
        }
        .buttonStyle(.bordered)

        List {
            ForEach(files, id: \.lastPathComponent) { url in
                NavigationLink {
                    FilePreviewView(url: url)
                } label: {
                    Text(url.lastPathComponent)
                }
            }
            .onDelete(perform: delete)
        }
        .navigationTitle(title)
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(sharing: files)
        }
        .onAppear {
            files = SaveManager.files(in: url)
        }
    }

    func delete(at offsets: IndexSet) {
        for offset in offsets {
            let itemToDelete = files[offset]
            SaveManager.delete(file: itemToDelete)
        }
        files.remove(atOffsets: offsets)
    }

}

struct ShareSheet: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIActivityViewController

    var sharing: [Any]

    func makeUIViewController(context: UIViewControllerRepresentableContext<ShareSheet>) -> UIActivityViewController {
        UIActivityViewController(activityItems: sharing, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ShareSheet>) {

    }
}

struct HandView: View {

    var status: BluetoothStatus
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
