//
//  MMBTrainingScrollViewApp.swift
//  MMBTrainingScrollView
//
//  Created by Yoni Stein on 22/02/2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct MMBTrainingScrollViewApp: App {
    var body: some Scene {
        WindowGroup {
            PhotoSortingView(store: Store(initialState: PhotoSortingFeature.State(),
                                          reducer: PhotoSortingFeature()
                                         )
            )
        }
    }
}
