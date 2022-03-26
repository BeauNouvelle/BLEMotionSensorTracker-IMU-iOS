//
//  FilesView.swift
//  MovementTracker
//
//  Created by Beau Nouvelle on 23/3/2022.
//

import Foundation
import SwiftUI

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
