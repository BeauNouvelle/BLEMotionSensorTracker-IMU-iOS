//
//  BluetoothStatus.swift
//  MovementTracker
//
//  Created by Beau Nouvelle on 11/3/2022.
//

import Foundation
import SwiftUI

enum BluetoothStatus: String {
    case searching
    case connecting
    case connected
    case disconnected
    case error

    var image: Image {
        switch self {
            case .searching:
                return Image(systemName: "hand.raised")
            case .connecting:
                return Image(systemName: "hand.raised.fill")
            case .connected:
                return Image(systemName: "hand.thumbsup.fill")
            case .disconnected:
                return Image(systemName: "hand.raised.slash")
            case .error:
                return Image(systemName: "hand.thumbsdown")
        }
    }

    var color: Color {
        switch self {
            case .searching:
                return .primary
            case .connecting:
                return .teal
            case .connected:
                return .green
            case .disconnected:
                return .orange
            case .error:
                return .red
        }
    }
}
