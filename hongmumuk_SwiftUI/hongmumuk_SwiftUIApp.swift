//
//  hongmumuk_SwiftUIApp.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 1/19/25.
//

import ComposableArchitecture
import SwiftUI

@main
struct Hongmumuk_SwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(store: Store(initialState: HomeFeature.State(), reducer: HomeFeature.init))
        }
    }
}
