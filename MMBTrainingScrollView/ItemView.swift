//
//  ItemView.swift
//  MMBTrainingScrollView
//
//  Created by Yoni Stein on 22/02/2023.
//

import SwiftUI

enum ItemOption {
    case DateAndTime
    case Themes
}

struct ItemView: View {
    var title: String
    var text: String
    @Binding var userText: String
    var isSelected: Bool
    var itemOption: ItemOption
    var image = UIImage(named:"flower")
    let itemHeight: CGFloat = 100
    
    var body: some View {
        if text.isEmpty {
            HStack {
                HStack {
                    Text(title)
                        .font(.system(size: 20))
                        .bold()
                        .padding(5)
                    ImageView(image: image)
                }
                Spacer()
            }
            .frame(height: itemHeight)
            .padding(10)
            .background(.white)
            .cornerRadius(10)
            .if(isSelected) { view in
                view
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 4))
            }
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
        } else {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.system(size: 20))
                        .bold()
                        .padding(5)
                    
                    if itemOption == .Themes  {
                        EditingTextView(placeholder: text, userText: $userText)
                    } else {
                        SimpleTextView(text: text)
                    }
                }
                Spacer()
            }
            .frame(height: itemHeight)
            .padding(10)
            .background(.white)
            .cornerRadius(10)
            .if(isSelected) { view in
                view
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 4))
            }
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
        }
    }
}

struct SimpleTextView: View {
    let text: String
    var extraPadding: Bool = false
    var body: some View {
        Text(text)
            .foregroundColor(Color.primary.opacity(0.25))
            .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0))
            .padding(extraPadding ? 25 : 5)
            .lineLimit(nil)
    }
}

struct ImageView: View {
    let image: UIImage?
    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .padding(10)
        } else {
            Spacer()
        }
    }
}

struct EditingTextView: View {
    let placeholder: String
    @Binding var userText: String
    var body: some View {
        ZStack(alignment: .topLeading) {
            if userText.isEmpty  {
                SimpleTextView(text: placeholder, extraPadding: true)
            }
            TextEditor(text: $userText)
                .padding(5)
                .overlay(RoundedRectangle(cornerRadius: 5)
                .stroke(.gray, lineWidth: 1))
                .padding()
        }.onAppear() {
            UITextView.appearance().backgroundColor = .clear
        }.onDisappear() {
            UITextView.appearance().backgroundColor = nil
        }
    }
}


struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView(title: "Themes", text: "Tell us how you'd like to organize your photos. by filename, for example.", userText: "", isSelected: true, itemOption: .Themes)
    }
}

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
