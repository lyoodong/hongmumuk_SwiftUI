//
//  SearchRecentView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/15/25.
//

import ComposableArchitecture
import SwiftUI

struct RecentSearchView: View {
    @ObservedObject var viewStore: ViewStoreOf<SearchFeature>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("최근 검색 결과")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action: {
                    viewStore.send(.recentSearchAllClearButtonTapped)
                }) {
                    Text("전체 삭제")
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                }
                .padding(.leading, 8)
            }
            
            if viewStore.recentSearchList.isEmpty {
                HStack {
                    Spacer()
                    Text("최근 검색 결과가 없습니다.")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Spacer()
                }
                .frame(height: 16)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewStore.recentSearchList, id: \.self) { searchText in
                            HStack(spacing: 4) {
                                Text(searchText)
                                    .font(.system(size: 14))
                                    .foregroundColor(.black)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 12)
                                
                                Button(action: {
                                    viewStore.send(.recentSearchClearButtonTapped(searchText))
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                        .foregroundColor(.gray)
                                }
                            }
                            .background(recentSearchItemBackgroundView)
                            .onTapGesture {
                                viewStore.send(.recentSearchTapped(searchText))
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var recentSearchItemBackgroundView: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Colors.GrayScale.grayscale5)
    }
}
