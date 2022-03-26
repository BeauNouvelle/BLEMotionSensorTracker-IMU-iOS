//
//  OnPressButtonModifier.swift
//  MovementTracker
//
//  Created by Beau Nouvelle on 26/3/2022.
//

import Foundation
import SwiftUI

struct PressActions: ViewModifier {
    var onPress: () -> Void

    @State var enabled: Bool = true

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in
                        if enabled {
                            onPress()
                            enabled = false
                        }
                    })
            )
            .simultaneousGesture(LongPressGesture(minimumDuration: 0).onEnded({ _ in
                enabled = true
            }))
    }
}

extension View {
    func pressAction(onPress: @escaping (() -> Void)) -> some View {
        modifier(PressActions(onPress: {
            onPress()
        }))
    }
}
