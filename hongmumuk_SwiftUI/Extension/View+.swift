//
//  View+.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 2/2/25.
//

import SwiftUI

extension View {
    func applyShadows(_ style: ShadowStyle) -> some View {
        style.shadows.reduce(AnyView(self)) { view, shadow in
            AnyView(view.shadow(
                color: shadow.color,
                radius: shadow.radius,
                x: shadow.x,
                y: shadow.y
            ))
        }
    }
}

