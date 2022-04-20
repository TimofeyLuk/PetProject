//
//  SearchBar.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 18.04.22.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var searchText: String
    private var isEditing: Bool { !searchText.isEmpty }
    var onCommit: (() -> Void)?
    var onCancel: (() -> Void)?

    var body: some View {
        HStack {
            TextField("Serch".localized,
                      text: $searchText,
                      onCommit: {
                self.onCommit?()
            })
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal, 10)
            
            if isEditing {
                Button(action: {
                    self.searchText = ""
                    onCancel?()
                }) {
                    Image(systemName: "xmark.circle")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(searchText: .constant(""))
    }
}
