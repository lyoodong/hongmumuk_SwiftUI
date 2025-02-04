//
//  HomeFeature.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/4/25.
//

import ComposableArchitecture
import SwiftUI

struct HomeFeature: Reducer {
    // 상태 명세
    struct State: Equatable {
        var categories: [Category] = []
        var showRestaurantList: Category? = nil
    }
    
    // 액션 정의
    enum Action: Equatable {
        case onAppear
        case categoryTapped(Category?)
    }
    
    // 액션을 상태로 변환
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.categories = Category.allCases.filter { $0 != .all }
                return .none
                
            case let .categoryTapped(category):
                if category != .logo { state.showRestaurantList = category }
                return .none
            }
        }
    }
}
