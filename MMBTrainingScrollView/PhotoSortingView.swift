//
//  ContentView.swift
//  MMBTrainingScrollView
//
//  Created by Yoni Stein on 22/02/2023.
//

import SwiftUI
import ComposableArchitecture

struct PhotoSortingFeature: ReducerProtocol {
    struct State: Equatable {
        var items: IdentifiedArrayOf<Item> = [
            Item(title: "FEW",//"Data & Time",
                 text: "",// "Your photos will be ordered chronologically by date and time.",
                 itemOption: .DateAndTime, isSelected: true, id: UUID()),
            Item(title: "Data & Time",
                 text: "Your photos will be ordered chronologically by date and time.",
                 itemOption: .DateAndTime, isSelected: false, id: UUID()),
            Item(title: "Themes",
                 text: "Tell us how you'd like to organize your photos. by filename, for example.", itemOption: .Themes, isSelected: false, id: UUID())
        ]
        
        var header = Header(title: "Photo Sorting", text: "How to set the photos for your photo book?")
        var themeCustomeText: String = ""

    }
    
    enum Action: Equatable {
        case itemTapped(id: Item.ID)
        case nextButtonTapped
        case backgroundTapped(userText: String)
        case previousButtonTapped
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
            
        case .itemTapped(id: let id):
            moveBorderToSelected(id: id, state: &state)
            return .none
            
        case .nextButtonTapped:
            resignKeyboard()
            return .none
            
        case .backgroundTapped(userText: let userText):
            resignKeyboardAndSave(userText: userText, state: &state)
            return .none
            
        case .previousButtonTapped:
            return .none
        }
    }
    
    private func resignKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil,for: nil)
    }
    
    private func resignKeyboardAndSave(userText: String, state: inout PhotoSortingFeature.State) {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil,for: nil)
        state.themeCustomeText = userText
    }
    
    private func moveBorderToSelected(id: UUID, state: inout PhotoSortingFeature.State) {
        for item in state.items {
            if item.id == id {
                state.items[id: item.id]?.isSelected = true
            } else {
                state.items[id: item.id]?.isSelected = false
            }
        }
    }
}

struct PhotoSortingView: View {
    let store: StoreOf<PhotoSortingFeature>
    @State private var userText: String = ""

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { ViewStore in
            NavigationView {
                ZStack {
                    Color.gray.opacity(0.1)
                        .ignoresSafeArea()
                    VStack (alignment: .leading) {
                        HeaderView(title: ViewStore.header.title, text: ViewStore.header.text)
                        ScrollView {
                            ForEach(ViewStore.items) { item in
                                ItemView(title: item.title,
                                         text: item.text,
                                         userText: $userText,
                                         isSelected: item.isSelected,
                                         itemOption: item.itemOption)
                                    .onTapGesture {
                                        ViewStore.send(.itemTapped(id: item.id))
                                    }
                            }
                        }
                        Spacer()
                        ButtonsView(store: self.store)
                    }
                }
                .onTapGesture {
                    ViewStore.send(.backgroundTapped(userText: userText))
                }
            }
        }
    }
}




struct Item: Equatable, Identifiable {
    var title: String
    var text: String
    var itemOption: ItemOption
    var isSelected: Bool
    var image: UIImage?
    var id: UUID
}

struct Header: Equatable {
    var title: String
    var text: String
}

struct HeaderView: View {
    let title: String
    let text: String
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(title)
                .font(.system(size: 25))
                .bold()
                .padding(.bottom)
            Text(text)
                .font(.subheadline)
        }
        .padding(30)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoSortingView(store: Store(initialState: PhotoSortingFeature.State(),
                                      reducer: PhotoSortingFeature()
                                     )
        )
    }
}
