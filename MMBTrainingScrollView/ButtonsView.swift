//
//  ButtonsView.swift
//  MMBTrainingScrollView
//
//  Created by Yoni Stein on 22/02/2023.
//

import SwiftUI
import ComposableArchitecture

struct ButtonsView: View {
    let store: StoreOf<PhotoSortingFeature>
    let isPreviousExist: Bool = false
    let buttonWidth = UIScreen.main.bounds.size.width * 0.45
    let buttonHeight: CGFloat = 40
    let buttonOrangeColor = UIColor(red: 0.94, green: 0.33, blue: 0.14, alpha: 1.0)
    
    
    var body: some View {
        WithViewStore(self.store, observe: {$0}) { ViewStore in
            HStack {
                if isPreviousExist {
                    Button("PREVIOUS") {
                        ViewStore.send(.previousButtonTapped)
                    }
                    .frame(width: buttonWidth, height: buttonHeight)
                    .background(.white)
                    .foregroundColor(.gray)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray))
                } else {
                    Spacer()
                }
                Button("NEXT") {
                    ViewStore.send(.nextButtonTapped)
                }
                .frame(width: buttonWidth, height: buttonHeight)
                .background(Color(uiColor: buttonOrangeColor))
                .foregroundColor(.white)
                .cornerRadius(5)
            }
            .padding(10)
        }
    }
}

struct ButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonsView(store: Store(initialState: PhotoSortingFeature.State(),
                                 reducer: PhotoSortingFeature()))
    }
}
