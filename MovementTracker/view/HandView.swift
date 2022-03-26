//
//  HandView.swift
//  MovementTracker
//
//  Created by Beau Nouvelle on 23/3/2022.
//

import Foundation
import SwiftUI

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
