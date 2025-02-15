//
//  HomeView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/4/25.
//

import ComposableArchitecture
import SwiftUI

struct HomeView: View {
    private let store: StoreOf<HomeFeature>
    @ObservedObject private var viewStore: ViewStoreOf<HomeFeature>
    
    init(store: StoreOf<HomeFeature>) {
        self.store = store
        viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                HomeHeaderView(viewStore: viewStore)
                HomeCircleView(viewStore: viewStore)
                HomeRandomButton(viewStore: viewStore)
            }
            .onAppear { viewStore.send(.onAppear) }
        }
        .navigationDestination(
            isPresented: viewStore.binding(
                get: { $0.activeScreen != .none },
                send: .onDismiss
            )
        ) {
            let screen = viewStore.activeScreen
            if case .random = screen {
                // random View
            } else if case .search = screen {
                // search View
            } else if case let .cateogryList(category) = screen {
                // category List View
            }
        }
    }
}

// MARK: - NextView

struct NextView: View {
    var onDisappearAction: () -> Void
    
    var body: some View {
        Text("다음 화면")
            .onDisappear {
                onDisappearAction()
            }
    }
}
