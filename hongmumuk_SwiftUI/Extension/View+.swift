//
//  View+.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 2/2/25.
//

import SwiftUI

extension View {
    func applyShadows(_ style: ShadowStyle) -> some View {
        var modifiedView = AnyView(self)
        for shadow in style.shadows {
            modifiedView = AnyView(
                modifiedView.shadow(
                    color: shadow.color,
                    radius: shadow.radius,
                    x: shadow.x,
                    y: shadow.y
                )
            )
        }
        return modifiedView
    }
}
