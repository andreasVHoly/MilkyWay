//
//  HomeViewState.swift
//  MilkyWay
//
//  Created by Andreas von Holy on 2021/07/12.
//

import Foundation

enum HomeViewState {
    case loading
    case success
    case empty
    case failure(error: NetworkError)
}

extension HomeViewState: Equatable {
    static func == (lhs: HomeViewState, rhs: HomeViewState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case (.success, .success): return true
        case (.empty, .empty): return true
        case (.failure, .failure): return true
        default: return false
        }
    }
}
