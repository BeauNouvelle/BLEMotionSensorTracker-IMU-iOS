//
//  FolderView.swift
//  MovementTracker
//
//  Created by Beau Nouvelle on 23/3/2022.
//

import Foundation
import SwiftUI

struct FolderView: View {

    @State var showDelete: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                Button("Delete All", role: .destructive) {
                    showDelete.toggle()
                }
                List(SaveManager.folders(), id: \.absoluteString) { url in
                    NavigationLink {
                        FilesView(files: SaveManager.files(in: url), url: url, title: url.lastPathComponent)
                    } label: {
                        Text(url.lastPathComponent)
                    }
                }
                .navigationTitle(Text("Folders"))
                .alert("Delete?", isPresented: $showDelete) {
                    Button("Delete", role: .destructive) {
                        SaveManager.deleteAll()
                    }
                }
            }
        }
    }
}
