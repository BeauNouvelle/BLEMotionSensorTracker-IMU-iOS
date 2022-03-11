//
//  SaveManager.swift
//  MovementTracker
//
//  Created by Beau Nouvelle on 11/3/2022.
//

import Foundation

struct SaveManager {

    static func delete(file: URL) {
        do {
            try FileManager.default.removeItem(at: file)
        } catch {
            print(error.localizedDescription)
        }
    }

    static func folders() -> [URL] {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let csvDir = documentsDirectory.appendingPathComponent("csv")
        do {
            let items = try FileManager.default.contentsOfDirectory(at: csvDir, includingPropertiesForKeys: [.isDirectoryKey], options: .skipsHiddenFiles)
            return items
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    static func files(in folder: URL) -> [URL] {
        do {
            let items = try FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            return items
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    static func save(csv: Data, type: CaptureType) {
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let csvDir = docDir.appendingPathComponent("csv")
        let saveFolder = csvDir.appendingPathComponent(type.rawValue)
        let saveLocation = saveFolder.appendingPathComponent(Date.now.description).appendingPathExtension("csv")

        if !FileManager.default.fileExists(atPath: saveFolder.path) {
            do {
                try FileManager.default.createDirectory(atPath: saveFolder.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }

        do {
            try csv.write(to: saveLocation)
        } catch {
            print(error.localizedDescription)
        }
    }

}
