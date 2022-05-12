//
//  SeachReqestModel.swift
//  PetProject
//
//  Created by Тимофей Лукашевич on 4.05.22.
//

import Foundation

struct SearchReqestModel: Identifiable {
    private(set) var id: UUID = UUID()
    let searchText: String
    private(set) var date: Date = Date()
    
    init(searchText: String) {
        self.searchText = searchText
    }
    
    init?(savedReqest: SavedSearchReqest) {
        guard
            let savedId = savedReqest.id,
            let savedSearchText = savedReqest.searchText,
            let savedDate = savedReqest.date
        else { return nil }
        
        self.id = savedId
        self.searchText = savedSearchText
        self.date = savedDate
    }
}

extension SavedSearchReqest {
    func setByModel(_ model: SearchReqestModel) {
        id = model.id
        searchText = model.searchText
        date = model.date
    }
}
