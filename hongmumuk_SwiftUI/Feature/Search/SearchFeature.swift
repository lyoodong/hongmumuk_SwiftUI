//
//  SearchFeature.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/15/25.
//

import ComposableArchitecture
import SwiftUI

struct SearchFeature: Reducer {
    enum ActiveScreen: Equatable {
        case none
        case restrauntDetail(String)
    }
    
    struct State: Equatable {
        var searchText = ""
        var isVisibleClearButton = false
        var activeScreen: ActiveScreen = .none
        var restrauntList = [RestaurantListModel]()
        var searchedList = [RestaurantListModel]()
        var recentSearchList = [String]()
        var isLoading = true
        var pop = false
    }
    
    enum Action: Equatable {
        case onAppear
        case onDismiss
        case searchBarOnSubmit
        case searchBarOnChanged(String)
        case searchBarClearButtonTapped
        case backButtonTapped
        case recentSearchTapped(String)
        case recentSearchAllClearButtonTapped
        case recentSearchClearButtonTapped(String)
        case restrauntTapped(id: String)
        case loadingCompleted
        case recentSearchesLoaded([String])
        case restrauntListLoaded([RestaurantListModel])
        case restrauntListError(RestaurantListError)
    }
    
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    @Dependency(\.restaurantClient) var restaurantClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                    
                return .run { send in
                    let recentSearchList = await userDefaultsClient.getStringArray(.recentSearchList)
                    await send(.recentSearchesLoaded(recentSearchList))

                    do {
                        let body = RestaurantListRequestModel(category: .all, page: 0, sort: .likes)
                        let searchList = try await restaurantClient.getRestaurantList(body)
                        await send(.restrauntListLoaded(searchList))
                    } catch {
                        if let error = error as? RestaurantListError {
                            await send(.restrauntListError(error))
                        }
                    }
                    
                    try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5초 지연
                    await send(.loadingCompleted)
                }
            case .onDismiss:
                state.activeScreen = .none
                return .none
            case .searchBarOnSubmit:
                let query = state.searchText
                state.searchedList = state.restrauntList.filter { filterSearchList($0.name, query: query) }
                
                return .run { send in
                    var recentSearchList = await userDefaultsClient.getStringArray(.recentSearchList)
                    
                    if !recentSearchList.isEmpty, recentSearchList.count >= 10 {
                        recentSearchList.removeLast()
                    }
                    
                    if !recentSearchList.contains(query) {
                        recentSearchList.insert(query, at: 0)
                    }
                
                    await userDefaultsClient.setStringArray(recentSearchList, .recentSearchList)
                    await send(.recentSearchesLoaded(recentSearchList))
                }
            case let .searchBarOnChanged(searchText):
                
                let isEmptyText = searchText.isEmpty
                
                state.searchText = searchText
                state.isVisibleClearButton = !isEmptyText
                
                if !isEmptyText {
                    state.searchedList = state.restrauntList.filter { filterSearchList($0.name, query: searchText) }
                } else {
                    state.searchedList = state.restrauntList
                }
                
                return .none
            case .searchBarClearButtonTapped:
                state.searchText = ""
                state.isVisibleClearButton = false
                state.searchedList = state.restrauntList
                return .none
            case .backButtonTapped:
                state.pop = true
                return .none
            case let .recentSearchTapped(searchText):
                state.searchText = searchText
                state.searchedList = state.restrauntList.filter { filterSearchList($0.name, query: searchText) }
                return .none
            case .recentSearchAllClearButtonTapped:
                return .run { send in
                    await userDefaultsClient.setStringArray([], .recentSearchList)
                    await send(.recentSearchesLoaded([]))
                }
            case let .recentSearchClearButtonTapped(text):
                return .run { send in
                    var recentSearchList = await userDefaultsClient.getStringArray(.recentSearchList)
                    recentSearchList.removeAll { $0 == text }
                    await userDefaultsClient.setStringArray(recentSearchList, .recentSearchList)
                    await send(.recentSearchesLoaded(recentSearchList))
                }
            case let .restrauntTapped(id):
                state.activeScreen = .restrauntDetail(id)
                return .none
            case .loadingCompleted:
                state.isLoading = false
                return .none
            case let .recentSearchesLoaded(list):
                state.recentSearchList = list
                return .none
            case let .restrauntListLoaded(list):
                let sorted = list.sorted { $0.likes > $1.likes }
                state.restrauntList = sorted
                state.searchedList = sorted
                return .none
            case let .restrauntListError(error):
                // 에러처리
                return .none
            }
        }
    }
}

extension SearchFeature {
    // 검색 효율을 높이기 위한 필터링 장치
    func filterSearchList(_ restaurantName: String, query: String) -> Bool {
        let queryChosung = query.convertToChosung()
        let nameChosung = restaurantName.convertToChosung()
        let words = restaurantName.components(separatedBy: .whitespacesAndNewlines)
        
        // 1. 초성 검색 지원
        /// 입력이 초성일 경우에만 지원
        if query.isChosung() {
            /// 초성일 경우, 순서 고려
            /// 한글 -> 'ㅎㄱ' 가능, 'ㄱ' 불가능
            return nameChosung.hasPrefix(queryChosung)
        }

        // 2. 부분 문자열 검색 (대소문자 무시)
        /// 한글 -> '글' 검색 가능
        if restaurantName.localizedCaseInsensitiveContains(query) {
            return true
        }
        
        // 3. 단어 단위 검색
        /// 한 글 -> '한' 검색 가능
        if words.contains(where: { $0.localizedCaseInsensitiveContains(query) }) {
            return true
        }
        
        return false
    }
}
