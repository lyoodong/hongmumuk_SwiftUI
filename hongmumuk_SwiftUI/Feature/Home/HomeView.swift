//
//  HomeView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/4/25.
//

import ComposableArchitecture
import SwiftUI

struct HomeView: View {
    let store: StoreOf<HomeFeature>
    @ObservedObject var viewStore: ViewStoreOf<HomeFeature>
    
    init(store: StoreOf<HomeFeature>) {
        self.store = store
        viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    CategoryGridView(viewStore: viewStore, size: geometry.size.width - 16)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
            }
            .onAppear { viewStore.send(.onAppear) }
            .navigationDestination(
                isPresented: viewStore.binding(
                    get: { $0.showRestaurantList != nil },
                    send: { _ in .categoryTapped(nil) }
                )
            ) {
                if let category = viewStore.showRestaurantList {
                    // 화면 전환!
                }
            }
        }
    }
}

// MARK: - CategoryGridView

private struct CategoryGridView: View {
    @ObservedObject var viewStore: ViewStoreOf<HomeFeature>
    let size: CGFloat
    private let spacing: CGFloat = 8
    
    var body: some View {
        let itemSize = (size - spacing * 2) / 3
        
        LazyVGrid(
            columns: Array(repeating: GridItem(.fixed(itemSize), spacing: spacing), count: 3),
            spacing: spacing
        ) {
            ForEach(viewStore.categories, id: \.self) { category in
                CategoryItemView(
                    viewStore: viewStore,
                    category: category,
                    size: itemSize
                )
            }
        }
    }
}

// MARK: - CategoryItemView

private struct CategoryItemView: View {
    @ObservedObject var viewStore: ViewStoreOf<HomeFeature>
    let category: Category
    let size: CGFloat
    
    var body: some View {
        Button(action: { viewStore.send(.categoryTapped(category)) }) {
            Text(category.rawValue)
                .font(Fonts.heading2Bold.toFont())
                .frame(width: size, height: size)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(20)
        }
    }
}
